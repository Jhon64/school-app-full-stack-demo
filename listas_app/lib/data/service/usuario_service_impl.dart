import 'dart:convert';
import 'dart:developer';

import 'package:listas_app/common/entities/generic_result.dart';
import 'package:listas_app/data/repository/usuario_repository_impl.dart';
import 'package:listas_app/domain/entities/security/request/login_request.dart';
import 'package:listas_app/domain/entities/security/response/usuario_response.dart';
import 'package:listas_app/domain/services/usuario_service.dart';
import 'package:utils/localstorage/localstorage.dart';

class UsuarioServiceImpl implements UsuarioService {
  final _repository = UsuarioRepositoryImpl();

  @override
  Future<UsuarioResponse?> getUser() async {
    LocalStorage storage = await LocalStorage.initialize();
    String userStr = storage.getString("user");
    int? userID = storage.getInt("userID");
    UsuarioResponse userData = UsuarioResponse.fromJson(jsonDecode(userStr));
    if (int == null) return null;
    return userData;
  }

  @override
  Future<GenericResult<UsuarioResponse?>> login(LoginRequest login) async {
    final result = await _repository.login(login);
    if (result.statusCode == 200) {
      log("usuario autenticado");
      LocalStorage storage = await LocalStorage.initialize();
      storage.setData("user", result.data!);
      storage.setString("token", result.data?.token ?? "");
      storage.setString("username", result.data?.username ?? "");
      storage.setString(
          "expiredAt", result.data?.expiredAt?.toIso8601String() ?? '');
      storage.setInt("userID", result.data!.userID!);
    }

    return result;
  }
}
