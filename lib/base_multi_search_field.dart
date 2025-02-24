import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optimized_search_field/optimized_search_field.dart';

part 'selected_chip.dart';

/// A base multi-select search field widget with customizable options.
class BaseMultiSearchField<T extends Object> extends StatefulWidget {
  const BaseMultiSearchField({
    required this.onSelected,
    required this.labelText,
    required this.dropDownList,
    required this.values,
    required this.removeEvent,
    required this.item,
    required this.optionsBuilder,
    required this.getItemText,
    this.errorText,
    this.showErrorText,
    this.selectListSpacing = 8,
    this.selectListItemSpacing = 8,
    this.selectListItemRunSpacing = 8,
    this.menuMaxHeight = 400,
    this.menuMargin = const EdgeInsets.only(top: 4, bottom: 8),
    this.listPadding = const EdgeInsets.symmetric(vertical: 16),
    this.listClipBehavior = Clip.hardEdge,
    this.fieldActiveIcon = const Icon(Icons.close),
    this.fieldInactiveIcon = const Icon(Icons.arrow_drop_down),
    this.textFieldKey,
    this.isRequired,
    Key? key,
    this.trailingList,
    this.unfocusSuffixIcon,
    this.suffixIconPadding,
    this.focusNode,
    this.errorMaxLines,
    this.description,
    this.allElements,
    this.menuDecoration,
    this.itemsSpace,
    this.itemStyle,
    this.fieldDecoration,
    this.fieldSuffixIcon,
    this.customTextField,
    this.selectedWidget,
    this.selectedItemMaxLines,
    this.selectedItemStyle,
    this.selectedItemTextStyle,
    this.selectedItemClipBehavior,
    this.selectedItemIcon,
    this.selectedItemSpacing,
    this.selectedItemTextAlign,
    this.selectedItemTextOverflow,
    this.fieldInputFormatters,
    this.controller,
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
    this.fieldIconKey,
    this.menuList,
    this.listKey,
    this.listItemKey,
    this.selectedListKey,
    this.selectedListItemKey,
  }) : super(key: key);

  // Callback for text change
  final void Function(String text)? onSelected;

  // Label text for the search field
  final String labelText;

  // List of dropdown items
  final List<T> dropDownList;

  // Whether to show the error text
  final bool? showErrorText;

  // Error text for the search field
  final String? errorText;

  // List of selected values
  final List<T>? values;

  // Callback for removing an item
  final void Function(T value)? removeEvent;

  // Focus node for the search field
  final FocusNode? focusNode;

  // List of trailing widgets
  final List<Widget>? trailingList;

  // Widget for each item in the dropdown
  final Widget Function(T element) item;

  // Function to build the options for the dropdown
  final Iterable<T> Function(TextEditingValue) optionsBuilder;

  // Suffix icon for the search field when unfocused
  final Icon? unfocusSuffixIcon;

  // Function to get the text for an item
  final String Function(T value)? getItemText;

  // Padding for the suffix icon
  final double? suffixIconPadding;

  // Key for the text field
  final Key? textFieldKey;

  // Maximum number of lines for the error text
  final int? errorMaxLines;

  // Description for the search field
  final String? description;

  // All elements text
  final T? allElements;

  // Whether the search field is required
  final bool? isRequired;

  // Spacing between selected items
  final double selectListSpacing;

  // Spacing between items in the list
  final double selectListItemSpacing;

  // Run spacing between items in the list
  final double selectListItemRunSpacing;

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

  // Custom text field widget
  final Widget Function({
    required GlobalKey key,
    required Key? textFieldKey,
    required Widget suffixIcon,
    required TextEditingController controller,
    required FocusNode focusNode,
    required void Function(String)? onChanged,
    required void Function(String)? onSubmitted,
  })? customTextField;

  // Widget for the selected item
  final Widget Function(T value)? selectedWidget;

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

  // Controller for the search field
  final TextEditingController? controller;

  final TextStyle? labelTextStyle;

  // Custom list item widget
  final Widget Function({
    required Key? key,
    required T value,
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

  final Key? fieldIconKey;

  /// Custom list widget
  final Widget Function({
    required int length,
    required Widget Function(int index) item,
  })? menuList;

  final Key? listKey;

  final Key? listItemKey;

  final Key? selectedListKey;

  final Key? selectedListItemKey;

  @override
  State<BaseMultiSearchField<T>> createState() =>
      _BaseMultiSearchFieldState<T>();
}

class _BaseMultiSearchFieldState<T extends Object>
    extends State<BaseMultiSearchField<T>> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    controller = widget.controller ?? TextEditingController();
    focusNode = (widget.focusNode ?? FocusNode())..addListener(_unFocusData);
  }

  void _unFocusData() {
    if (!focusNode.hasFocus && controller.text.isNotEmpty) {
      widget.onSelected?.call(controller.text);
      controller.clear();
    }
  }

  bool get selectedValueIsNotEmpty {
    if (widget.values == null && widget.allElements != null) return true;
    if (widget.values != null && widget.values!.isNotEmpty) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseSearchField<T>(
          isRequired: widget.isRequired,
          textFieldKey: widget.textFieldKey,
          labelText: widget.labelText,
          controller: controller,
          errorText: widget.errorText,
          onChanged: null,
          focusNode: focusNode,
          showErrorText: widget.showErrorText,
          optionsBuilder: widget.optionsBuilder,
          unfocusSuffixIcon: widget.unfocusSuffixIcon,
          item: widget.item,
          errorMaxLines: widget.errorMaxLines,
          description: widget.description,
          unenabledList: widget.values == null ||
                  (widget.values?.contains(widget.allElements) ?? false)
              ? null
              : widget.dropDownList
                  .where(
                    (element) => widget.values!.any(
                      (value) => (getItemText(element)) == value,
                    ),
                  )
                  .toList(),
          onSelected: (value) {
            widget.onSelected?.call(getItemText(value));
            controller.clear();
            focusNode.unfocus();
          },
          onFieldSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              widget.onSelected?.call(value);
              controller.clear();
              focusNode.unfocus();
            }
          },
          menuMaxHeight: widget.menuMaxHeight,
          menuMargin: widget.menuMargin,
          menuDecoration: widget.menuDecoration,
          listPadding: widget.listPadding,
          itemsSpace: widget.itemsSpace,
          itemStyle: widget.itemStyle,
          listClipBehavior: widget.listClipBehavior,
          fieldDecoration: widget.fieldDecoration,
          fieldActiveIcon: widget.fieldActiveIcon,
          fieldInactiveIcon: widget.fieldInactiveIcon,
          fieldSuffixIcon: widget.fieldSuffixIcon,
          customTextField: widget.customTextField,
          fieldInputFormatters: widget.fieldInputFormatters,
          labelTextStyle: widget.labelTextStyle,
          listButtonItem: widget.listButtonItem,
          listCacheExtent: widget.listCacheExtent,
          listAddSemanticIndexes: widget.listAddSemanticIndexes,
          listController: widget.listController,
          listRestorationId: widget.listRestorationId,
          listSemanticChildCount: widget.listSemanticChildCount,
          listDragStartBehavior: widget.listDragStartBehavior,
          listPhysics: widget.listPhysics,
          listPrimary: widget.listPrimary,
          fieldIconKey: widget.fieldIconKey,
          menuList: widget.menuList,
          listKey: widget.listKey,
          listItemKey: widget.listItemKey,
          getItemText: widget.getItemText,
        ),
        SizedBox(
          height: widget.selectListSpacing,
        ),
        if (selectedValueIsNotEmpty)
          Wrap(
            key: widget.selectedListKey,
            spacing: widget.selectListItemSpacing,
            runSpacing: widget.selectListItemRunSpacing,
            children: List.generate(
              widget.values?.length ?? (widget.allElements != null ? 1 : 0),
              (index) =>
                  widget.selectedWidget?.call(getValue(index)) ??
                  _SelectedChipWidget(
                    widgetKey: widget.selectedListItemKey,
                    labelText: getItemText(getValue(index)),
                    onPressed: () => widget.removeEvent?.call(getValue(index)),
                    maxLines: widget.selectedItemMaxLines,
                    style: widget.selectedItemStyle,
                    textStyle: widget.selectedItemTextStyle,
                    clipBehavior: widget.selectedItemClipBehavior,
                    icon: widget.selectedItemIcon,
                    spacing: widget.selectListItemSpacing,
                    textAlign: widget.selectedItemTextAlign,
                    textOverflow: widget.selectedItemTextOverflow,
                  ),
            ),
          ),
      ],
    );
  }

  T getValue(int index) => widget.values!.elementAt(index);

  String getItemText(T value) =>
      widget.getItemText?.call(value) ?? value.toString();

  @override
  void dispose() {
    focusNode.removeListener(_unFocusData);
    if (widget.controller == null) controller.dispose();
    if (widget.focusNode == null) focusNode.dispose();
    super.dispose();
  }
}
