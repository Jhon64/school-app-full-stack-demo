import 'package:http2/http2.dart';
import 'package:listas_app/common/entities/generic_result.dart';
import 'package:listas_app/domain/entities/security/request/login_request.dart';
import 'package:listas_app/domain/entities/security/response/usuario_response.dart';
import 'package:listas_app/domain/repositories/usuario_repository.dart';
import 'endpoints_url.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  //url de la conexion de base de datos

  late final Http2 _http = Http2(url: usuarioURL);

  @override
  Future<GenericResult<UsuarioResponse?>> login(LoginRequest login) async {
    var result = GenericResult<UsuarioResponse?>(
        statusCode: 200, message: "listando productos", data: null);

    try {
      var httpResult = await _http.post(
          url: '/login', body: login.toJson(), disableAuth: true);
      result.statusCode = httpResult.statusCode;
      result.message = httpResult.message;
      if (httpResult.statusCode == 200) {
        Map<String, dynamic> dataJson = httpResult.data;
        result.data = UsuarioResponse.fromJson(dataJson["data"]);
      }
    } catch (ex) {
      result.statusCode = 500;
      result.message = ex.toString();
      result.data = null;
    }
    return result;
  }
}
