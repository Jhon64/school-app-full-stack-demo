abstract class OperacionesLocalstorage {
  Map<String, dynamic> toJson();
  static OperacionesLocalstorage fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('Debes implementar fromJson en la subclase');
  }
}