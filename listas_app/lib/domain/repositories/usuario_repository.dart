import 'package:listas_app/common/entities/generic_result.dart';
// import 'package:listas_app/domain/entities/producto_entity.dart';
import 'package:listas_app/domain/entities/security/request/login_request.dart';
import 'package:listas_app/domain/entities/security/response/usuario_response.dart';

abstract class UsuarioRepository {
  Future<GenericResult<UsuarioResponse?>> login(LoginRequest form);

  // Future<GenericResult<Product?>> findByID(int id);

  // Future<GenericResult<Product>> save(Product form);

  // Future<GenericResult<Product>> update(Product form);

  // Future<GenericResult<int>> delete(int id);
}
