import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Modal2 {
  BuildContext context;
  Widget content;
  Widget? customHeader;
  String? title;
  bool? disabledBlock;
  BoxConstraints? boxConstraints;
  EdgeInsetsGeometry? paddingContent;

  //acciones del fooer
  Widget? customFooter;
  void Function()? handleOnCancel;
  void Function()? handleOnSave;
  bool? hideFooter;
  bool? hideBtnCancel;
  Widget? iconBtnCancel;
  Widget? iconBtnSave;
  String? textBtnCancel;
  String? textBtnSave;
  bool? hideBtnSave;
  Widget? customBtnSave;
  Widget? customBtnCancel;

  //footer
  bool? hideHeader;

  Modal2(
      {required this.context,
      required this.content,
      this.customHeader,
      this.paddingContent,
      this.title,
      this.hideHeader,
      this.boxConstraints,
      this.disabledBlock,
      this.customFooter,
      this.handleOnSave,
      this.hideFooter,
      this.hideBtnCancel,
      this.hideBtnSave,
      this.iconBtnCancel,
      this.iconBtnSave,
      this.textBtnCancel,
      this.textBtnSave,
      this.customBtnSave,
      this.customBtnCancel,
      this.handleOnCancel});

  Widget _generateHeader() {
    if (title != null) {
      return Container(
        // height: 50.0,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        // decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.blueAccent,),
        color: Colors.grey[300]!,
        width: double.infinity,
        child: Center(
          child: Text(
            title!.toUpperCase(),
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else if (customHeader != null) {
      return customHeader!;
    }
    return const SizedBox.shrink();
  }

  Widget _generateFooter() {
    if (customFooter != null) {
      return customFooter!;
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white, // Color de fondo
          border: Border(
            top: BorderSide(
              color: Colors.grey[200]!, // Color del borde
              width: 1.0, // Grosor del borde
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(),
            customBtnCancel != null
                ? customBtnCancel!
                : hideBtnCancel == null || hideBtnCancel == true
                    ? ElevatedButton.icon(
                        onPressed: handleOnCancel ??
                            () {
                              Navigator.of(context).pop(); // Dismiss the dialog
                            },
                        label: Text(
                          textBtnCancel ?? "Cancelar",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        icon: iconBtnCancel ??
                            const Icon(
                              Icons.close,
                              color: Colors.black54,
                            ),
                      )
                    : const SizedBox.shrink(),
            const SizedBox(
              width: 10.0,
            ),
            customBtnSave != null
                ? customBtnSave!
                : hideBtnSave == null || hideBtnSave == true
                    ? ElevatedButton.icon(
                        onPressed: handleOnSave,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.green),
                        label: Text(
                          textBtnSave ?? "Guardar",
                          style: const TextStyle(color: Colors.white),
                        ),
                        icon: iconBtnSave ??
                            const Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                      )
                    : const SizedBox.shrink(),
          ],
        ),
      );
    }
  }

  void show() {
    showDialog(
      context: context,
      barrierDismissible: disabledBlock ?? false,
      // Evita que se cierre al tocar fuera del diálogo
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hideHeader != true) _generateHeader(),
                SingleChildScrollView(
                    child: Container(
                  constraints: boxConstraints ??
                      BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width *
                            0.8, // 80% del ancho de la pantalla
                        maxHeight: MediaQuery.of(context).size.height *
                            0.7, // 60% del alto de la pantalla
                      ),
                  child: Padding(
                    padding: paddingContent ??
                        const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                    child: SingleChildScrollView(
                      child: content,
                    ),
                  ),
                )),
                if (hideFooter != true) _generateFooter(),
              ],
            ),
          ),
        );
      },
    );
  }
}
