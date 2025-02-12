import 'package:listas_app/common/entities/generic_result.dart';
import 'package:listas_app/domain/entities/producto_entity.dart';

abstract class ProductService{
  // Future<List<Product>> findAll();
  Future<GenericResult<List<Product>>> findAll();
  Future<GenericResult<Product>> save(Product form);
  Future<GenericResult<Product>> update(Product form);
  Future<GenericResult<int>> delete(int productID);
}