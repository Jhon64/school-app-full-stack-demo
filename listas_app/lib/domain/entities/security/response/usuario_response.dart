// To parse this JSON data, do
//
//     final usuarioResponse = usuarioResponseFromJson(jsonString);

import 'dart:convert';

import 'package:utils/localstorage/functions/functions_localstorage.dart';

UsuarioResponse usuarioResponseFromJson(String str) =>
    UsuarioResponse.fromJson(json.decode(str));

String usuarioResponseToJson(UsuarioResponse data) =>
    json.encode(data.toJson());

class UsuarioResponse extends OperacionesLocalstorage{
  String? username;
  String? password;
  String? fullName;
  String? token;
  DateTime? expiredAt;
  List<RolResponse>? roles;

  int? userID;

  UsuarioResponse({
    this.username,
    this.password,
    this.expiredAt,
    this.fullName,
    this.token,
    this.userID,
    this.roles,
  });

  factory UsuarioResponse.fromJson(Map<String, dynamic> json) =>
      UsuarioResponse(
        username: json["username"],
        password: json["password"],
        expiredAt: json["expiredAt"]!=null?DateTime.tryParse(json["expiredAt"]):null,
        fullName: json["fullName"],
        token: json["token"],
        userID: json["userID"]!=null?int.tryParse(json["userID"]):null,
        roles: json["roles"] == null
            ? []
            : List<RolResponse>.from(
                json["roles"]!.map((x) => RolResponse.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "fullName": fullName,
        "expiredAt": expiredAt,
        "token": token,
        "userID": userID,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
      };
}

class RolResponse {
  String? nombre;
  int? estado;
  bool? deleted;
  String? createdAt;
  int? rolid;
  dynamic updatedAt;

  RolResponse({
    this.nombre,
    this.estado,
    this.deleted,
    this.createdAt,
    this.rolid,
    this.updatedAt,
  });

  factory RolResponse.fromJson(Map<String, dynamic> json) => RolResponse(
        nombre: json["nombre"],
        estado: json["estado"],
        deleted: json["deleted"],
        createdAt: json["createdAt"],
        rolid: json["rolid"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "estado": estado,
        "deleted": deleted,
        "createdAt": createdAt,
        "rolid": rolid,
        "updatedAt": updatedAt,
      };
}
