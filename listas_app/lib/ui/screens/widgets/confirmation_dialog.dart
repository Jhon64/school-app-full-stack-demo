import 'package:flutter/material.dart';

class ConfirmationDialog {
  String title;
  String? subtitle;
  void Function()? handleConfirm;

  ConfirmationDialog({required this.title, this.subtitle,this.handleConfirm});

  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Desactiva el cierre al tocar fuera
      builder: (BuildContext context) {
        return Column(
          children: [
            Text(title),
            const SizedBox(height: 2.0),
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.arrow_back_sharp),
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  label: Text("Cancelar"),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.arrow_back_sharp),
                  onPressed: () {
                    if(handleConfirm!=null){
                      handleConfirm;
                    }
                  },
                  label: Text("Aceptar"),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
