import 'package:flutter/material.dart';

class CustomCheckbox2 extends StatelessWidget {
  // Propiedades del checkbox
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color activeColor;
  final Color checkColor;
  final String? label;
  final TextStyle? labelStyle;

  const CustomCheckbox2({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.checkColor = Colors.white,
    this.label,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          checkColor: checkColor,
        ),
        if (label != null)
          GestureDetector(
            onTap: () {
              onChanged(!value);
            },
            child: Text(
              label!,
              style: labelStyle ?? TextStyle(fontSize: 16.0),
            ),
          ),
      ],
    );
  }
}
