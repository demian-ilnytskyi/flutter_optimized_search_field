import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'based_search_field.dart';

/// A widget that provides an optimized search field with dropdown options.
class OptimizedSearchField extends StatelessWidget {
  const OptimizedSearchField({
    required this.onChanged,
    required this.labelText,
    required this.dropDownList,
    this.itemStyle,
    this.listPadding = const EdgeInsets.symmetric(vertical: 16),
    this.itemsSpace,
    this.menuMaxHeight = 400,
    this.menuMargin = const EdgeInsets.only(top: 4, bottom: 8),
    this.menuDecoration,
    this.listClipBehavior = Clip.hardEdge,
    this.fieldActiveIcon = const Icon(Icons.close),
    this.fieldInactiveIcon = const Icon(Icons.arrow_drop_down),
    Key? key,
    this.itemTextStyle,
    this.textFieldKey,
    this.showErrorText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.description,
    this.isRequired,
    this.customTextField,
    this.fieldDecoration,
    this.fieldSuffixIcon,
    this.usePrototype = true,
    this.fieldInputFormatters,
    this.optionsBuilder,
    this.labelTextStyle,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.initValue,
    this.listItem,
  })  : assert(
          !(labelText == null && customTextField == null),
          'Either provide a [labelText] or a custom [customTextField].',
        ),
        super(key: key);

  /// Callback for text change
  final void Function(String text)? onChanged;

  /// Label text for the search field
  final String? labelText;

  /// List of dropdown items
  final List<String> dropDownList;

  /// Whether to show the error text
  final bool? showErrorText;

  /// Error text for the search field
  final String? errorText;

  /// Controller for the search field
  final TextEditingController? controller;

  /// Focus node for the search field
  final FocusNode? focusNode;

  /// Key for the text field
  final Key? textFieldKey;

  /// Description for the search field
  final String? description;

  /// Whether the search field is required
  final bool? isRequired;

  /// Style for the dropdown items
  final TextStyle? itemTextStyle;

  /// Maximum height for the menu
  final double menuMaxHeight;

  /// Margin for the menu
  final EdgeInsets menuMargin;

  /// Decoration for the menu
  final BoxDecoration? menuDecoration;

  /// Padding for the list inside the menu
  final EdgeInsets listPadding;

  /// Space between items in the list
  final double? itemsSpace;

  /// Style for the items
  final ButtonStyle? itemStyle;

  /// Clip behavior for the list
  final Clip listClipBehavior;

  /// Decoration for the search field
  final InputDecoration? fieldDecoration;

  /// Active icon for the search field
  final Icon fieldActiveIcon;

  /// Inactive icon for the search field
  final Icon fieldInactiveIcon;

  /// Suffix icon for the search field
  final Widget? fieldSuffixIcon;

  /// Whether to use the prototype
  final bool usePrototype;

  /// Input formatters for the search field
  final List<TextInputFormatter>? fieldInputFormatters;

  /// Options builder for the search field
  final FutureOr<Iterable<String>> Function(TextEditingValue)? optionsBuilder;

  /// Custom text field widget
  final Widget Function({required Widget suffixIcon, required GlobalKey key})?
      customTextField;

  /// Style for the label text
  final TextStyle? labelTextStyle;

  /// Direction for the options view
  final OptionsViewOpenDirection optionsViewOpenDirection;

  /// Initial value for the text field
  final TextEditingValue? initValue;

  /// Custom list item widget
  final Widget Function({
    required String value,
    required bool isEnabled,
    required int index,
    required void Function() onPressed,
  })? listItem;

  @override
  Widget build(BuildContext context) {
    return BasicSearchField<String>(
      labelText: labelText,
      controller: controller,
      errorText: errorText,
      isRequired: isRequired,
      onChanged: onChanged,
      showErrorText: showErrorText,
      items: (element) => Text(element, style: itemTextStyle),
      focusNode: focusNode,
      optionsBuilder: optionsBuilder ??
          (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty || dropDownList.isEmpty) {
              return dropDownList;
            }

            return dropDownList.where(
              (element) => element.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
            );
          },
      onSelectedItem: (String value) => value,
      onSelected: onChanged,
      textFieldKey: textFieldKey,
      description: description,
      isLoading: dropDownList.isEmpty,
      menuMaxHeight: menuMaxHeight,
      menuDecoration: menuDecoration,
      listPadding: listPadding,
      itemsSpace: itemsSpace,
      itemStyle: itemStyle,
      listClipBehavior: listClipBehavior,
      fieldDecoration: fieldDecoration,
      fieldActiveIcon: fieldActiveIcon,
      fieldInactiveIcon: fieldInactiveIcon,
      fieldSuffixIcon: fieldSuffixIcon,
      usePrototype: true,
      fieldInputFormatters: fieldInputFormatters,
      labelTextStyle: labelTextStyle,
      optionsViewOpenDirection: optionsViewOpenDirection,
      initValue: initValue,
      listItem: listItem,
    );
  }
}
