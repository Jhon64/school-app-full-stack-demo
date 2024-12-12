import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastLenght { lengthShort, lengthLong }

class Toasted {
  String? message;
  ToastLenght? toastLength;
  ToastGravity? gravity;
  int? timeInSecForIosWeb;
  Color? backgroundColor;
  Color? textColor;
  double? fontSize;

  Toasted(
      {this.message,
      this.toastLength,
      this.gravity,
      this.timeInSecForIosWeb,
      this.backgroundColor,
      this.textColor,
      this.fontSize});

  Toasted.Error(
      {this.message,
      this.toastLength,
      this.gravity,
      this.timeInSecForIosWeb,
      this.fontSize})
      : backgroundColor = Colors.red,
        textColor = Colors.white;

  void show() {
    Fluttertoast.showToast(
        msg: message ?? "",
        toastLength: ((toastLength ?? ToastLenght.lengthShort) ==
                ToastLenght.lengthShort)
            ? Toast.LENGTH_SHORT
            : Toast.LENGTH_LONG,
        gravity: gravity ?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: timeInSecForIosWeb ?? 1,
        backgroundColor: backgroundColor ?? Colors.grey,
        textColor: textColor ?? Colors.white,
        fontSize: fontSize ?? 16.0);
  }
}
