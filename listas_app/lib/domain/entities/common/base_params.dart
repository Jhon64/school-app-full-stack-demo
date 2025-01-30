import 'package:flutter/src/foundation/basic_types.dart';

import 'dart:convert';

import 'package:listas_app/domain/entities/common/interfaces/i_base_params.dart';

BaseParams baseParamsFromJson(String str) =>
    BaseParams.fromJson(json.decode(str));

String baseParamsToJson(BaseParams data) => json.encode(data.toJson());

class BaseParams implements IBaseParams {
  int? empresaID;
  int? moduloID;
  String? hostname;
  String? username;
  BaseParams({this.empresaID, this.moduloID, this.hostname, this.username});

  factory BaseParams.fromJson(Map<String, dynamic> json) => BaseParams(
        empresaID: json["empresaID"],
        moduloID: json["moduloID"],
        username: json["username"],
        hostname: json["hostname"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "empresaID": empresaID,
        "moduloID": moduloID,
        "username": username,
        "hostname": hostname,
      };

  @override
  String convertClassToParams() {
    Map<String, dynamic> parseReg = toJson();
    String params = "";
    for (var item in parseReg.entries) {
      String key = item.key;
      dynamic value = item.value;
      if (value == null) continue;
      params = '$params&$key=$value';
    }

    return params;
  }
}
