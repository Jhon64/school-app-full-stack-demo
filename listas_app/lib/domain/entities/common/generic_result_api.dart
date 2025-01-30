class GenericResultAPI<T extends dynamic> {
  int statusCode;
  String? message;
  T? data;

  GenericResultAPI({required this.statusCode, this.message, this.data});
}
