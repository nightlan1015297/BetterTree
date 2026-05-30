import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('BetterTreeExample smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our Root Node is present.
    expect(find.text('Root Node'), findsOneWidget);

    // Verify that Child 1 and Child 2 are present (expanded by default in main.dart)
    expect(find.text('Child 1'), findsOneWidget);
    expect(find.text('Child 2'), findsOneWidget);

    // Verify that Grandchild 1.1 is present (Child 1 is expanded)
    expect(find.text('Grandchild 1.1'), findsOneWidget);

    // Verify that Grandchild 2.1 is NOT present (Child 2 is collapsed)
    expect(find.text('Grandchild 2.1'), findsNothing);
  });
}
