import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/clickable.dart';
import 'package:crowdvise/core/presentation/widgets/inputfield_state.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';

class InputField extends TextFieldParent {
  const InputField({
    required this.hint,
    super.key,
    required super.onChange,
    super.value,
    super.isPassword,
    this.prefix,
    this.prefixText,
    this.suffix,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.error,
    this.isClear = false,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.done,
    this.minLines = 1,
    this.onAction,
    this.inputFormatters,
  });

  final String? prefix;
  final String? prefixText;
  final Widget? suffix;

  final bool readOnly;

  final int maxLines;
  final int? maxLength;
  final String? error;
  final String hint;
  final bool isClear;

  final TextInputType inputType;

  final TextInputAction inputAction;

  final VoidCallback? onAction;
  final List<TextInputFormatter>? inputFormatters;
  final int minLines;

  @override
  TextFieldState<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends TextFieldState<InputField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(),
      ),
      child: TextField(
        controller: controller,
        focusNode: focus,
        readOnly: widget.readOnly,
        showCursor: true,
        obscureText: isPassword,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        onEditingComplete: widget.onAction,
        textInputAction: widget.inputAction,
        style: theme.textTheme.labelMedium,
        cursorColor: theme.colorScheme.onSurface,
        inputFormatters: widget.inputFormatters,
        onTapOutside: (_) {
          focus.unfocus();
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          errorText: widget.error,
          prefixIcon:
              widget.prefix == null
                  ? null
                  : SvgImage(
                    asset: widget.prefix!,
                    height: 20,
                    width: 20,
                    color: neutral700,
                    fit: BoxFit.scaleDown,
                  ),
          prefixText: widget.prefixText,
          prefixStyle: theme.textTheme.bodyMedium?.copyWith(
            color: neutral700,
            fontWeight: FontWeight.bold,
          ),
          suffix:
              widget.isPassword
                  ? Clickable(
                    onPressed:
                        () => setState(() {
                          isPassword = !isPassword;
                        }),
                    child: SvgImage(
                      asset: isPassword ? icEye : icEyeSlash,
                      height: 20,
                      width: 20,
                    ),
                  )
                  : widget.isClear && value.isNotEmpty
                  ? Clickable(
                    onPressed: () {
                      controller.clear();
                    },
                    child: SvgImage(
                      asset: icClose,
                      width: 24,
                      height: 24,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fit: BoxFit.scaleDown,
                    ),
                  )
                  : widget.suffix,
        ),
      ),
    );
  }
}

class InputField2 extends StatefulWidget {
  const InputField2({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.label,
    this.enterPressed,
    this.fieldFocusNode,
    this.nextFocusNode,
    this.additionalNote,
    this.onChanged,
    this.formatter,
    this.maxLines = 1,
    this.validationMessage,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.password = false,
    this.isReadOnly = false,
    this.smallVersion = true,
    this.suffix,
    this.onTap,
    this.maxLength,
    this.prefix,
    this.validationColor = const Color(0xffE8E8EA),
    this.height = 50,
    this.width,
  });

  final TextEditingController? controller;
  final TextInputType textInputType;
  final bool password;
  final bool isReadOnly;
  final String placeholder;
  final String? validationMessage;
  final Function? enterPressed;
  final bool smallVersion;
  final FocusNode? fieldFocusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction textInputAction;
  final String? additionalNote;
  final Function? onTap;
  final Function(String)? onChanged;
  // final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? formatter;
  final int maxLines;
  final int? maxLength;
  final Widget? suffix;
  final String? prefix;
  final Color validationColor;
  final String label;
  final double height;
  final double? width;

  @override
  State<InputField2> createState() => _InputField2State();
}

class _InputField2State extends State<InputField2> {
  late bool isPassword;
  double fieldHeight = 64;

  @override
  void initState() {
    super.initState();
    isPassword = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(),
      ),
      child: TextFormField(
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        focusNode: widget.fieldFocusNode,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        inputFormatters: widget.formatter ?? [],
        onTapOutside: (_) {
          widget.fieldFocusNode?.unfocus();
        },
        onFieldSubmitted: (value) {
          if (widget.enterPressed != null) {
            widget.enterPressed!(value);
          }
          if (widget.textInputAction == TextInputAction.search) {
            widget.fieldFocusNode?.unfocus();
          }
        },
        onEditingComplete: () {
          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
            if (widget.enterPressed != null) {
              widget.enterPressed!();
            }
          } else if (widget.textInputAction == TextInputAction.done) {
            widget.fieldFocusNode?.unfocus();
          }
        },
        obscureText: isPassword,
        readOnly: widget.isReadOnly,
        style: theme.textTheme.labelMedium,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          errorText: widget.validationMessage,
          errorStyle: theme.textTheme.labelMedium?.copyWith(
            fontSize: 12,
            color: theme.colorScheme.error,
          ),

          prefixIcon:
              widget.prefix == null
                  ? null
                  : SvgImage(
                    asset: widget.prefix!,
                    width: 20,
                    height: 20,
                    // color: neutral700,
                    fit: BoxFit.scaleDown,
                  ),

          suffix:
              isPassword
                  ? Clickable(
                    onPressed:
                        () => setState(() {
                          isPassword = !isPassword;
                        }),
                    child: Container(
                      width: 50,
                      height: 20,
                      alignment: Alignment.center,
                      child: SvgImage(
                        asset:
                            isPassword
                                ? 'assets/vectors/eye.svg'
                                : 'assets/vectors/eye-slash.svg',
                        width: 24,
                        height: 24,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  )
                  : null,
        ),
      ),
    );
  }
}
