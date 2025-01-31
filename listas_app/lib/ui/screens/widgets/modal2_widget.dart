import 'package:flutter/material.dart';

class Modal2Widget extends StatelessWidget {
  double? padding;
  Widget child;
  String? title;

  void Function(BuildContext context)? onCancel;
  void Function(BuildContext context)? onSave;
  void Function(GlobalKey<FormState> formKey)? getFormKey;
  Future<void> Function(BuildContext context)? onSaveFuture;

  Modal2Widget(
      {super.key,
      required this.child,
      this.padding,
      this.title,
      this.onCancel,
      this.onSaveFuture,
      this.onSave});

  void handleCancelModal(BuildContext context) {
    if (onCancel != null) {
      onCancel!(context);
    } else {
      Navigator.of(context).pop(); // Cierra el modal
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title ?? "Titulo modal"),
            const SizedBox(height: 2.0),
            child,
            const SizedBox(height: 4.0),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.arrow_back_sharp),
                  onPressed: () => handleCancelModal(context),
                  label: Text("Cancelar"),
                ),
                TextButton.icon(
                  onPressed: () => {
                    if (onSave != null)
                      {onSave!(context)}
                    else if (onSaveFuture != null)
                      {onSaveFuture!(context)}

                  },
                  icon: Icon(Icons.save),
                  label: Text('Aceptar'),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
