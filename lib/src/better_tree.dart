import 'package:flutter/material.dart';
import 'better_tree_node.dart';
import 'better_tree_node_wrapper.dart';

class BetterTree<T> extends StatefulWidget {
  final BetterTreeNode<T> rootNode;
  final NodeBuilder<T> builder;
  final double horizontalSpacing;
  final double verticalSpacing;
  final Color lineColor;
  final double lineThickness;
  final Duration animationDuration;

  const BetterTree({
    super.key,
    required this.rootNode,
    required this.builder,
    this.horizontalSpacing = 40.0,
    this.verticalSpacing = 20.0,
    this.lineColor = Colors.grey,
    this.lineThickness = 2.0,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<BetterTree<T>> createState() => _BetterTreeState<T>();
}

class _BetterTreeState<T> extends State<BetterTree<T>> {
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: 0.1,
      maxScale: 5.0,
      // Adjust interaction physics to be smoother for web/mouse scroll
      panAxis: PanAxis.free,
      scaleEnabled: true,
      trackpadScrollCausesScale: true,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: BetterTreeNodeWrapper<T>(
          node: widget.rootNode,
          builder: widget.builder,
          horizontalSpacing: widget.horizontalSpacing,
          verticalSpacing: widget.verticalSpacing,
          lineColor: widget.lineColor,
          lineThickness: widget.lineThickness,
          animationDuration: widget.animationDuration,
        ),
      ),
    );
  }
}
