import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optimized_search_field/optimized_search_field.dart';

void main() {
  const testText = 'item';
  const textFieldKey = Key('text_field');
  const textFieldKey2 = Key('text_field_2');
  const listdKey = Key('list');
  const listdItemsKey = Key('list_item');
  const selectedListKey = Key('selected_list');
  const selectedListdItemsKey = Key('selected_list_item');
  final values = List.generate(
    100000,
    (index) => 'item ${index + 1}',
  );
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

  testWidgets('Base Search Field', (tester) async {
    final textValues = ValueNotifier<List<String>>([]);
    await initTest(
      tester: tester,
      child: Column(
        children: [
          const TextField(
            key: textFieldKey2,
          ),
          ValueListenableBuilder<List<String>>(
            valueListenable: textValues,
            builder: (BuildContext context, List<String> list, child) {
              return BaseMultiSearchField<String>(
                onSelected: (text) => textValues.value = List.from(
                  textValues.value,
                )..add(text),
                removeEvent: (value) => textValues.value = List.from(
                  textValues.value,
                )..remove(value),
                labelText: 'Enter Item',
                item: Text.new,
                dropDownList: values,
                values: list,
                showErrorText: true,
                errorText: 'Error',
                getItemText: null,
                itemStyle: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                selectedItemStyle: const ButtonStyle(),
                selectedListKey: selectedListKey,
                selectedListItemKey: selectedListdItemsKey,
                listItemKey: listdItemsKey,
                textFieldKey: textFieldKey,
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty || values.isEmpty) {
                    return values;
                  }

                  return values.where(
                    (element) => element.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                  );
                },
                listButtonItem: ({
                  required index,
                  required isEnabled,
                  required key,
                  required onPressed,
                  required value,
                }) =>
                    TextButton(
                  key: key,
                  onPressed: isEnabled ? onPressed : null,
                  child: Text(value),
                ),
                menuList: ({required item, required length}) =>
                    ListView.builder(
                  key: listdKey,
                  itemCount: length,
                  itemBuilder: (context, index) => item(index),
                ),
                customTextField: ({
                  required controller,
                  required focusNode,
                  required key,
                  required onChanged,
                  required suffixIcon,
                  required textFieldKey,
                  required onSubmitted,
                }) =>
                    SizedBox(
                  key: textFieldKey,
                  child: TextField(
                    key: key,
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      suffixIcon: suffixIcon,
                    ),
                    onSubmitted: onSubmitted,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );

    expect(find.byKey(textFieldKey), findsOneWidget);

    expect(find.byKey(listdKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);

    expect(find.byKey(selectedListKey), findsNothing);

    expect(find.byKey(selectedListdItemsKey), findsNothing);

    expect(textValues.value.length, 0);

    await tester.tap(find.byKey(textFieldKey));

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsOneWidget);

    expect(find.byKey(listdItemsKey), findsWidgets);

    expect(find.byKey(selectedListKey), findsNothing);

    expect(find.byKey(selectedListdItemsKey), findsNothing);

    expect(textValues.value.length, 0);

    await tester.enterText(find.byKey(textFieldKey), testText);

    await tester.pumpAndSettle();

    expect(find.text(testText), findsOneWidget);

    expect(find.byKey(listdKey), findsOneWidget);

    expect(find.byKey(listdItemsKey), findsWidgets);

    expect(find.byKey(selectedListKey), findsNothing);

    expect(find.byKey(selectedListdItemsKey), findsNothing);

    await tester.tap(find.byKey(textFieldKey2));

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);

    expect(textValues.value.contains(testText), isTrue);

    expect(find.byKey(selectedListKey), findsOneWidget);

    expect(find.byKey(selectedListdItemsKey), findsOneWidget);

    await tester.tap(find.byKey(textFieldKey));

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(textFieldKey), testText);

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsOneWidget);

    expect(find.byKey(listdItemsKey), findsWidgets);

    expect(find.byKey(selectedListKey), findsOneWidget);

    expect(find.byKey(selectedListdItemsKey), findsOneWidget);

    expect(textValues.value.length, 1);

    await tester.testTextInput.receiveAction(TextInputAction.done);

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);

    expect(find.byKey(selectedListKey), findsOneWidget);

    expect(find.byKey(selectedListdItemsKey), findsWidgets);

    expect(textValues.value.length, 2);
  });
}
