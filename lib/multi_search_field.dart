import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'based_multi_search_field.dart';

/// A widget that provides a multi-select search field with dropdown options.
class MultiSearchField extends StatelessWidget {
  const MultiSearchField({
    required this.labelText,
    required this.dropDownList,
    required this.removeEvent,
    required this.values,
    required this.onChanged,
    this.selectListSpacing = 8,
    this.selectListItemSpacing = 8,
    this.selectListItemRunSpacing = 8,
    this.menuMaxHeight = 400,
    this.menuMargin = const EdgeInsets.only(top: 4, bottom: 8),
    this.listPadding = const EdgeInsets.symmetric(vertical: 16),
    this.listClipBehavior = Clip.hardEdge,
    this.fieldActiveIcon = const Icon(Icons.close),
    this.fieldInactiveIcon = const Icon(Icons.arrow_drop_down),
    this.usePrototype = true,
    this.textFieldKey,
    Key? key,
    this.showErrorText,
    this.errorText,
    this.errorMaxLines,
    this.description,
    this.allElements,
    this.isRequired,
    this.itemTextStyle,
    this.menuDecoration,
    this.itemsSpace,
    this.itemStyle,
    this.fieldDecoration,
    this.fieldSuffixIcon,
    this.selectedItemMaxLines,
    this.selectedItemStyle,
    this.selectedItemTextStyle,
    this.selectedItemClipBehavior,
    this.selectedItemIcon,
    this.selectedItemSpacing,
    this.selectedItemTextAlign,
    this.selectedItemTextOverflow,
    this.customTextField,
    this.fieldInputFormatters,
    this.controller,
    this.focusNode,
    this.labelTextStyle,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.listItem,
  }) : super(key: key);

  // Callback for text change
  final void Function(String text)? onChanged;

  // Label text for the search field
  final String labelText;

  // List of dropdown items
  final List<String> dropDownList;

  // Whether to show the error text
  final bool? showErrorText;

  // Error text for the search field
  final String? errorText;

  // List of selected values
  final List<String>? values;

  // Callback for removing an item
  final void Function(String value)? removeEvent;

  // Key for the text field
  final Key? textFieldKey;

  // Maximum number of lines for the error text
  final int? errorMaxLines;

  // Description for the search field
  final String? description;

  // All elements text
  final String? allElements;

  // Whether the search field is required
  final bool? isRequired;

  // Style for the dropdown items
  final TextStyle? itemTextStyle;

  // Spacing between selected items
  final double selectListSpacing;

  // Maximum height for the menu
  final double menuMaxHeight;

  // Margin for the menu
  final EdgeInsets menuMargin;

  // Decoration for the menu
  final BoxDecoration? menuDecoration;

  // Padding for the list inside the menu
  final EdgeInsets listPadding;

  // Space between items in the list
  final double? itemsSpace;

  // Style for the items
  final ButtonStyle? itemStyle;

  // Clip behavior for the list
  final Clip listClipBehavior;

  // Decoration for the search field
  final InputDecoration? fieldDecoration;

  // Active icon for the search field
  final Icon fieldActiveIcon;

  // Inactive icon for the search field
  final Icon fieldInactiveIcon;

  // Suffix icon for the search field
  final Widget? fieldSuffixIcon;

  // Whether to use the prototype
  final bool usePrototype;

  // Maximum number of lines for the selected item
  final int? selectedItemMaxLines;

  // Style for the selected item
  final ButtonStyle? selectedItemStyle;

  // Text style for the selected item
  final TextStyle? selectedItemTextStyle;

  // Clip behavior for the selected item
  final Clip? selectedItemClipBehavior;

  // Icon for the selected item
  final Widget? selectedItemIcon;

  // Spacing for the selected item
  final double? selectedItemSpacing;

  // Text alignment for the selected item
  final TextAlign? selectedItemTextAlign;

  // Text overflow for the selected item
  final TextOverflow? selectedItemTextOverflow;

  // Input formatters for the search field
  final List<TextInputFormatter>? fieldInputFormatters;

  // Custom text field widget
  final Widget Function({required Widget suffixIcon, required GlobalKey key})?
      customTextField;

  // Run spacing between items in the list
  final double selectListItemRunSpacing;

  // Spacing between items in the list
  final double selectListItemSpacing;

  // Controller for the search field
  final TextEditingController? controller;

  // Focus node for the search field
  final FocusNode? focusNode;

  final TextStyle? labelTextStyle;

  final OptionsViewOpenDirection optionsViewOpenDirection;

  // Custom list item widget
  final Widget Function({
    required String value,
    required bool isEnabled,
    required int index,
    required void Function() onPressed,
  })? listItem;

  @override
  Widget build(BuildContext context) {
    return BasicMultiSearchField<String>(
      textFieldKey: textFieldKey,
      onChanged: onChanged,
      labelText: labelText,
      dropDownList: dropDownList,
      allElements: allElements,
      isRequired: isRequired,
      values: values,
      removeEvent: removeEvent,
      showErrorText: showErrorText,
      errorText: errorText,
      getItemText: null,
      errorMaxLines: errorMaxLines,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty || dropDownList.isEmpty) {
          return dropDownList;
        }

        return dropDownList
            .where(
              (element) => element.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
            )
            .toList();
      },
      item: (element) => Text(element, style: itemTextStyle),
      description: description,
      selectListSpacing: selectListSpacing,
      menuMaxHeight: menuMaxHeight,
      menuMargin: menuMargin,
      menuDecoration: menuDecoration,
      listPadding: listPadding,
      itemsSpace: itemsSpace,
      itemStyle: itemStyle,
      listClipBehavior: listClipBehavior,
      fieldDecoration: fieldDecoration,
      fieldActiveIcon: fieldActiveIcon,
      fieldInactiveIcon: fieldInactiveIcon,
      fieldSuffixIcon: fieldSuffixIcon,
      usePrototype: usePrototype,
      customTextField: customTextField,
      selectedItemMaxLines: selectedItemMaxLines,
      selectedItemStyle: selectedItemStyle,
      selectedItemTextStyle: selectedItemTextStyle,
      selectedItemClipBehavior: selectedItemClipBehavior,
      selectedItemIcon: selectedItemIcon,
      selectedItemSpacing: selectedItemSpacing,
      selectedItemTextAlign: selectedItemTextAlign,
      selectedItemTextOverflow: selectedItemTextOverflow,
      fieldInputFormatters: fieldInputFormatters,
      selectListItemRunSpacing: selectListItemRunSpacing,
      controller: controller,
      focusNode: focusNode,
      labelTextStyle: labelTextStyle,
      optionsViewOpenDirection: optionsViewOpenDirection,
      listItem: listItem,
    );
  }
}
