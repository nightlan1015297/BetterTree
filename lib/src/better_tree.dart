import 'package:flutter/material.dart';
import 'better_tree_node.dart';
import 'tree_node_widget.dart';

typedef NodeBuilder<T> = Widget Function(BetterTreeNode<T> node);

class BetterTree<T> extends StatefulWidget {
  final BetterTreeNode<T> rootNode;
  final NodeBuilder<T> builder;
  final double horizontalSpacing;
  final double verticalSpacing;
  final Color lineColor;
  final double lineThickness;

  const BetterTree({
    super.key,
    required this.rootNode,
    required this.builder,
    this.horizontalSpacing = 40.0,
    this.verticalSpacing = 20.0,
    this.lineColor = Colors.grey,
    this.lineThickness = 2.0,
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
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: _buildNode(widget.rootNode),
      ),
    );
  }

  Widget _buildNode(BetterTreeNode<T> node) {
    Widget nodeWidget = widget.builder(node);

    // If it has children, optionally add an expand/collapse button
    if (node.children.isNotEmpty) {
      nodeWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          nodeWidget,
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              setState(() {
                node.isExpanded = !node.isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey),
              ),
              child: Icon(
                node.isExpanded ? Icons.remove : Icons.add,
                size: 16,
                color: Colors.black,
              ),
            ),
          )
        ],
      );
    }

    List<Widget> childrenWidgets = [];
    if (node.isExpanded && node.children.isNotEmpty) {
      childrenWidgets = node.children.map((child) => _buildNode(child)).toList();
    }

    return TreeNodeWidget(
      horizontalSpacing: widget.horizontalSpacing,
      verticalSpacing: widget.verticalSpacing,
      lineColor: widget.lineColor,
      lineThickness: widget.lineThickness,
      children: [
        // The first child is the parent visual node
        nodeWidget,
        // The subsequent children are the sub-trees
        ...childrenWidgets,
      ],
    );
  }
}
