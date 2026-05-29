import 'package:flutter/material.dart';
import 'package:mind_map_tree/mind_map_tree.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Map Tree Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MindMapExample(),
    );
  }
}

class MindMapExample extends StatefulWidget {
  const MindMapExample({super.key});

  @override
  State<MindMapExample> createState() => _MindMapExampleState();
}

class _MindMapExampleState extends State<MindMapExample> {
  late MindMapNode<String> rootNode;

  @override
  void initState() {
    super.initState();
    // Build a sample mind map tree
    rootNode = MindMapNode<String>(
      data: 'Root Node',
      isExpanded: true,
      children: [
        MindMapNode<String>(
          data: 'Child 1',
          isExpanded: true,
          children: [
            MindMapNode<String>(data: 'Grandchild 1.1'),
            MindMapNode<String>(data: 'Grandchild 1.2'),
          ],
        ),
        MindMapNode<String>(
          data: 'Child 2',
          isExpanded: false,
          children: [
            MindMapNode<String>(data: 'Grandchild 2.1'),
            MindMapNode<String>(data: 'Grandchild 2.2'),
            MindMapNode<String>(data: 'Grandchild 2.3'),
          ],
        ),
      ],
    );
  }

  Widget _buildNodeCard(MindMapNode<String> node) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          node.data,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mind Map Tree'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: MindMapTree<String>(
        rootNode: rootNode,
        builder: _buildNodeCard,
        horizontalSpacing: 60.0,
        verticalSpacing: 30.0,
        lineColor: Colors.blueAccent,
        lineThickness: 3.0,
      ),
    );
  }
}
