class MindMapNode<T> {
  T data;
  List<MindMapNode<T>> children;
  bool isExpanded;

  MindMapNode({
    required this.data,
    List<MindMapNode<T>>? children,
    this.isExpanded = false,
  }) : children = children ?? [];
}
