import 'dart:convert';

class ResponseApiData<T> {
  int? statusCode;
  String? message;
  T? data;
  ResponseApiData({this.statusCode, this.message, this.data});

  factory ResponseApiData.fromJson(Map<String, dynamic> json) {
    ResponseApiData<T> reg = ResponseApiData<T>();
    int statusCode = json['statusCode'];
    var data = json['data'];
    String message = json['message'];

    reg.statusCode = statusCode;
    if (data != null) reg.data = data;
    reg.message = message;
    return reg;
  }

  Map<String, dynamic> _$ResponseApiDataJson(ResponseApiData instance) {
    Map<String, dynamic> reg = {};
    if (instance.statusCode != null) reg['statusCode'] = instance.statusCode;
    if (instance.data != null) reg['data'] = instance.data;
    if (instance.message != null) reg['message'] = instance.message;
    return reg;
  }

  Map<String, dynamic> toJson() => _$ResponseApiDataJson(this);
}

class ResponseApiDTO<T> {
  String? status;
  ResponseApiData? data;
  ResponseApiDTO({this.status, this.data});

  factory ResponseApiDTO.fromJson(Map<String, dynamic> json) {
    ResponseApiDTO<T> reg = ResponseApiDTO<T>();
    var status = json['status'];
    var data = json['data'];

    if (status != null) reg.status = status;
    if (data != null) reg.data = ResponseApiData.fromJson(data);
    return reg;
  }

  Map<String, dynamic> _$ResponseApiDTOToJson(ResponseApiDTO instance) {
    Map<String, dynamic> reg = {};
    if (instance.status != null) reg['status'] = instance.status;
    if (instance.data != null) reg['data'] = instance.data;

    return reg;
  }

  Map<String, dynamic> toJson() => _$ResponseApiDTOToJson(this);

  // @override
  // String toString() {
  //   return 'ProductID: $productID Nombre: $nombre  Descripcion: $descripcion  Precio: $precio';
  // }
}
