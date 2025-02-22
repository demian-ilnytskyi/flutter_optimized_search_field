part of 'based_search_field.dart';

class _TextFieldWidget extends StatelessWidget {
  const _TextFieldWidget({
    required this.onChanged,
    required this.labelText,
    required this.onFieldSubmitted,
    this.widgetKey,
    this.isRequired,
    Key? key,
    this.errorText,
    this.controller,
    this.suffixIcon,
    this.focusNode,
    this.errorMaxLines = 3,
    this.showErrorText,
    this.labelTextStyle,
    this.textStyle,
    this.description,
    this.inputFormatters,
    this.decoration,
  }) : super(key: key);

  // Widget key
  final Key? widgetKey;

  // Callback for text change
  final ValueChanged<String>? onChanged;

  // Error text for the text field
  final String? errorText;

  // Controller for the text field
  final TextEditingController? controller;

  // Suffix icon for the text field
  final Widget? suffixIcon;

  // Focus node for the text field
  final FocusNode? focusNode;

  // Maximum number of lines for the error text
  final int? errorMaxLines;

  // Whether to show the error text
  final bool? showErrorText;

  // Style for the label text
  final TextStyle? labelTextStyle;

  // Style for the text
  final TextStyle? textStyle;

  // Description for the text field
  final String? description;

  // Whether the text field is required
  final bool? isRequired;

  // Label text for the text field
  final String? labelText;

  // Input formatters for the text field
  final List<TextInputFormatter>? inputFormatters;

  final InputDecoration? decoration;

  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: widgetKey,
      focusNode: focusNode,
      controller: controller,
      style: textStyle,
      onChanged: onChanged,
      onSubmitted: onFieldSubmitted,
      decoration: decoration ??
          InputDecoration(
            labelText: getLabelText,
            errorText: showErrorText ?? true ? errorText : null,
            suffixIcon: suffixIcon,
            labelStyle: labelTextStyle,
            helperText: description,
            errorMaxLines: errorMaxLines,
          ),
      inputFormatters: inputFormatters,
    );
  }

  // Get the label text with an asterisk if the field is required
  String? get getLabelText => (isRequired ?? false) ? '$labelText*' : labelText;
}
