import 'package:listas_app/domain/entities/common/base_params.dart';
import 'package:listas_app/domain/entities/common/interfaces/i_base_params.dart';

class LoginRequest extends BaseParams implements IBaseParams {
  String? username;
  String? password;

  LoginRequest({
    this.username,
    this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        username: json["username"],
        password: json["password"],
      );
  @override
  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}
