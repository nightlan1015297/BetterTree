import 'package:flutter/material.dart';
import 'package:better_tree/better_tree.dart';

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
      home: const BetterTreeExample(),
    );
  }
}

class BetterTreeExample extends StatefulWidget {
  const BetterTreeExample({super.key});

  @override
  State<BetterTreeExample> createState() => _BetterTreeExampleState();
}

class _BetterTreeExampleState extends State<BetterTreeExample> {
  late BetterTreeNode<String> rootNode;

  @override
  void initState() {
    super.initState();
    // Build a sample mind map tree
    rootNode = BetterTreeNode<String>(
      data: 'Root Node',
      isExpanded: true,
      children: [
        BetterTreeNode<String>(
          data: 'Child 1',
          isExpanded: true,
          children: [
            BetterTreeNode<String>(data: 'Grandchild 1.1'),
            BetterTreeNode<String>(data: 'Grandchild 1.2'),
          ],
        ),
        BetterTreeNode<String>(
          data: 'Child 2',
          isExpanded: false,
          children: [
            BetterTreeNode<String>(data: 'Grandchild 2.1'),
            BetterTreeNode<String>(data: 'Grandchild 2.2'),
            BetterTreeNode<String>(data: 'Grandchild 2.3'),
          ],
        ),
      ],
    );
  }

  Widget _buildNodeCard(BetterTreeNode<String> node) {
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
      body: BetterTree<String>(
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
