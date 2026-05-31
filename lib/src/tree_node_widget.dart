import 'package:flutter/widgets.dart';
import 'render_tree_node.dart';

class TreeNodeWidget extends MultiChildRenderObjectWidget {
  final double horizontalSpacing;
  final double verticalSpacing;
  final Color lineColor;
  final double lineThickness;
  final double animationValue;

  const TreeNodeWidget({
    super.key,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.lineColor,
    required this.lineThickness,
    this.animationValue = 1.0,
    required super.children,
  });

  @override
  RenderTreeNode createRenderObject(BuildContext context) {
    return RenderTreeNode(
      horizontalSpacing: horizontalSpacing,
      verticalSpacing: verticalSpacing,
      lineColor: lineColor,
      lineThickness: lineThickness,
      animationValue: animationValue,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderTreeNode renderObject) {
    bool needsLayout = false;
    bool needsPaint = false;

    if (renderObject.horizontalSpacing != horizontalSpacing) {
      renderObject.horizontalSpacing = horizontalSpacing;
      needsLayout = true;
    }
    if (renderObject.verticalSpacing != verticalSpacing) {
      renderObject.verticalSpacing = verticalSpacing;
      needsLayout = true;
    }
    if (renderObject.lineColor != lineColor) {
      renderObject.lineColor = lineColor;
      needsPaint = true;
    }
    if (renderObject.lineThickness != lineThickness) {
      renderObject.lineThickness = lineThickness;
      needsPaint = true;
    }
    if (renderObject.animationValue != animationValue) {
      renderObject.animationValue = animationValue;
      needsLayout = true;
    }

    if (needsLayout) renderObject.markNeedsLayout();
    if (needsPaint && !needsLayout) renderObject.markNeedsPaint();
  }
}
