import 'package:flutter/material.dart';
import 'better_tree_node.dart';
import 'tree_node_widget.dart';

typedef NodeBuilder<T> = Widget Function(BetterTreeNode<T> node);

class BetterTreeNodeWrapper<T> extends StatefulWidget {
  final BetterTreeNode<T> node;
  final NodeBuilder<T> builder;
  final double horizontalSpacing;
  final double verticalSpacing;
  final Color lineColor;
  final double lineThickness;
  final Duration animationDuration;

  const BetterTreeNodeWrapper({
    super.key,
    required this.node,
    required this.builder,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.lineColor,
    required this.lineThickness,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<BetterTreeNodeWrapper<T>> createState() => _BetterTreeNodeWrapperState<T>();
}

class _BetterTreeNodeWrapperState<T> extends State<BetterTreeNodeWrapper<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    if (widget.node.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(BetterTreeNodeWrapper<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.node.isExpanded != oldWidget.node.isExpanded) {
      if (widget.node.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      widget.node.isExpanded = !widget.node.isExpanded;
      if (widget.node.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget nodeWidget = widget.builder(widget.node);

    if (widget.node.children.isNotEmpty) {
      nodeWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          nodeWidget,
          const SizedBox(width: 8),
          InkWell(
            onTap: _toggleExpansion,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey),
              ),
              child: Icon(
                widget.node.isExpanded ? Icons.remove : Icons.add,
                size: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Only render children if the animation is actually running or fully expanded
        List<Widget> childrenWidgets = [];
        if (_controller.value > 0.0 && widget.node.children.isNotEmpty) {
          childrenWidgets = widget.node.children.map((childNode) {
            return FadeTransition(
              opacity: _animation,
              child: BetterTreeNodeWrapper<T>(
                node: childNode,
                builder: widget.builder,
                horizontalSpacing: widget.horizontalSpacing,
                verticalSpacing: widget.verticalSpacing,
                lineColor: widget.lineColor,
                lineThickness: widget.lineThickness,
                animationDuration: widget.animationDuration,
              ),
            );
          }).toList();
        }

        return TreeNodeWidget(
          horizontalSpacing: widget.horizontalSpacing,
          verticalSpacing: widget.verticalSpacing,
          lineColor: widget.lineColor,
          lineThickness: widget.lineThickness,
          animationValue: _animation.value,
          children: [
            nodeWidget,
            ...childrenWidgets,
          ],
        );
      },
    );
  }
}
