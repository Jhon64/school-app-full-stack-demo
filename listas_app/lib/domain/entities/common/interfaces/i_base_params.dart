/***
 * interface que se implementa cuando se usan para pasar como parametros en las apis get
*/
abstract class IBaseParams {
  Map<String, dynamic> toJson();
  String convertClassToParams();
}
