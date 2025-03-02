import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optimized_search_field/optimized_search_field.dart';

void main() {
  const textFieldKey = Key('text_field');
  const listdKey = Key('list');
  const listdItemsKey = Key('list_item');
  const fieldIconKey = Key('field_icon');
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
    String? textValue;
    final menuHeigh = ValueNotifier<double>(400);
    await initTest(
      tester: tester,
      child: ValueListenableBuilder<double>(
        valueListenable: menuHeigh,
        builder: (BuildContext context, double value, child) {
          return BaseSearchField<String>(
            onChanged: (text) => textValue = text,
            labelText: 'Enter Item',
            item: null,
            itemStyle: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            getItemText: (value) => value,
            menuMaxHeight: value,
            listItemKey: listdItemsKey,
            textFieldKey: textFieldKey,
            fieldIconKey: fieldIconKey,
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
            onSelected: (value) => textValue = value,
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
            menuList: ({required item, required length}) => ListView.builder(
              key: listdKey,
              itemCount: length,
              itemBuilder: (context, index) => item(index),
            ),
            fieldSuffixIcon: null,
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
    );

    expect(find.byKey(textFieldKey), findsOneWidget);

    expect(find.byKey(listdKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);

    expect(textValue, isNull);

    await tester.tap(find.byKey(textFieldKey));

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsOneWidget);

    expect(find.byKey(listdItemsKey), findsWidgets);

    menuHeigh.value = 200;

    expect(find.byKey(listdKey), findsOneWidget);

    expect(find.byKey(listdItemsKey), findsWidgets);

    await tester.tap(find.byKey(listdItemsKey).first);

    await tester.pumpAndSettle();

    expect(find.byKey(listdKey), findsNothing);

    expect(find.byKey(listdItemsKey), findsNothing);

    expect(textValue, 'item 1');
  });
}
