import 'dart:async';

import 'package:example/text_field_widget.dart';
import 'package:flutter/material.dart';

class OptimizedSearchField extends StatelessWidget {
  const OptimizedSearchField({
    required this.onChanged,
    required this.labelText,
    required this.dropDownList,
    this.itemStyle,
    this.listPadding = const EdgeInsets.symmetric(vertical: 16),
    this.itemsSpace = 8,
    this.menuMaxHeight = 400,
    this.manuMergin = const EdgeInsets.only(top: 4, bottom: 8),
    this.itemTextStyle,
    this.textFieldKey,
    super.key,
    this.showErrorText,
    this.errorText,
    // this.initialValue,
    this.controller,
    this.focusNode,
    this.description,
    this.isRequired,
    this.menuDecoration,
    this.listPrototypeItem,
    this.listClipBehavior = Clip.none,
  });

  final void Function(String text)? onChanged;
  final String labelText;
  final List<String> dropDownList;
  final bool? showErrorText;
  final String? errorText;
  // final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Key? textFieldKey;
  final String? description;
  final bool? isRequired;
  final TextStyle? itemTextStyle;
  final double menuMaxHeight;
  final EdgeInsets manuMergin;
  final BoxDecoration? menuDecoration;
  final EdgeInsets listPadding;
  final Widget? listPrototypeItem;
  final double itemsSpace;
  final ButtonStyle? itemStyle;
  final Clip listClipBehavior;

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
      onSelectedItem: (String value) => value,
      onSelected: onChanged,
      textFieldKey: textFieldKey,
      description: description,
      isLoading: dropDownList.isEmpty,
      menuMaxHeight: menuMaxHeight,
      menuDecoration: menuDecoration,
      listPadding: listPadding,
      listPrototypeItem: listPrototypeItem,
      itemsSpace: itemsSpace,
      itemStyle: itemStyle,
      listClipBehavior: listClipBehavior,
    );
  }
}

class BasicSearchField<T extends Object> extends StatefulWidget {
  const BasicSearchField({
    required this.labelText,
    required this.optionsBuilder,
    required this.items,
    required this.onChanged,
    required this.onSelected,
    required this.isLoading,
    this.itemStyle,
    this.unenabledList = const [],
    this.menuMaxHeight = 400,
    this.manuMergin = const EdgeInsets.only(top: 4, bottom: 8),
    this.listPadding = const EdgeInsets.symmetric(vertical: 16),
    this.itemsSpace = 8,
    this.menuDecoration,
    this.textFieldKey,
    this.isRequired,
    this.onSelectedItem,
    super.key,
    this.showErrorText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.unfocusSufixIcon,
    this.suffixIconPadding,
    this.errorMaxLines,
    this.description,
    this.textStyle,
    this.listPrototypeItem,
    this.listClipBehavior = Clip.none,
    this.fieldActiveIcon = const Icon(Icons.close),
    this.fieldDeactiveIcon = const Icon(Icons.arrow_drop_down),
    this.fieldSuffixIcon,
    this.textField,
  });

  final void Function(String text)? onChanged;
  final String labelText;
  final bool? showErrorText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget Function(T element) items;
  final FutureOr<Iterable<T>> Function(TextEditingValue) optionsBuilder;
  final Icon? unfocusSufixIcon;
  final void Function(T)? onSelected;
  final String Function(T value)? onSelectedItem;
  // final String? initialValue;
  final double? suffixIconPadding;
  final Key? textFieldKey;
  final int? errorMaxLines;
  final String? description;
  final TextStyle? textStyle;
  final List<T>? unenabledList;
  final bool isLoading;
  final bool? isRequired;
  final double menuMaxHeight;
  final EdgeInsets manuMergin;
  final BoxDecoration? menuDecoration;
  final EdgeInsets listPadding;
  final Widget? listPrototypeItem;
  final double itemsSpace;
  final ButtonStyle? itemStyle;
  final Clip      listClipBehavior;
  final Icon fieldActiveIcon;
  final Icon fieldDeactiveIcon;
  final Widget? fieldSuffixIcon;

  final Widget Function({
    
    
  required Widget suffixIcon, required GlobalKey key,  })?
  textField;

  @override
  State<BasicSearchField<T>> createState() => _BasicSearchFieldState();
}

class _BasicSearchFieldState<T extends Object>
    extends State<BasicSearchField<T>> {
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
  void didUpdateWidget(covariant BasicSearchField<T> oldWidget) {
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
      return OptionsViewOpenDirection.down;
    }

    final renderBox = context.findRenderObject()! as RenderBox;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final availableHeight =
        screenHeight - (renderBox.localToGlobal(Offset.zero).dy + getHeight);
    return availableHeight > (menuHeight ?? widget.menuMaxHeight)
        ? OptionsViewOpenDirection.down
        : OptionsViewOpenDirection.up;
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
      optionsBuilder:
          (textEditingValue) => widget.optionsBuilder(
            TextEditingValue(text: textEditingValue.text.trim()),
          ),
      focusNode: focusNode,
      textEditingController: controller,
      optionsViewOpenDirection: optionsViewOpenDirection,
      optionsViewBuilder: (context, onSelected, options) {
        if (!widget.isLoading && menuHeight == null) setMenuHeight();

        return Align(
          alignment:
              optionsViewOpenDirection == OptionsViewOpenDirection.down
                  ? Alignment.topLeft
                  : Alignment.bottomLeft,
          child: Container(
            key: _menuKey,
            constraints: BoxConstraints(
              maxHeight: widget.menuMaxHeight,
              maxWidth: getWidth,
            ),
            margin: widget.manuMergin,
            decoration: widget.menuDecoration,
            clipBehavior: widget.listClipBehavior,
            child: ListView.builder(
              shrinkWrap: true,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              padding: widget.listPadding,
              prototypeItem: widget.listPrototypeItem,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);
                return Padding(
                  padding:
                      index == 0
                          ? EdgeInsets.zero
                          : EdgeInsets.only(top: widget.itemsSpace),
                  child: TextButton(
                    onPressed:
                        buttonEnabled(option)
                            ? () {
                              focusNode.unfocus();
                              onSelected(option);
                            }
                            : null,
                    style: widget.itemStyle,
                    child: widget.items(options.elementAt(index)),
                  ),
                );
              },
              // separatorBuilder: (context, index) => const Divider(),
              itemCount: options.length,
            ),
          ),
        );
      },
      // initialValue: TextEditingValue(text: widget.initialValue ?? ''),
      onSelected: widget.onSelected,
      displayStringForOption:
          widget.onSelectedItem ?? RawAutocomplete.defaultStringForOption,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) =>
              widget.textField?.call(suffixIcon:          _suffixIcon,key:_anchorKey) ??
              TextFieldWidget(
                key: _anchorKey, //DropListFieldKeys.field,
                widgetKey: widget.textFieldKey,
                isRequired: widget.isRequired,
                controller: controller,
                focusNode: focusNode,
                suffixIcon: _suffixIcon,
                onChanged: widget.onChanged,
                labelText: widget.labelText,
                showErrorText: widget.showErrorText,
                errorText: widget.errorText,
                suffixIconPadding: widget.suffixIconPadding,
                textStyle: widget.textStyle,
                errorMaxLines: widget.errorMaxLines,
                description: widget.description,
              ),
    );
  }

  Widget get _suffixIcon =>
      widget.fieldSuffixIcon ??
      (showActiveIcon
          ? IconButton(
            icon: widget.fieldActiveIcon,
            onPressed: focusNode.unfocus,
          )
          : widget.fieldDeactiveIcon);

  @override
  void dispose() {
    focusNode.removeListener(_changeIcon);
    if (widget.controller == null) controller.dispose();
    if (widget.focusNode == null) focusNode.dispose();
    super.dispose();
  }
}
