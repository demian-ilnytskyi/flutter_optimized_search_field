import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optimized_search_field/optimized_search_field.dart';

void main() {
  const testText = 'test_text';
  const textFieldKey = Key('text_field');
  const listKey = Key('list');
  const listdItemsKey = Key('list_item');
  const selectedListKey = Key('selected_list');
  const selectedListdItemsKey = Key('selected_list_item');
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

  testWidgets('Multi Search Field', (tester) async {
    final textValues = ValueNotifier<List<String>>([]);

    await initTest(
      tester: tester,
      child: ValueListenableBuilder<List<String>>(
        valueListenable: textValues,
        builder: (BuildContext context, List<String> value, child) {
          return MultiSearchField(
            labelText: 'Enter Items',
            dropDownList: List.generate(
              100000,
              (index) => 'item ${index + 1}',
            ),
            removeEvent: (value) =>
                textValues.value = List.from(textValues.value)..remove(value),
            values: value,
            onSelected: (value) =>
                textValues.value = List.from(textValues.value)..add(value),
            listKey: listKey,
            listItemKey: listdItemsKey,
            selectedListItemKey: selectedListdItemsKey,
            selectedListKey: selectedListKey,
            textFieldKey: textFieldKey,
            fieldSuffixIcon: ({
              required menuOpened,
              required onCloseIconTap,
              required onlyCloseMenu,
            }) =>
                menuOpened
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: onCloseIconTap,
                      )
                    : const Icon(Icons.arrow_drop_down),
          );
        },
      ),
    );

    expect(find.byKey(textFieldKey), findsOneWidget);

    expect(find.byKey(listKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);

    expect(find.byKey(selectedListKey), findsNothing);

    expect(find.byKey(selectedListdItemsKey), findsNothing);

    expect(textValues.value.length, 0);

    await tester.tap(find.byKey(textFieldKey));

    await tester.pumpAndSettle();

    expect(find.byKey(listKey), findsOneWidget);

    expect(find.byKey(listdItemsKey), findsWidgets);

    expect(find.byKey(selectedListKey), findsNothing);

    expect(find.byKey(selectedListdItemsKey), findsNothing);

    await tester.tap(find.byKey(listdItemsKey).first);

    await tester.pumpAndSettle();

    expect(find.byKey(listKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);

    expect(find.byKey(selectedListKey), findsOneWidget);

    expect(find.byKey(selectedListdItemsKey), findsOneWidget);

    expect(textValues.value.length, 1);

    await tester.tap(find.byKey(textFieldKey));

    await tester.pumpAndSettle();

    expect(find.byKey(listKey), findsOneWidget);

    expect(find.byKey(listdItemsKey), findsWidgets);

    await tester.enterText(find.byKey(textFieldKey), testText);

    await tester.pumpAndSettle();

    expect(find.byKey(listKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);

    expect(textValues.value.length, 1);

    await tester.tap(find.byKey(selectedListdItemsKey));

    await tester.pumpAndSettle();

    expect(textValues.value.length, 0);

    expect(find.byKey(selectedListKey), findsNothing);

    expect(find.byKey(selectedListdItemsKey), findsNothing);
  });
}
