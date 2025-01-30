import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String tag;
  final IconData icon;
  final VoidCallback onPressed;

  const MenuItem({
    required this.title,
    required this.tag,
    required this.icon,
    required this.onPressed,
  });
}
