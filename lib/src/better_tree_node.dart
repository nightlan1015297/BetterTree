class BetterTreeNode<T> {
  T data;
  List<BetterTreeNode<T>> children;
  bool isExpanded;

  BetterTreeNode({
    required this.data,
    List<BetterTreeNode<T>>? children,
    this.isExpanded = false,
  }) : children = children ?? [];
}
