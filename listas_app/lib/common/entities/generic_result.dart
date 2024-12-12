class GenericResult<T extends dynamic> {
  int statusCode;
  String? message;
  T? data;

  GenericResult({required this.statusCode, this.message, this.data});
}
