import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optimized_search_field/optimized_search_field.dart';

void main() {
  const testText = 'test_text';
  const textFieldKey = Key('text_field');
  const listdKey = Key('list');
  const listdItemsKey = Key('list_item');
  const fieldIconKey = Key('field_icon');
  // Helper function to initialize the test environment
  Future<void> initTest({
    required WidgetTester tester,
    required Widget child,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('Optimized Search Field', (tester) async {
    String? textValue;
    await initTest(
      tester: tester,
      child: OptimizedSearchField(
        onChanged: (text) => textValue = text,
        labelText: 'Enter Item',
        dropDownList: List.generate(
          100000,
          (index) => 'item ${index + 1}',
        ),
        itemStyle: const ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(),
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        optionsViewOpenDirection: OptionsViewOpenDirection.up,
        listKey: listdKey,
        listItemKey: listdItemsKey,
        textFieldKey: textFieldKey,
        fieldIconKey: fieldIconKey,
      ),
    );

    expect(find.byKey(textFieldKey), findsOneWidget);

    expect(find.byKey(listdKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);

    expect(textValue, isNull);

    await tester.tap(find.byKey(textFieldKey));

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsOneWidget);

    expect(find.byKey(listdItemsKey), findsWidgets);

    await tester.tap(find.byKey(listdItemsKey).first);

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);

    expect(textValue, 'item 1');

    await tester.tap(find.byKey(textFieldKey));

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsOneWidget);

    expect(find.byKey(listdItemsKey), findsWidgets);

    await tester.enterText(find.byKey(textFieldKey), testText);

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);

    expect(textValue, testText);

    await tester.enterText(find.byKey(textFieldKey), 'item');

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsOneWidget);

    expect(find.byKey(listdItemsKey), findsWidgets);

    expect(textValue, 'item');

    await tester.tap(find.byKey(textFieldKey));

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsOneWidget);

    expect(find.byKey(listdItemsKey), findsWidgets);

    await tester.tap(find.byKey(fieldIconKey));

    await tester.pumpAndSettle();

    expect(textValue, '');

    expect(find.byKey(listdKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);
  });

  testWidgets('Optimized Search Field When Items has spacing', (tester) async {
    String? textValue;
    await initTest(
      tester: tester,
      child: OptimizedSearchField(
        onChanged: (text) => textValue = text,
        labelText: 'Enter Item',
        dropDownList: List.generate(
          100000,
          (index) => 'item ${index + 1}',
        ),
        itemStyle: const ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(),
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        optionsViewOpenDirection: OptionsViewOpenDirection.up,
        listKey: listdKey,
        listItemKey: listdItemsKey,
        textFieldKey: textFieldKey,
        fieldIconKey: fieldIconKey,
        itemsSpace: 400,
      ),
    );

    expect(find.byKey(textFieldKey), findsOneWidget);

    expect(find.byKey(listdKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);

    expect(textValue, isNull);

    await tester.tap(find.byKey(textFieldKey));

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsOneWidget);

    expect(find.byKey(listdItemsKey), findsOneWidget);

    await tester.tap(find.byKey(listdItemsKey).first);

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);

    expect(textValue, 'item 1');
  });
}
