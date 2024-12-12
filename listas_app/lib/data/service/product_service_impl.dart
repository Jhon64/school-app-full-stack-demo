import 'package:listas_app/common/entities/generic_result.dart';
import 'package:listas_app/data/repository/product_repository_impl.dart';
import 'package:listas_app/domain/entities/producto_entity.dart';
import 'package:listas_app/domain/repositories/product_repository.dart';
import 'package:listas_app/domain/services/product_service.dart';

class ProductServiceImpl implements ProductService {
  final ProductRepository _repository = ProductRepositoryImpl();

  @override
  Future<GenericResult<List<Product>>> findAll() async {
    return await _repository.findAll();

    // if (resultRep.statusCode == 200) {
    //   return resultRep.data ?? [];
    // } else {
    //   String messageError = resultRep.message ?? "Error al obtener informacion";
    //   throw Exception(messageError);
    // }
  }
  @override
  Future<GenericResult<int>> delete(int productID) async{
    return await _repository.delete(productID);
  }

  @override
  Future<GenericResult<Product>> save(Product form) async{
    return await _repository.save(form);
  }

  @override
  Future<GenericResult<Product>> update(Product form) async{
    return await _repository.update(form);
  }
}
