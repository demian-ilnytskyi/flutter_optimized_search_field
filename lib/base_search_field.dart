import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'text_field_widget.dart';

/// A base search field widget with customizable options.
class BaseSearchField<T extends Object> extends StatefulWidget {
  const BaseSearchField({
    required this.labelText,
    required this.optionsBuilder,
    required this.item,
    required this.onChanged,
    required this.onSelected,
    required this.getItemText,
    this.itemStyle,
    this.unenabledList = const [],
    this.menuMaxHeight = 400,
    this.menuMargin = const EdgeInsets.only(top: 4, bottom: 8),
    this.listPadding = const EdgeInsets.symmetric(vertical: 16),
    this.itemsSpace,
    this.menuDecoration,
    this.listClipBehavior = Clip.hardEdge,
    this.fieldActiveIcon = const Icon(Icons.close),
    this.fieldInactiveIcon = const Icon(Icons.arrow_drop_down),
    this.textFieldKey,
    this.isRequired,
    this.displayStringForOption,
    super.key,
    this.showErrorText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.unfocusSuffixIcon,
    this.suffixIconPadding,
    this.errorMaxLines,
    this.description,
    this.textStyle,
    this.fieldSuffixIcon,
    this.customTextField,
    this.menuList,
    this.listButtonItem,
    this.fieldDecoration,
    this.useFindChildIndexCallback = true,
    this.usePrototype = true,
    this.fieldInputFormatters,
    this.labelTextStyle,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.initValue,
    this.onFieldSubmitted,
    this.listKey,
    this.listItemKey,
    this.listCacheExtent,
    this.listAddSemanticIndexes = true,
    this.listController,
    this.listRestorationId,
    this.listSemanticChildCount,
    this.listDragStartBehavior = DragStartBehavior.start,
    this.listPhysics,
    this.listPrimary,
    this.fieldIconKey,
  }) : assert(
          !(item == null && listButtonItem == null),
          'Either provide a [listItem] or a custom [listButtonItem].',
        );

  /// Callback for text change
  final void Function(String text)? onChanged;

  /// Label text for the search field
  final String? labelText;

  /// Whether to show the error text
  final bool? showErrorText;

  /// Error text for the search field
  final String? errorText;

  /// Controller for the search field
  final TextEditingController? controller;

  /// Focus node for the search field
  final FocusNode? focusNode;

  /// Widget to display each item
  final Widget Function(T element)? item;

  /// Options builder for the search field
  final FutureOr<Iterable<T>> Function(TextEditingValue) optionsBuilder;

  /// Suffix icon when the field is unfocused
  final Icon? unfocusSuffixIcon;

  /// Callback for item selection
  final void Function(T)? onSelected;

  /// Function to get the display string for the selected item
  final String Function(T value)? displayStringForOption;

  /// Padding for the suffix icon
  final double? suffixIconPadding;

  /// Key for the text field
  final Key? textFieldKey;

  /// Maximum lines for the error text
  final int? errorMaxLines;

  /// Description for the search field
  final String? description;

  /// Text style for the search field
  final TextStyle? textStyle;

  /// List of unenabled items
  final List<T>? unenabledList;

  /// Whether the search field is required
  final bool? isRequired;

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

  /// Active icon for the search field
  final Icon fieldActiveIcon;

  /// Inactive icon for the search field
  final Icon fieldInactiveIcon;

  /// Suffix icon for the search field
  final Widget? fieldSuffixIcon;

  /// Custom list widget
  final Widget Function({
    required int length,
    required Widget Function(int index) item,
  })? menuList;

  /// Custom list item widget
  final Widget Function({
    required Key? key,
    required T value,
    required bool isEnabled,
    required int index,
    required void Function() onPressed,
  })? listButtonItem;

  /// Decoration for the search field
  final InputDecoration? fieldDecoration;

  /// Whether to use the find child index callback
  final bool useFindChildIndexCallback;

  /// Whether to use the prototype
  final bool usePrototype;

  /// Input formatters for the search field
  final List<TextInputFormatter>? fieldInputFormatters;

  /// Custom text field widget
  final Widget Function({
    required GlobalKey key,
    required Key? textFieldKey,
    required Widget suffixIcon,
    required TextEditingController controller,
    required FocusNode focusNode,
    required void Function(String)? onChanged,
    required void Function(String)? onSubmitted,
  })? customTextField;

  /// Style for the label text
  final TextStyle? labelTextStyle;

  /// Direction for the options view
  final OptionsViewOpenDirection optionsViewOpenDirection;

  /// Initial value for the search field
  final TextEditingValue? initValue;

  /// Callback for field submission
  final void Function(String)? onFieldSubmitted;

  final Key? listKey;

  final Key? listItemKey;

  final Key? fieldIconKey;

  final double? listCacheExtent;
  final bool listAddSemanticIndexes;
  final ScrollController? listController;
  final String? listRestorationId;
  final int? listSemanticChildCount;
  final DragStartBehavior listDragStartBehavior;
  final ScrollPhysics? listPhysics;
  final bool? listPrimary;

  // Function to get the text for an item
  final String Function(T value)? getItemText;

  @override
  State<BaseSearchField<T>> createState() => _BaseSearchFieldState();
}

class _BaseSearchFieldState<T extends Object>
    extends State<BaseSearchField<T>> {
  late GlobalKey _anchorKey;
  late GlobalKey _menuKey;
  late TextEditingController controller;
  late FocusNode focusNode;
  late bool showActiveIcon;
  late double? menuHeight;

  @override
  void initState() {
    super.initState();
    _initializeController();
    showActiveIcon = false;
    menuHeight = null;

    _anchorKey = GlobalKey();
    _menuKey = GlobalKey();
  }

  @override
  void didUpdateWidget(covariant BaseSearchField<T> oldWidget) {
    if (widget.menuMaxHeight != oldWidget.menuMaxHeight) {
      menuHeight = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _initializeController() {
    controller = widget.controller ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(_changeIcon);
  }

  double get getWidth {
    final context = _anchorKey.currentContext;
    if (context != null) {
      final box = context.findRenderObject()! as RenderBox;
      return box.hasSize ? box.size.width : double.infinity;
    }
    return double.infinity;
  }

  double get getHeight {
    final context = _anchorKey.currentContext;
    if (context != null) {
      final box = context.findRenderObject()! as RenderBox;
      return box.hasSize ? box.size.height : 0;
    }
    return 0;
  }

  void _changeIcon() => setState(() {
        showActiveIcon = focusNode.hasFocus;
      });

  void setMenuHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _menuKey.currentContext;
      if (context != null) {
        final box = context.findRenderObject()! as RenderBox;
        if (box.hasSize) {
          setState(() {
            menuHeight = box.size.height;
          });
        }
      }
    });
  }

  OptionsViewOpenDirection get optionsViewOpenDirection {
    if (context.findRenderObject() == null) {
      return widget.optionsViewOpenDirection;
    }

    final renderObject = context.findRenderObject();
    // final screenHeight = MediaQuery.sizeOf(context).height;
    // final availableHeight =
    //     screenHeight - (renderBox.localToGlobal(Offset.zero).dy + getHeight);

    if (menuHeight != null && renderObject != null) {
      final renderBox = renderObject as RenderBox;
      final screenHeight = MediaQuery.sizeOf(context).height;
      final buttonPosition = renderBox.localToGlobal(Offset.zero);
      final dy = buttonPosition.dy;
      final availableHeight = screenHeight - (dy + getHeight);
      final hasBottomSpace = availableHeight > menuHeight!;
      final hasTopSpace = dy > menuHeight!;
      switch (widget.optionsViewOpenDirection) {
        case OptionsViewOpenDirection.down:
          if (!hasBottomSpace) {
            return OptionsViewOpenDirection.up;
          }
          break;
        case OptionsViewOpenDirection.up:
          if (!hasTopSpace) {
            return OptionsViewOpenDirection.down;
          }
          break;
      }
    }
    return widget.optionsViewOpenDirection;
  }

  bool buttonEnabled(T option) {
    if (widget.unenabledList == null) {
      return false;
    } else if (widget.unenabledList != null) {
      if (widget.unenabledList!.isNotEmpty &&
          widget.unenabledList!.contains(option)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      optionsBuilder: widget.optionsBuilder,
      focusNode: focusNode,
      textEditingController: controller,
      optionsViewOpenDirection: optionsViewOpenDirection,
      optionsViewBuilder: (context, onSelected, options) {
        Widget getItem(int index) {
          final option = options.elementAt(index);
          final Widget? button;
          void onPressed() {
            if (widget.onChanged == null) {
              onSelected(option);
            } else {
              widget.onSelected?.call(option);
              controller.text =
                  widget.getItemText?.call(option) ?? option.toString();
              focusNode.unfocus();
            }
          }

          if (widget.listButtonItem == null) {
            button = TextButton(
              key: widget.listItemKey,
              onPressed: buttonEnabled(option) ? onPressed : null,
              style: widget.itemStyle,
              child: widget.item!.call(option),
            );
          } else {
            button = null;
          }

          return widget.listButtonItem?.call(
                key: widget.listItemKey,
                value: option,
                isEnabled: buttonEnabled(option),
                index: index,
                onPressed: onPressed,
              ) ??
              (widget.itemsSpace == null
                  ? button!
                  : Padding(
                      key: ValueKey(option),
                      padding: index + 1 >= options.length
                          ? EdgeInsets.zero
                          : EdgeInsets.only(bottom: widget.itemsSpace!),
                      child: button,
                    ));
        }

        final list = Align(
          alignment: optionsViewOpenDirection == OptionsViewOpenDirection.down
              ? Alignment.topLeft
              : Alignment.bottomLeft,
          child: ConstrainedBox(
            key: _menuKey,
            constraints: BoxConstraints(
              maxHeight: widget.menuMaxHeight,
              maxWidth: getWidth,
            ),
            child: widget.menuList?.call(
                  length: options.length,
                  item: getItem,
                ) ??
                Container(
                  margin: widget.menuMargin,
                  decoration: widget.menuDecoration ?? menuDefaultDecoration,
                  clipBehavior: widget.listClipBehavior,
                  child: ListView.builder(
                    key: widget.listKey,
                    shrinkWrap: true,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    padding: widget.listPadding,
                    cacheExtent: widget.listCacheExtent,
                    addSemanticIndexes: widget.listAddSemanticIndexes,
                    controller: widget.listController,
                    restorationId: widget.listRestorationId,
                    semanticChildCount: widget.listSemanticChildCount,
                    dragStartBehavior: widget.listDragStartBehavior,
                    physics: widget.listPhysics,
                    primary: widget.listPrimary,
                    prototypeItem: options.isNotEmpty ? getItem(0) : null,
                    findChildIndexCallback: widget.useFindChildIndexCallback
                        ? (key) {
                            if (key is ValueKey<T>) {
                              try {
                                final index =
                                    options.toList().indexOf(key.value);
                                if (index > 0) {
                                  return index;
                                }
                              } catch (e, stack) {
                                // coverage:ignore-start
                                log(
                                  'OptimizedSearchField: '
                                  'Error in findChildIndexCallback: ',
                                  error: e,
                                  stackTrace: stack,
                                );
                                // coverage:ignore-end
                              }
                            }
                            return null;
                          }
                        : null,
                    itemBuilder: (context, index) => getItem(index),
                    itemCount: options.length,
                  ),
                ),
          ),
        );

        if (menuHeight == null) {
          setMenuHeight();
          return Opacity(opacity: 0, child: list);
        } else {
          return list;
        }
      },
      onSelected: widget.onSelected,
      displayStringForOption: widget.displayStringForOption ??
          RawAutocomplete.defaultStringForOption,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) =>
              widget.customTextField?.call(
                suffixIcon: _suffixIcon,
                key: _anchorKey,
                textFieldKey: widget.textFieldKey,
                controller: controller,
                focusNode: focusNode,
                onChanged: widget.onChanged,
                onSubmitted: widget.onFieldSubmitted,
              ) ??
              _TextFieldWidget(
                key: _anchorKey,
                widgetKey: widget.textFieldKey,
                isRequired: widget.isRequired,
                controller: controller,
                focusNode: focusNode,
                suffixIcon: _suffixIcon,
                onChanged: widget.onChanged,
                labelText: widget.labelText,
                showErrorText: widget.showErrorText,
                errorText: widget.errorText,
                textStyle: widget.textStyle,
                errorMaxLines: widget.errorMaxLines,
                description: widget.description,
                inputFormatters: widget.fieldInputFormatters,
                labelTextStyle: widget.labelTextStyle,
                decoration: widget.fieldDecoration,
                onSubmitted: widget.onFieldSubmitted,
              ),
    );
  }

  Widget get _suffixIcon => Padding(
        key: widget.fieldIconKey,
        padding:
            EdgeInsets.symmetric(horizontal: widget.suffixIconPadding ?? 4),
        child: widget.fieldSuffixIcon ??
            (showActiveIcon
                ? IconButton(
                    icon: widget.fieldActiveIcon,
                    onPressed: () {
                      focusNode.unfocus();
                      controller.clear();
                      widget.onChanged?.call('');
                    },
                  )
                : widget.fieldInactiveIcon),
      );

  @override
  void dispose() {
    focusNode.removeListener(_changeIcon);
    if (widget.controller == null) controller.dispose();
    if (widget.focusNode == null) focusNode.dispose();
    super.dispose();
  }
}

const menuDefaultDecoration = BoxDecoration(
  color: Color(0xfff5f5f3),
  borderRadius: BorderRadius.all(Radius.circular(32)),
  boxShadow: [
    BoxShadow(
      color: Colors.transparent,
      blurRadius: 49,
      offset: Offset(0, 149),
    ),
    BoxShadow(color: Color(0x03000000), blurRadius: 38, offset: Offset(0, 95)),
    BoxShadow(color: Color(0x05000000), blurRadius: 32, offset: Offset(0, 54)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 24, offset: Offset(0, 24)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 13, offset: Offset(0, 6)),
  ],
);
