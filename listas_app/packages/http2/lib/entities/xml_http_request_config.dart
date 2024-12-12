import 'dart:convert';

class XMLHTTPRequestConfig{
  String? authorization;
  String? contentType;
  String? accept;
  XMLHTTPRequestConfig();


  Map<String,String> toJson(){
    return jsonDecode(jsonEncode(this));
  }
}