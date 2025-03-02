import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:optimized_search_field/base_multi_search_field.dart';

/// A widget that provides a multi-select search field with dropdown options.
class MultiSearchField extends StatelessWidget {
  const MultiSearchField({
    required this.labelText,
    required this.dropDownList,
    required this.removeEvent,
    required this.fieldSuffixIcon,
    required this.values,
    required this.onSelected,
    this.selectListSpacing = 8,
    this.selectListItemSpacing = 8,
    this.selectListItemRunSpacing = 8,
    this.menuMaxHeight = 400,
    this.menuMargin = const EdgeInsets.only(top: 4, bottom: 8),
    this.listPadding = const EdgeInsets.symmetric(vertical: 16),
    this.listClipBehavior = Clip.hardEdge,
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
    this.listButtonItem,
    this.listCacheExtent,
    this.listAddSemanticIndexes = true,
    this.listController,
    this.listRestorationId,
    this.listSemanticChildCount,
    this.listDragStartBehavior = DragStartBehavior.start,
    this.listPhysics,
    this.listPrimary,
    this.menuList,
    this.fieldIconKey,
    this.listKey,
    this.listItemKey,
    this.selectedListKey,
    this.selectedListItemKey,
    this.selectedWidget,
  }) : super(key: key);

  /// Callback for text change
  final void Function(String text)? onSelected;

  /// Label text for the search field
  final String labelText;

  /// List of dropdown items
  final List<String> dropDownList;

  /// Whether to show the error text
  final bool? showErrorText;

  /// Error text for the search field
  final String? errorText;

  /// List of selected values
  final List<String>? values;

  /// Callback for removing an item
  final void Function(String value)? removeEvent;

  /// Key for the text field
  final Key? textFieldKey;

  /// Maximum number of lines for the error text
  final int? errorMaxLines;

  /// Description for the search field
  final String? description;

  /// All elements text
  final String? allElements;

  /// Whether the search field is required
  final bool? isRequired;

  /// Style for the dropdown items
  final TextStyle? itemTextStyle;

  /// Spacing between selected items
  final double selectListSpacing;

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

  /// Suffix icon for the search field
  final Widget Function({
    required VoidCallback onCloseIconTap,
    required bool menuOpened,
    required VoidCallback onlyCloseMenu,
  })? fieldSuffixIcon;

  /// Maximum number of lines for the selected item
  final int? selectedItemMaxLines;

  /// Style for the selected item
  final ButtonStyle? selectedItemStyle;

  /// Text style for the selected item
  final TextStyle? selectedItemTextStyle;

  /// Clip behavior for the selected item
  final Clip? selectedItemClipBehavior;

  /// Icon for the selected item
  final Widget? selectedItemIcon;

  /// Spacing for the selected item
  final double? selectedItemSpacing;

  /// Text alignment for the selected item
  final TextAlign? selectedItemTextAlign;

  /// Text overflow for the selected item
  final TextOverflow? selectedItemTextOverflow;

  /// Input formatters for the search field
  final List<TextInputFormatter>? fieldInputFormatters;

  /// Custom text field widget
  final Widget Function({
    required GlobalKey key,
    required Key? textFieldKey,
    required Widget? suffixIcon,
    required TextEditingController controller,
    required FocusNode focusNode,
    required void Function(String)? onChanged,
    required void Function(String)? onSubmitted,
  })? customTextField;

  /// Run spacing between items in the list
  final double selectListItemRunSpacing;

  /// Spacing between items in the list
  final double selectListItemSpacing;

  /// Controller for the search field
  final TextEditingController? controller;

  /// Focus node for the search field
  final FocusNode? focusNode;

  /// Style for the label text
  final TextStyle? labelTextStyle;

  /// Custom list item widget
  final Widget Function({
    required Key? key,
    required String value,
    required bool isEnabled,
    required int index,
    required void Function() onPressed,
  })? listButtonItem;

  final double? listCacheExtent;
  final bool listAddSemanticIndexes;
  final ScrollController? listController;
  final String? listRestorationId;
  final int? listSemanticChildCount;
  final DragStartBehavior listDragStartBehavior;
  final ScrollPhysics? listPhysics;
  final bool? listPrimary;

  /// Custom list widget
  final Widget Function({
    required int length,
    required Widget Function(int index) item,
  })? menuList;

  final Key? fieldIconKey;

  final Key? listKey;

  final Key? listItemKey;

  final Key? selectedListKey;

  final Key? selectedListItemKey;

  // Widget for the selected item
  final Widget Function(String value)? selectedWidget;

  @override
  Widget build(BuildContext context) {
    return BaseMultiSearchField<String>(
      textFieldKey: textFieldKey,
      onSelected: onSelected,
      labelText: labelText,
      dropDownList: dropDownList,
      allElements: allElements,
      isRequired: isRequired,
      values: values,
      removeEvent: removeEvent,
      showErrorText: showErrorText,
      errorText: errorText,
      getItemText: (value) => value,
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
      fieldSuffixIcon: fieldSuffixIcon,
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
      listButtonItem: listButtonItem,
      listCacheExtent: listCacheExtent,
      listAddSemanticIndexes: listAddSemanticIndexes,
      listController: listController,
      listRestorationId: listRestorationId,
      listSemanticChildCount: listSemanticChildCount,
      listDragStartBehavior: listDragStartBehavior,
      listPhysics: listPhysics,
      listPrimary: listPrimary,
      menuList: menuList,
      fieldIconKey: fieldIconKey,
      listKey: listKey,
      listItemKey: listItemKey,
      selectListItemSpacing: selectListItemSpacing,
      selectedListItemKey: selectedListItemKey,
      selectedListKey: selectedListKey,
      selectedWidget: selectedWidget,
    );
  }
}
