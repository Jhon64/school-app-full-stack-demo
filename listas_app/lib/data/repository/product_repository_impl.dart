import 'dart:convert';
import 'package:http2/http2.dart';
import 'package:listas_app/common/entities/generic_result.dart';
import 'package:listas_app/domain/entities/producto_entity.dart';
import 'package:listas_app/domain/repositories/product_repository.dart';
import 'package:utils/toasted/toasted.dart';

import 'endpoints_url.dart';

class ProductRepositoryImpl implements ProductRepository {
  //url de la conexion de base de datos
  late String url = apiProductsUrl;
  late final Http2 _http = Http2(url: apiProductsUrl);

  @override
  Future<GenericResult<List<Product>>> findAll() async {
    var result = GenericResult<List<Product>>(
        statusCode: 200, message: "listando productos", data: []);

    try {
      var httpResult = await _http.get(url: '/list');
      result.statusCode = httpResult.statusCode;
      result.message = httpResult.message;
      if (httpResult.statusCode == 200) {
        final dataJson = httpResult.data as List<dynamic>;
        result.data = dataJson.map((json) => Product.fromJson(json)).toList();
      }
    } catch (ex) {
      result.statusCode = 500;
      result.message = ex.toString();
      result.data = [];
    }
    return result;
  }

  @override
  Future<GenericResult<int>> delete(int id) async {
    var result = GenericResult<int>(
        statusCode: 200, message: "producto eliminado", data: 0);

    if (id == 0) {
      Toasted.error(message: "sin información para eliminar").show();
      result.statusCode = 400;
      result.message = "sin información para eliminar";
    } else {
      try {
        var httpResult = await _http.delete(url: '/delete/$id');
        Product listProduct = Product();
        result.statusCode = httpResult.statusCode;
        result.message = httpResult.message;
        if (httpResult.statusCode == 200) {
          final dataJson = httpResult.data as int;
          result.data = dataJson;
        }
      } catch (ex) {
        result.statusCode = 500;
        result.message = ex.toString();
      }
    }
    return result;
  }

  @override
  Future<GenericResult<Product?>> findByID(int id) {
    // TODO: implement findByID
    throw UnimplementedError();
  }

  @override
  Future<GenericResult<Product>> save(Product form) async {
    var result = GenericResult<Product>(
        statusCode: 200, message: "listando productos", data: form);

    var dataJson = form.toJson();

    if (dataJson.isEmpty) {
      Toasted.error(message: "sin información para guardar").show();
      result.statusCode = 400;
      result.message = "sin información para guardar";
    } else {
      try {
        var httpResult = await _http.post(url: '/save', body: dataJson);
        Product listProduct = Product();
        result.statusCode = httpResult.statusCode;
        result.message = httpResult.message;
        if (httpResult.statusCode == 200) {
          final dataJson = httpResult.data as dynamic;
          result.data = Product.fromJson(dataJson);
        }
      } catch (ex) {
        result.statusCode = 500;
        result.message = ex.toString();
      }
    }
    return result;
  }

  @override
  Future<GenericResult<Product>> update(Product form) async {
    var result = GenericResult<Product>(
        statusCode: 200, message: "listando productos", data: form);

    var dataJson = form.toJson();

    if (dataJson.isEmpty) {
      Toasted.error(message: "sin información para guardar").show();
      result.statusCode = 400;
      result.message = "sin información para guardar";
    } else {
      try {
        var httpResult = await _http.put(url: '/update', body: dataJson);
        Product listProduct = Product();
        result.statusCode = httpResult.statusCode;
        result.message = httpResult.message;
        if (httpResult.statusCode == 200) {
          final dataJson = httpResult.data as dynamic;
          result.data = Product.fromJson(dataJson);
        }
      } catch (ex) {
        result.statusCode = 500;
        result.message = ex.toString();
      }
    }
    return result;
  }
}
