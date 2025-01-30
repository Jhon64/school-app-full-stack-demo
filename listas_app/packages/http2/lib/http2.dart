import 'dart:convert';

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http2/entities/auth/user_result.dart';
import 'package:http2/entities/response_api_dto.dart';
import 'package:http2/entities/result_response.dart';
import 'package:http2/entities/xml_http_request_config.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utils/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Http2 {
  String? baseURL;
  String? url;
  bool? disabledAuthBearer;
  BuildContext? context;
  XMLHTTPRequestConfig? defaultConfig;
  dynamic client;
  bool _localMode = false;
  int _timeout = 60;

  Http2(
      {this.url,
      this.disabledAuthBearer,
      this.baseURL,
      this.context,
      this.defaultConfig}) {
    _initEnv();
  }

  Future<void> _initEnv() async {
    await dotenv.load(fileName: ".env");

    String? localMode = dotenv.get('HTTP2_LOCAL_MODE');
    String? timeout = dotenv.get('HTTP2_TIMEOUT');

    _localMode = bool.parse(localMode);

    if (timeout != null) {
      _timeout = int.parse(timeout);
    }
  }

  Future<Map<String, dynamic>> localDataStorage() async {
// Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? apiBaseURL = prefs.getString('api_baseURL');
    final dynamic userLogin = prefs.getString('user');
    final String? token = prefs.getString('token');
    Map<String, String?> dataStorage = {
      'apiBaseURL': apiBaseURL,
      'userLogin': userLogin,
      'token': token
    };
    return dataStorage;
  }

  String parseUrlParams(String url, UserResult? userResult, String? params,
      {bool omitGlobalParams = false}) {
    // configuraciones de las url parametrizadas
    //informacion de la empresa del usuario
    String paramsStr = "";

    if (!omitGlobalParams) {
      if (!url.contains('username')) {
        if (!url.contains('?')) {
          paramsStr = '?username=${userResult?.username}';
        } else {
          paramsStr = '&username=${userResult?.username}';
        }
        url = '$url$paramsStr';
      }
      if (!url.contains('empresaID') || !url.contains('empresaId')) {
        if (!url.contains('?')) {
          paramsStr = '?empresaID=${userResult?.empresaId ?? 0}';
        } else {
          paramsStr = '&empresaID=${userResult?.empresaId ?? 0}';
        }
        url = '$url$paramsStr';
      }
      //para el hostname tomamos los id de los dispositivos
      if (!paramsStr.contains('?') || !url.contains('hostname')) {
        if (!url.contains('?')) {
          paramsStr = '?hostname=${userResult?.deviceID}';
        } else {
          paramsStr = '&hostname=${userResult?.deviceID}';
        }
        url = '$url$paramsStr';
      }
      if (!paramsStr.contains('?') || !url.contains('userID')) {
        if (!url.contains('?')) {
          paramsStr = '?userID=${userResult?.userID}';
        } else {
          paramsStr = '&userID=${userResult?.userID}';
        }
        url = '$url$paramsStr';
      }
    }
    return url;
  }

  Future<ResultResponse> get(
      {required String url,
      XMLHTTPRequestConfig? requestConfig,
      String? params,
      String? setBaseURL,
      bool omitGlobalParams = false}) async {
    var localStorage = await localDataStorage();
    String? baseURL = this.baseURL ?? localStorage["apiBaseURL"];
    if (baseURL == null) {
      throw Exception("configurar apiBaseURL para la conexion de endpoints");
    }
    var resultResponse = ResultResponse(500, '', '' as dynamic);
    String urlCompleta = '';
    if (setBaseURL != null) {
      urlCompleta = setBaseURL;
    } else if (this.url != null) {
      var url1 = this.url ?? '';
      urlCompleta = url1;
    }
    urlCompleta = '$urlCompleta$url';

    final token = localStorage["token"];

    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      // 'authorization': 'Bearer $token'
    };
    if (disabledAuthBearer == null || disabledAuthBearer == false) {
      headers['authorization'] = 'Bearer $token';
    }
    var dataUser = localStorage['userLogin'];
    UserResult? userResult;
    if (dataUser != null) {
      var parseData = jsonDecode(dataUser);
      userResult = UserResult.fromJson(parseData["data"]);
    }

    urlCompleta = parseUrlParams(urlCompleta, userResult, params,
        omitGlobalParams: omitGlobalParams);

    try {
      var urlApi = Uri.parse('$baseURL$urlCompleta');
      // http.Response response = await http.get(url0);
      // print("url api: $urlApi");
      http.Response response;
      if (_localMode) {
// esta configuracion es solo para cuando se usa en modo local
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        final httpClient = IOClient(client);
        response = await httpClient
            .get(urlApi, headers: headers)
            .timeout(Duration(seconds: _timeout));
      } else {
//esta se usa para conexion en produccion
        response = await http
            .get(urlApi, headers: headers)
            .timeout(Duration(seconds: _timeout));
      }

      // print(response);
//revisamos la informacion de estructura de la api
      var responseData = jsonDecode(response.body);
      log("informacion obtenida de $urlApi");
      log(responseData.toString());

      var parseDataResponse = ResponseApiDTO<dynamic>.fromJson(responseData);
      if (responseData["status"] == 400) {
        resultResponse.statusCode = responseData["status"];
        resultResponse.message =
            responseData["message"] ?? "error al ejecutar consulta en $urlApi";
        if (_localMode) {
          Toasted(
                  toastLength: ToastLenght.lengthLong,
                  message: '$urlCompleta=>${resultResponse.message}',
                  backgroundColor: Colors.red,
                  textColor: Colors.white)
              .show();
        }
      } else if (responseData["status"] == 200) {
        resultResponse.statusCode = parseDataResponse.data?.statusCode ?? 400;
        resultResponse.message =
            parseDataResponse.data?.message ?? "Obteniendo información";
        resultResponse.data = parseDataResponse.data?.data;
      }
    } catch (ex, stacktrace) {
      log('$urlCompleta=>${ex.toString()}');
      var logger = Logger();
      logger.e('error:', error: ex, stackTrace: stacktrace);
      if (_localMode) {
        Toasted(
                toastLength: ToastLenght.lengthLong,
                message: '$urlCompleta=>${ex.toString()}',
                backgroundColor: Colors.red,
                textColor: Colors.white)
            .show();
      }
      // rethrow;
      resultResponse.statusCode = 500;
      resultResponse.message = ex.toString();
      resultResponse.data = null;
    }
    return resultResponse;
  }

  Future<ResultResponse> post(
      {required String url,
      required Map<String, dynamic> body,
      XMLHTTPRequestConfig? requestConfig,
      bool? disableAuth}) async {
    var localStorage = await localDataStorage();
    String? baseURL = this.baseURL ?? localStorage["apiBaseURL"];
    final token = localStorage["token"];

    if (baseURL == null) {
      throw Exception("configurar apiBaseURL para la conexion de endpoints");
    }
    var resultResponse = ResultResponse(500, '', '' as dynamic);

    String urlCompleta = '';
    if (this.url != null) {
      var url1 = this.url ?? '';
      urlCompleta = url1;
    }
    urlCompleta = '$urlCompleta$url';
    var dataUser = localStorage['userLogin'];
    UserResult? userResult;
    if (dataUser != null) {
      var parseData = jsonDecode(dataUser);
      userResult = UserResult.fromJson(parseData["data"]);
    }

    if (userResult != null) {
      body["empresaID"] = userResult.empresaId!;
      body["deviceID"] = userResult.deviceID!;
      body["username"] = userResult.username.trim();
      body["hostname"] = userResult.deviceID.toString();
      body["userID"] = userResult.userID.toString().trim();
    }
    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      // 'authorization': 'Bearer $token'
    };
    if (disableAuth != true) {
      headers['authorization'] = 'Bearer $token';
    }
    try {
      var urlApi = Uri.parse('$baseURL$urlCompleta');
      var bodyJson = jsonEncode(body);
      log('data enviada: ${bodyJson.toString()}');
      log("informacion enviada a $urlApi");
      log(bodyJson);
      http.Response response;
      if (_localMode) {
// esta configuracion es solo para cuando se usa en modo local
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        final httpClient = IOClient(client);
        response = await httpClient
            .post(urlApi, body: bodyJson, headers: headers)
            .timeout(Duration(seconds: _timeout));
      } else {
//esta se usa para conexion en produccion
        response = await http
            .post(urlApi, body: bodyJson, headers: headers)
            .timeout(Duration(seconds: _timeout));
      }

      log('response devuelto: status:${response.statusCode}, data: ${jsonDecode(response.body)}');

      var responseData = jsonDecode(response.body);
      var parseDataResponse = ResponseApiDTO<dynamic>.fromJson(responseData);

      if (response.statusCode == 200) {
        resultResponse.statusCode = parseDataResponse.data?.statusCode ?? 400;
        resultResponse.message =
            parseDataResponse.data?.message ?? "Registrando información";
        resultResponse.data = parseDataResponse.data?.data;
      } else if (response.statusCode == 500 ||
          response.statusCode == 400 ||
          response.statusCode == 401) {
        resultResponse.statusCode = response.statusCode;
        resultResponse.message = parseDataResponse.message ?? '-';
        resultResponse.data = null;
      }
    } catch (ex, stacktrace) {
      log('$urlCompleta=>${ex.toString()}');
      var logger = Logger();
      logger.e('error:', error: ex, stackTrace: stacktrace);
      Toasted(
              toastLength: ToastLenght.lengthLong,
              message: '$urlCompleta=>${ex.toString()}',
              backgroundColor: Colors.red,
              textColor: Colors.white)
          .show();
      resultResponse.statusCode = 500;
      resultResponse.message = ex.toString();
      resultResponse.data = null;
    }
    return resultResponse;
  }

  Future<ResultResponse> put(
      {required String url,
      required Map<String, dynamic> body,
      XMLHTTPRequestConfig? requestConfig}) async {
    var localStorage = await localDataStorage();
    String? baseURL = this.baseURL ?? localStorage["apiBaseURL"];
    final token = localStorage["token"];

    if (baseURL == null) {
      throw Exception("configurar apiBaseURL para la conexion de endpoints");
    }
    var resultResponse = ResultResponse(500, '', '' as dynamic);

    String urlCompleta = '';
    if (this.url != null) {
      var url1 = this.url ?? '';
      urlCompleta = url1;
    }
    urlCompleta = '$urlCompleta$url';
    var dataUser = localStorage['userLogin'];
    UserResult? userResult;
    if (dataUser != null) {
      var parseData = jsonDecode(dataUser);
      userResult = UserResult.fromJson(parseData["data"]);
    }

    if (userResult != null) {
      body["empresaID"] = userResult.empresaId!;
      body["deviceID"] = userResult.deviceID!;
      body["username"] = userResult.username.trim();
      body["hostname"] = userResult.deviceID.toString();
      body["userID"] = userResult.userID.toString().trim();
    }
    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      // 'authorization': 'Bearer $token'
    };
    if (disabledAuthBearer == null || disabledAuthBearer == false) {
      headers['authorization'] = 'Bearer $token';
    }
    try {
      var urlApi = Uri.parse('$baseURL$urlCompleta');
      var bodyJson = jsonEncode(body);
      log('data enviada: ${bodyJson.toString()}');
      log("informacion enviada a $urlApi");
      log(bodyJson);
      http.Response response;
      if (_localMode) {
// esta configuracion es solo para cuando se usa en modo local
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        final httpClient = IOClient(client);
        response = await httpClient
            .put(urlApi, body: bodyJson, headers: headers)
            .timeout(Duration(seconds: _timeout));
      } else {
//esta se usa para conexion en produccion
        response = await http
            .put(urlApi, body: bodyJson, headers: headers)
            .timeout(Duration(seconds: _timeout));
      }

      log('response devuelto: status:${response.statusCode}, data: ${jsonDecode(response.body)}');
      var responseData = jsonDecode(response.body);
      var parseDataResponse = ResponseApiDTO<dynamic>.fromJson(responseData);

      if (response.statusCode == 200) {
        resultResponse.statusCode = parseDataResponse.data?.statusCode ?? 400;
        resultResponse.message =
            parseDataResponse.data?.message ?? "actualizando información";
        resultResponse.data = parseDataResponse.data?.data;
      } else if (response.statusCode == 500 || response.statusCode == 400) {
        resultResponse.statusCode = response.statusCode;
        resultResponse.message = parseDataResponse?.message ?? '-';
        resultResponse.data = null;
      }
    } catch (ex, stacktrace) {
      log('$urlCompleta=>${ex.toString()}');
      var logger = Logger();
      logger.e('error:', error: ex, stackTrace: stacktrace);
      Toasted(
              toastLength: ToastLenght.lengthLong,
              message: '$urlCompleta=>${ex.toString()}',
              backgroundColor: Colors.red,
              textColor: Colors.white)
          .show();
      resultResponse.statusCode = 500;
      resultResponse.message = ex.toString();
      resultResponse.data = null;
    }
    return resultResponse;
  }

  Future<ResultResponse> delete(
      {required String url,
      Map<String, dynamic>? body,
      XMLHTTPRequestConfig? requestConfig}) async {
    var localStorage = await localDataStorage();
    String? baseURL = this.baseURL ?? localStorage["apiBaseURL"];
    if (baseURL == null) {
      throw Exception("configurar apiBaseURL para la conexion de endpoints");
    }
    var resultResponse = ResultResponse(500, '', '' as dynamic);

    String urlCompleta = '';
    if (this.url != null) {
      var url1 = this.url ?? '';
      urlCompleta = url1;
    }
    urlCompleta = '$urlCompleta$url';
    try {
      var urlApi = Uri.parse('$baseURL$urlCompleta');
      var bodyJson = jsonEncode(body);
      print('data enviada: ${bodyJson.toString()}');
      // http.Response response = await http.get(url0);
      var response = await http
          .delete(
            urlApi,
            headers: {
              'Content-Type': 'application/json',
              // Indica que el cuerpo está en formato JSON
            },
            body: bodyJson,
          )
          .timeout(const Duration(seconds: 10));
      print(
          'response devuelto: status:${response.statusCode}, data: ${jsonDecode(response.body)}');
      var responseData = jsonDecode(response.body);
      var parseDataResponse = ResponseApiDTO<dynamic>.fromJson(responseData);

      resultResponse.statusCode = parseDataResponse.data?.statusCode ?? 400;
      resultResponse.message =
          parseDataResponse.data?.message ?? "Obteniendo información";
      resultResponse.data = parseDataResponse.data?.data;
    } catch (ex, stacktrace) {
      log('$urlCompleta=>${ex.toString()}');
      var logger = Logger();
      logger.e('error:', error: ex, stackTrace: stacktrace);
      Toasted(
              toastLength: ToastLenght.lengthLong,
              message: '$urlCompleta=>${ex.toString()}',
              backgroundColor: Colors.red,
              textColor: Colors.white)
          .show();
      resultResponse.statusCode = 500;
      resultResponse.message = ex.toString();
      resultResponse.data = null;
    }
    return resultResponse;
  }
}
