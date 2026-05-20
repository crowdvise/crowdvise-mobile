import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/inputfield_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BorderlessInputField extends TextFieldParent {
  const BorderlessInputField({
    required this.hint,
    super.key,
    required super.onChange,
    super.value,
    this.readOnly = false,
    this.maxLines = 20,
    this.maxLength = 350,
    this.error,
    this.isClear = false,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.done,
    this.minLines = 1,
    this.onAction,
  });

  final bool readOnly;

  final int maxLines;
  final int maxLength;
  final String? error;
  final String hint;
  final bool isClear;

  final TextInputType inputType;

  final TextInputAction inputAction;

  final VoidCallback? onAction;

  final int minLines;

  @override
  TextFieldState<BorderlessInputField> createState() => _InputFieldState();
}

class _InputFieldState extends TextFieldState<BorderlessInputField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          filled: false,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focus,
        readOnly: widget.readOnly,
        showCursor: true,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        minLines: widget.minLines,
        onEditingComplete: widget.onAction,
        textInputAction: widget.inputAction,
        style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
        maxLengthEnforcement: MaxLengthEnforcement.none,
        cursorColor: secondary,
        onTapOutside: (_) {
          focus.unfocus();
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: theme.textTheme.bodySmall?.copyWith(
            color: neutral500,
            fontSize: 12,
          ),

          errorText: widget.error,
          border: InputBorder.none,
          counterText: '',
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
