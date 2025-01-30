import 'package:flutter/src/widgets/framework.dart';
import 'package:utils/toasted/toasted.dart';
import 'package:generic_components/generic_components.dart';

class Product implements IDynamicFormMethods, IFunctionsGeneric {
  int? productID;
  String? nombre;
  String? descripcion;
  double? precio;
  String? imageURL;
  int? estado;

  Product(
      {this.nombre,
      this.precio,
      this.productID,
      this.descripcion,
      this.imageURL,
      this.estado});

  factory Product.fromJson(Map<String, dynamic> json) {
    var precio = json['precio'] ?? '0';
    double setPrecio = 0;
    if (precio.toString().isEmpty) setPrecio = 0;
    var tipoDato = precio.runtimeType;
    try {
      if (precio is String) {
        precio = double.parse(precio);
        setPrecio = precio;
      } else if (precio is double) {
        setPrecio = precio;
        setPrecio = double.parse(precio.toString());
      }
    } catch (ex) {
      Toasted.error(message: ex.toString()).show();
    }

    Product reg = Product();
    var productID = json['productID'];
    var nombre = json['nombre'];
    var descripcion = json['descripcion'];
    var imageURL = json['imageURL'];
    var estado = json['estado'];
    if (productID != null) reg.productID = productID;
    if (nombre != null) reg.nombre = nombre;
    if (descripcion != null) reg.descripcion = descripcion;
    if (imageURL != null) reg.imageURL = imageURL;
    if (precio != null) reg.precio = setPrecio;
    if (estado != null) reg.estado = estado;

    return reg;
  }

  Map<String, dynamic> _$ProductsToJson(Product instance) {
    Map<String, dynamic> reg = {};
    if (instance.productID != null) reg['productID'] = instance.productID;
    if (instance.nombre != null) reg['nombre'] = instance.nombre;
    if (instance.descripcion != null) reg['descripcion'] = instance.descripcion;
    if (instance.imageURL != null) reg['imageURL'] = instance.imageURL;
    if (instance.precio != null) reg['precio'] = instance.precio;
    if (instance.estado != null) reg['estado'] = instance.estado;
    return reg;
  }

  Map<String, dynamic> _$ProductsToJsonWithNull(Product instance) {
    Map<String, dynamic> reg = {};
    reg['productID'] = instance.productID;
    reg['nombre'] = instance.nombre;
    reg['descripcion'] = instance.descripcion;
    reg['imageURL'] = instance.imageURL;
    reg['precio'] = instance.precio;
    reg['estado'] = instance.estado;
    return reg;
  }

  Map<String, dynamic> toJson() => _$ProductsToJson(this);

  Map<String, dynamic> toJsonWithNull() => _$ProductsToJsonWithNull(this);

  @override
  String toString() {
    return 'ProductID: $productID Nombre: $nombre  Descripcion: $descripcion  Precio: $precio';
  }
}
