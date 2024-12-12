import 'package:flutter/material.dart';
//
// class PropsInpuDecoration {
//   String? label;
//   String? hintText;
//   bool? required;
//
//   PropsInpuDecoration({this.hintText, this.label, this.required});
// }

InputDecoration inputDecorationForm2(
    {String? label, String? hintText, bool? required}) {
  return InputDecoration(
    labelText: label,
    hintText: hintText,
    errorBorder: required == true
        ? const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          )
        : null,
    focusedErrorBorder: required == true
        ? const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
          )
        : null,
  );
}
