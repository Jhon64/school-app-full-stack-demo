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

  Toasted.error(
      {this.message,
      this.toastLength,
      this.gravity,
      this.timeInSecForIosWeb,
      this.fontSize})
      : backgroundColor = Colors.red,
        textColor = Colors.white;

  Toasted.success(
      {this.message,
      this.toastLength,
      this.gravity,
      this.timeInSecForIosWeb,
      this.fontSize})
      : backgroundColor = Colors.green,
        textColor = Colors.white;

  Toasted.info(
      {this.message,
      this.toastLength,
      this.gravity,
      this.timeInSecForIosWeb,
      this.fontSize})
      : backgroundColor = Colors.blue,
        textColor = Colors.white;

  Toasted.warning(
      {this.message,
      this.toastLength,
      this.gravity,
      this.timeInSecForIosWeb,
      this.fontSize})
      : backgroundColor = Colors.orange,
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
