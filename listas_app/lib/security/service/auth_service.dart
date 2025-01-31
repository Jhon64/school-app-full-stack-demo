import 'package:flutter/material.dart';
import 'package:utils/localstorage/localstorage.dart';

import '../../ui/screens/generales/products/product_page.dart';

Future<void> checkSessionAuth(bool mounted, BuildContext context) async {
  LocalStorage storage = await LocalStorage.initialize();
  String? token = storage.getString("token");
  String? expiredAt = storage.getString("expiredAt");
  if (expiredAt != null) {
    DateTime expiredAtDate = DateTime.parse(expiredAt);
    final dateNow = DateTime.now();
    if (expiredAtDate.isAfter(dateNow)) {
      if (token != null) {
        // Si ya está autenticado, redirigir al HomePage
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ProductPage()));
        }
      }
    }
  }
}

Future<bool> isLoggedIn() async {
  try {
    LocalStorage storage = await LocalStorage.initialize();
    String? token = storage.getString("token");
    String? expiredAt = storage.getString("expiredDate");
    if (expiredAt != null) {
      DateTime? expiredAtDate;
      if (expiredAt.isNotEmpty) {
        expiredAtDate = DateTime.parse(expiredAt);
      }
      if (expiredAtDate == null) {
        return false;
      }
      final dateNow = DateTime.now();
      if (expiredAtDate.isAfter(dateNow)) {
        if (token != null) {
          // Si ya está autenticado, redirigir al HomePage
          return true;
        }
      }
    }
    return false;
  } catch (e) {
    print(e);
    throw e.toString();
  }
}
