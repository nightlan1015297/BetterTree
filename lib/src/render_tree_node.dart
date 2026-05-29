import 'dart:math';
import 'package:flutter/rendering.dart';

class TreeNodeParentData extends ContainerBoxParentData<RenderBox> {}

class RenderTreeNode extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TreeNodeParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TreeNodeParentData> {
  double horizontalSpacing;
  double verticalSpacing;
  Color lineColor;
  double lineThickness;

  RenderTreeNode({
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.lineColor,
    required this.lineThickness,
  });

  // The connection point on the left side of this entire tree node
  // relative to its top-left corner.
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

    double totalHeight = max(parentBox.size.height, childrenTotalHeight);
    double totalWidth = parentBox.size.width;
    if (childCount > 0) {
      totalWidth += horizontalSpacing + maxChildWidth;
    }

    size = constraints.constrain(Size(totalWidth, totalHeight));

    // Position parent
    double parentY = (totalHeight - parentBox.size.height) / 2;
    (parentBox.parentData as TreeNodeParentData).offset = Offset(0, parentY);

    // Position children
    if (childCount > 0) {
      double currentY = (totalHeight - childrenTotalHeight) / 2;
      double childrenX = parentBox.size.width + horizontalSpacing;

      child = childAfter(parentBox);
      while (child != null) {
        final parentData = child.parentData as TreeNodeParentData;
        parentData.offset = Offset(childrenX, currentY);
        currentY += child.size.height + verticalSpacing;
        child = childAfter(child);
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
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
        // If the child is a RenderTreeNode, we connect to its visual parent.
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
