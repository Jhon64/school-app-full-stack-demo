import 'package:flutter/material.dart';

enum Label2Type { success, primary, info, warning, error, secondary }

class Label2 extends StatelessWidget {
  final String text;
  final Label2Type? typeLabel;
  final Color? backgroundColor;
  const Label2({super.key, required this.text, this.typeLabel,this.backgroundColor});

  Color? getColor() {
    if (typeLabel == Label2Type.success) {
      return Colors.green;
    } else if (typeLabel == Label2Type.warning) {
      return Colors.orange;
    } else if (typeLabel == Label2Type.primary) {
      return Colors.blue;
    } else if (typeLabel == Label2Type.info) {
      return Colors.blueAccent;
    } else if (typeLabel == Label2Type.error) {
      return Colors.red;
    } else if (typeLabel == Label2Type.secondary) {
      return Colors.blueGrey;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor??getColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }
}
