
import 'package:flutter/material.dart';
import 'package:listas_app/data/service/usuario_service_impl.dart';
import 'package:listas_app/domain/entities/security/response/usuario_response.dart';
import 'package:listas_app/domain/services/usuario_service.dart';

class AuthProvider extends ChangeNotifier {
  UsuarioResponse? _user;
  final UsuarioService _authService = UsuarioServiceImpl();

  UsuarioResponse? get user => _user;
  bool get isAuthenticated => _user != null;

  // Cargar usuario desde almacenamiento local
  Future<void> loadUser() async {
    _user = await _authService.getUser();
    notifyListeners();
  }

  // Login
  Future<bool> logged(UsuarioResponse user) async {
    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Logout
  // Future<void> logout() async {
  //   await _authService.logout();
  //   _user = null;
  //   notifyListeners();
  // }
}