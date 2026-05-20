import 'package:flutter/material.dart';

class ModalOverlay extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const ModalOverlay({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(color: Colors.black54),
        ),
        child,
      ],
    );
  }
}