import 'package:flutter/material.dart';

import '../utils/custom_state.dart';

abstract class TextFieldParent extends StatefulWidget {
  const TextFieldParent({required this.onChange, this.value, super.key, this.isPassword = false});
  final String? value;

  final bool isPassword;

  final void Function(String) onChange;

  @override
  TextFieldState<TextFieldParent> createState();
}

abstract class TextFieldState<T extends TextFieldParent> extends CustomState<T> {
  late TextEditingController controller;
  final focus = FocusNode();
  bool isFocus = false;
  String value = '';
  bool isPassword = false;

  @override
  void onStart() {
    controller = TextEditingController(text: widget.value);
    isPassword = widget.isPassword;
    focus.addListener(_onFocusChange);
    super.onStart();
  }

  @override
  void onStarted() {
    controller.addListener(() {
      value = controller.text;
      if(mounted){
        setState(() {

        });
      }

      widget.onChange(controller.text);
    });
    super.onStarted();
  }

  _onFocusChange() {
    setState(() {
      isFocus = focus.hasFocus;
    });
  }
  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != null && widget.value != controller.text) {
      final newValue = widget.value!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && controller.text != newValue) {
          final cursorPosition = controller.selection;
          controller.text = newValue;
          // Retain cursor position if possible
          if (cursorPosition.baseOffset <= newValue.length) {
            controller.selection = cursorPosition.copyWith(
              baseOffset: cursorPosition.baseOffset.clamp(0, newValue.length),
              extentOffset: cursorPosition.extentOffset.clamp(0, newValue.length),
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



