import 'dart:math';
import 'package:flutter/rendering.dart';

class TreeNodeParentData extends ContainerBoxParentData<RenderBox> {}

class RenderTreeNode extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TreeNodeParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TreeNodeParentData> {
  double _horizontalSpacing;
  double _verticalSpacing;
  Color _lineColor;
  double _lineThickness;
  double _animationValue;

  RenderTreeNode({
    required double horizontalSpacing,
    required double verticalSpacing,
    required Color lineColor,
    required double lineThickness,
    required double animationValue,
  })  : _horizontalSpacing = horizontalSpacing,
        _verticalSpacing = verticalSpacing,
        _lineColor = lineColor,
        _lineThickness = lineThickness,
        _animationValue = animationValue;

  double get horizontalSpacing => _horizontalSpacing;
  set horizontalSpacing(double value) {
    if (_horizontalSpacing == value) return;
    _horizontalSpacing = value;
    markNeedsLayout();
  }

  double get verticalSpacing => _verticalSpacing;
  set verticalSpacing(double value) {
    if (_verticalSpacing == value) return;
    _verticalSpacing = value;
    markNeedsLayout();
  }

  Color get lineColor => _lineColor;
  set lineColor(Color value) {
    if (_lineColor == value) return;
    _lineColor = value;
    markNeedsPaint();
  }

  double get lineThickness => _lineThickness;
  set lineThickness(double value) {
    if (_lineThickness == value) return;
    _lineThickness = value;
    markNeedsPaint();
  }

  double get animationValue => _animationValue;
  set animationValue(double value) {
    if (_animationValue == value) return;
    _animationValue = value;
    markNeedsLayout();
  }

  double get leftConnectionY {
    final parentBox = firstChild;
    if (parentBox == null) return 0;
    final parentData = parentBox.parentData as TreeNodeParentData;
    return parentData.offset.dy + parentBox.size.height / 2;
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! TreeNodeParentData) {
      child.parentData = TreeNodeParentData();
    }
  }

  @override
  void performLayout() {
    RenderBox? parentBox = firstChild;
    if (parentBox == null) {
      size = Size.zero;
      return;
    }

    // Layout the main node
    parentBox.layout(const BoxConstraints(), parentUsesSize: true);

    // Layout children
    double childrenTotalHeight = 0.0;
    double maxChildWidth = 0.0;

    RenderBox? child = childAfter(parentBox);
    int childCount = 0;

    while (child != null) {
      child.layout(const BoxConstraints(), parentUsesSize: true);
      childrenTotalHeight += child.size.height;
      maxChildWidth = max(maxChildWidth, child.size.width);
      childCount++;

      child = childAfter(child);
    }

    if (childCount > 0) {
      childrenTotalHeight += verticalSpacing * (childCount - 1);
    }

    // Calculate maximum sizes (fully expanded)
    double maxTotalHeight = max(parentBox.size.height, childrenTotalHeight);
    double maxTotalWidth = parentBox.size.width;
    if (childCount > 0) {
      maxTotalWidth += horizontalSpacing + maxChildWidth;
    }

    // Interpolate overall size based on animation value
    double animatedHeight = parentBox.size.height + (maxTotalHeight - parentBox.size.height) * animationValue;
    double animatedWidth = parentBox.size.width + (maxTotalWidth - parentBox.size.width) * animationValue;

    size = constraints.constrain(Size(animatedWidth, animatedHeight));

    // Position parent (always centered vertically within the animated total height)
    double parentY = (animatedHeight - parentBox.size.height) / 2;
    (parentBox.parentData as TreeNodeParentData).offset = Offset(0, parentY);

    // Position children if animation is playing or expanded
    if (childCount > 0 && animationValue > 0.0) {
      // The fully expanded Y starting point
      double targetStartY = (maxTotalHeight - childrenTotalHeight) / 2;

      // The fully expanded X starting point
      double targetX = parentBox.size.width + horizontalSpacing;

      // The starting point when collapsed (center of parent node)
      double collapsedX = parentBox.size.width;
      double collapsedY = parentY + parentBox.size.height / 2;

      // Animate children X position
      double childrenX = collapsedX + (targetX - collapsedX) * animationValue;

      child = childAfter(parentBox);
      double currentTargetY = targetStartY;

      while (child != null) {
        final parentData = child.parentData as TreeNodeParentData;

        // Calculate the individual target Y for this child (its exact center Y when fully expanded)
        double childTargetCenterY = currentTargetY + child.size.height / 2;

        // Interpolate the child's center Y between the collapsed Y (parent center) and its expanded target center Y
        double childCurrentCenterY = collapsedY + (childTargetCenterY - collapsedY) * animationValue;

        // Final animated offset
        parentData.offset = Offset(childrenX, childCurrentCenterY - child.size.height / 2);

        currentTargetY += child.size.height + verticalSpacing;
        child = childAfter(child);
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (animationValue == 0.0) {
      // Only paint the parent box if fully collapsed
      RenderBox? parentBox = firstChild;
      if (parentBox != null) {
        final parentData = parentBox.parentData as TreeNodeParentData;
        context.paintChild(parentBox, parentData.offset + offset);
      }
      return;
    }

    RenderBox? parentBox = firstChild;
    if (parentBox == null) return;

    final parentData = parentBox.parentData as TreeNodeParentData;
    final parentOffset = parentData.offset + offset;

    // Paint lines to children
    RenderBox? child = childAfter(parentBox);
    if (child != null) {
      final paint = Paint()
        ..color = lineColor
        ..strokeWidth = lineThickness
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true;

      // The starting point is the center right of the parent node
      final startX = parentOffset.dx + parentBox.size.width;
      final startY = parentOffset.dy + parentBox.size.height / 2;

      while (child != null) {
        final childParentData = child.parentData as TreeNodeParentData;
        final childOffset = childParentData.offset + offset;

        // Determine the target Y.
        double targetY;
        if (child is RenderTreeNode) {
          targetY = childOffset.dy + child.leftConnectionY;
        } else {
          targetY = childOffset.dy + child.size.height / 2;
        }

        final targetX = childOffset.dx;

        final path = Path();
        path.moveTo(startX, startY);

        final controlPointOffset = (targetX - startX) / 2;
        path.cubicTo(
          startX + controlPointOffset, startY,
          targetX - controlPointOffset, targetY,
          targetX, targetY,
        );

        context.canvas.drawPath(path, paint);

        child = childAfter(child);
      }
    }

    // Paint children (including the parent box which is the first child)
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
