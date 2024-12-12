class ResultResponse <T extends dynamic>{
  late int statusCode;
  String? message;
  T? data;

  ResultResponse(int statusCode, String? message, T? data);
// ResultResponse({required this.statusCode,this.message,this.data});
}