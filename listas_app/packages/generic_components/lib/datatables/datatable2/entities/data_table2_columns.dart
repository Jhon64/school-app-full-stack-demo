import 'package:flutter/cupertino.dart';

class DataTable2Columns<T> {
  String dataKey;
  String? label;
  Widget Function(T? item)?
      customCellData; //para personalizar las celdas de losc uerpos
  Widget Function()?
      customCellHeader; //para personalizar las celdas de las cabeceras
  DataTable2Columns(
      {required this.dataKey, this.label, this.customCellData, this.customCellHeader});
}
