import 'package:flutter/material.dart';

class Dialog2 {
  const Dialog2({
    required this.context,
    this.disabledBlock,
    this.content,
  });

  final BuildContext context;
  final bool? disabledBlock;
  final Widget? content;

  void show() {
    showDialog(
      context: context,
      barrierDismissible: disabledBlock ??
          false, // Evita que se cierre al tocar fuera del diálogo
      builder: (BuildContext context) {
        return Dialog(
          child: content,
        );
      },
    );
  }
}
