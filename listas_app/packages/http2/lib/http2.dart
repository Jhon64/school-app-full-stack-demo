import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http2/entities/response_api_dto.dart';
import 'package:http2/entities/result_response.dart';
import 'package:http2/entities/xml_http_request_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utils/utils.dart';

class Http2 {
  String? baseURL;
  String? url;
  XMLHTTPRequestConfig? defaultConfig;
  dynamic client;

  Http2({this.url, this.baseURL, this.defaultConfig});

  Future<Map<String, String?>> localDataStorage() async {
// Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? apiBaseURL = prefs.getString('api_baseURL');
    Map<String, String?> dataStorage = {'apiBaseURL': apiBaseURL};
    return dataStorage;
  }

  Future<ResultResponse> get(
      {required String url, XMLHTTPRequestConfig? requestConfig}) async {
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
      // http.Response response = await http.get(url0);
      var response =
          await http.get(urlApi).timeout(const Duration(seconds: 10));

//revisamos la informacion de estructura de la api
      var responseData = jsonDecode(response.body);
      var parseDataResponse = ResponseApiDTO<dynamic>.fromJson(responseData);

      resultResponse.statusCode = parseDataResponse.data?.statusCode ?? 400;
      resultResponse.message =
          parseDataResponse.data?.message ?? "Obteniendo información";
      resultResponse.data = parseDataResponse.data?.data;
    } catch (ex) {
      Toasted(
          message: ex.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white);
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
      var response = await http.post(
        urlApi,
        body: bodyJson,
        headers: {
          'Content-Type': 'application/json',
          // Indica que el cuerpo está en formato JSON
        },
      ).timeout(const Duration(seconds: 10));
      print(
          'response devuelto: status:${response.statusCode}, data: ${jsonDecode(response.body)}');

      var responseData = jsonDecode(response.body);
      var parseDataResponse = ResponseApiDTO<dynamic>.fromJson(responseData);

      resultResponse.statusCode = parseDataResponse.data?.statusCode ?? 400;
      resultResponse.message =
          parseDataResponse.data?.message ?? "Registrando información";
      resultResponse.data = parseDataResponse.data?.data;
    } catch (ex) {
      print(ex);
      // rethrow;
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
      var response = await http.put(
        urlApi,
        body: bodyJson,
        headers: {
          'Content-Type': 'application/json',
          // Indica que el cuerpo está en formato JSON
        },
      ).timeout(const Duration(seconds: 10));
      print(
          'response devuelto: status:${response.statusCode}, data: ${jsonDecode(response.body)}');
      var responseData = jsonDecode(response.body);
      var parseDataResponse = ResponseApiDTO<dynamic>.fromJson(responseData);

      resultResponse.statusCode = parseDataResponse.data?.statusCode ?? 400;
      resultResponse.message =
          parseDataResponse.data?.message ?? "Obteniendo información";
      resultResponse.data = parseDataResponse.data?.data;
    } catch (ex) {
      print(ex);
      // rethrow;
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
    } catch (ex) {
      print(ex);
      // rethrow;
      resultResponse.statusCode = 500;
      resultResponse.message = ex.toString();
      resultResponse.data = null;
    }
    return resultResponse;
  }
}
