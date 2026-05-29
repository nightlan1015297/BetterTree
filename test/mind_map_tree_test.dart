import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_map_tree/mind_map_tree.dart';

void main() {
  testWidgets('MindMapTree renders root and expands correctly', (WidgetTester tester) async {
    final root = MindMapNode<String>(
      data: 'Root',
      children: [
        MindMapNode<String>(data: 'Child 1'),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MindMapTree<String>(
            rootNode: root,
            builder: (node) => Text(node.data),
          ),
        ),
      ),
    );

    // Root should be found
    expect(find.text('Root'), findsOneWidget);

    // Child should not be found initially since isExpanded is false by default
    expect(find.text('Child 1'), findsNothing);

    // Tap the expand button (an Add icon since it is collapsed)
    final expandButton = find.byIcon(Icons.add);
    expect(expandButton, findsOneWidget);

    await tester.tap(expandButton);
    await tester.pumpAndSettle();

    // Now child should be visible
    expect(find.text('Child 1'), findsOneWidget);

    // Tap the collapse button (a Remove icon since it is expanded)
    final collapseButton = find.byIcon(Icons.remove);
    expect(collapseButton, findsOneWidget);

    await tester.tap(collapseButton);
    await tester.pumpAndSettle();

    // Now child should be hidden again
    expect(find.text('Child 1'), findsNothing);
  });
}
