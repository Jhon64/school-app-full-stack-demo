import 'package:flutter/material.dart';

enum NotificationType { warning, error, success, info }

class NotificacionDialog {
  BuildContext context;
  String? title;
  Widget? customTitle;
  Widget? content;
  String? subtitle;
  String? textBtnCancelar;

  List<Widget>? customActions;
  NotificationType? notificationType;

  Function? onCancelar;

  NotificacionDialog(
      {required this.context,
      this.customTitle,
      this.title,
      this.customActions,
      this.textBtnCancelar,
      this.content,
      this.onCancelar,
      this.notificationType,
      this.subtitle});

  Color? getColorTitle() {
    if (notificationType != null) {
      switch (notificationType) {
        case NotificationType.warning:
          return Colors.orangeAccent;
        // TODO: Handle this case.
        case NotificationType.error:
          return Colors.redAccent;
        case NotificationType.success:
          return Colors.greenAccent;
        case NotificationType.info:
          return Colors.blueAccent;
        default:
          return Colors.white;
      }
    }
    return null;
  }

  void show() {
    dynamic customTitleVal = Text(
      title ?? "",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: getColorTitle(),
      ),
    );
    if (customTitle != null) {
      customTitleVal = customTitle;
    }
    dynamic customContentVal = Text(
      subtitle ?? '',
      style: const TextStyle(color: Colors.black),
    );
    if (content != null) {
      customContentVal = content;
    }

    showDialog(
      context: context,
      barrierDismissible:
          false, // Evita que se cierre al tocar fuera del diálogo
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: customTitleVal,
              content: customContentVal,
              actions: customActions ??
                  [
                    TextButton(
                      child: Text(
                        textBtnCancelar ?? 'Cancelar',
                        style: const TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onCancelar != null) {
                          onCancelar!();
                        }
                      },
                    )
                  ],
            ));
      },
    );
  }
}
