import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'functions/functions_localstorage.dart';

// Definir una interfaz para objetos serializables

class LocalStorage<T extends OperacionesLocalstorage> {
  static LocalStorage? _instance;
  SharedPreferences? _sharedPreferences;

  LocalStorage._privateConstructor();

  static Future initialize<T>() async {
    if (_instance == null) {
      _instance = LocalStorage._privateConstructor();
      await _instance!._loadStore();
    }
    return _instance!;
  }

  static LocalStorage get instance {
    if (_instance == null) {
      throw Exception(
          'El singleton no ha sido inicializado. Usa initialize primero.');
    }
    return _instance!;
  }

  Future<void> _loadStore() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Métodos para guardar y recuperar datos primitivos
  Future<void> setInt(String key, int value) async =>
      await _sharedPreferences?.setInt(key, value);
  int? getInt(String key) => _sharedPreferences?.getInt(key);
  void delete(String key) => _sharedPreferences?.remove(key);
  void deleteAll() => _sharedPreferences?.clear();

  Future<void> setBool(String key, bool value) async =>
      await _sharedPreferences?.setBool(key, value);
  bool? getBool(String key) => _sharedPreferences?.getBool(key);

  Future<void> setDouble(String key, double value) async =>
      await _sharedPreferences?.setDouble(key, value);
  double? getDouble(String key) => _sharedPreferences?.getDouble(key);

  Future<void> setString(String key, String value) async =>
      await _sharedPreferences?.setString(key, value);
  String? getString(String key) => _sharedPreferences?.getString(key);

  // Métodos para guardar y recuperar objetos serializables
  Future<void> setData(String key, T data) async {
    await _sharedPreferences?.setString(key, jsonEncode(data.toJson()));
  }

  T? getData(String key, T Function(Map<String, dynamic>) fromJson) {
    String? jsonString = _sharedPreferences?.getString(key);
    if (jsonString == null) {
      // throw "No existe este dato en el store $key";
      return null;
    }
    return fromJson(jsonDecode(jsonString));
  }
}
