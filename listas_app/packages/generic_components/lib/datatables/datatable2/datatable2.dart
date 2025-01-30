import 'package:flutter/material.dart';
import 'package:generic_components/datatables/datatable2/entities/data_table2_columns.dart';

class Datatable2<T> extends StatefulWidget {
  final List<DataTable2Columns<T>>? columns;
  final List<DataTable2Columns<T>> Function()? customColumns;
  final double? headingRowHeight;
  final double? columnSpacing;
  final TableBorder? border;
  final WidgetStateProperty<Color?>? headingRowColor;
  final TextStyle? headingTextStyle;
  final WidgetStateProperty<Color?>? dataRowColor;
  final double dataRowHeight;
  final double dataRowMinHeight;
  final double dataRowMaxHeight;
  final bool? showIndexColumn;
  final void Function(T item)? onRowSelected;
  final bool? activeRowSelected;

  // Nuevo parámetro para manejar el onLongPress
  final void Function(T item)? onLongPress;

  final List<T>? data;
  final List<T> Function()? customData;

  const Datatable2({
    super.key,
    this.data,
    this.activeRowSelected,
    this.headingRowHeight = 40.0,
    this.dataRowHeight = 60.0,
    this.dataRowMinHeight = 60.0,
    this.dataRowMaxHeight = 60.0,
    this.columnSpacing,
    this.border = const TableBorder(
      top: BorderSide(color: Colors.grey, width: 0.5),
      bottom: BorderSide(color: Colors.grey, width: 0.5),
      right: BorderSide(color: Colors.grey, width: 0.5),
      left: BorderSide(color: Colors.grey, width: 0.5),
      horizontalInside: BorderSide(color: Colors.grey, width: 1),
    ),
    this.headingRowColor,
    this.headingTextStyle,
    this.dataRowColor,
    this.customData,
    this.columns,
    this.onRowSelected,
    this.showIndexColumn,
    this.customColumns,
    this.onLongPress, // Asegúrate de incluir el nuevo parámetro
  });

  @override
  State<Datatable2> createState() => _Datatable2State<T>();
}

class _Datatable2State<T> extends State<Datatable2<T>> {
  List<DataRow> parseData = [];
  List<DataColumn> parseColumns = [];
  List<DataTable2Columns<T>> listColumnProcess = [];
  dynamic itemSelected = {}; // Para mantener el elemento seleccionado

  bool isRowSelected = false; // Estado para saber si la fila está seleccionada

  @override
  void initState() {
    super.initState();
    configureColumns();
  }

  @override
  void didUpdateWidget(covariant Datatable2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.columns != oldWidget.columns ||
        widget.customColumns != oldWidget.customColumns) {
      if (mounted) {
        configureColumns();
      }
    }
    if (widget.data != oldWidget.data ||
        widget.customData != oldWidget.customData) {
      if (mounted) {
        configureColumns();
      }
    }
  }

  WidgetStateProperty<Color?>? dataRowSelectedStyle(dynamic item) {
    if (isRowSelected) {
      return MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.blue.withOpacity(0.5); // Color al estar seleccionada
          }
          return Colors.grey.withOpacity(0.3); // Color normal
        },
      );
    }
    return null;
  }

  void configureColumns() {
    List<DataTable2Columns<T>> initColumnsConfig = [];
    var initDataConfig = [];

    if (widget.columns != null) {
      initColumnsConfig = widget.columns!;
    } else if (widget.customColumns != null) {
      initColumnsConfig = widget.customColumns!();
    }

    if (widget.data != null) {
      initDataConfig = widget.data!;
    } else if (widget.customData != null) {
      initDataConfig = widget.customData!();
    }

    List<DataColumn> columnsDataTable = [];
    List<DataRow> dataDataTable = [];
    Map<String, DataTable2Columns<T>> mapColumnsConfig = {};
    int index = 0;

    for (var itemColumn in initColumnsConfig) {
      mapColumnsConfig[itemColumn.dataKey] = itemColumn;
      if (index == 0 && widget.showIndexColumn == true) {
        columnsDataTable
            .add(const DataColumn(label: SizedBox(child: Text('Item'))));
      }
      columnsDataTable.add(DataColumn(
        label: itemColumn.customCellHeader != null
            ? SizedBox(child: itemColumn.customCellHeader!())
            : SizedBox(child: Text(itemColumn.label ?? "")),
      ));
      index++;
    }

    setState(() {
      parseColumns = columnsDataTable;
      listColumnProcess = initColumnsConfig;
    });

    if (initDataConfig.isNotEmpty) {
      for (int i = 0; i < initDataConfig.length; i++) {
        var itemReg = initDataConfig[i];
        var itemRegJson = itemReg.toJson() ?? {};
        List<DataCell> cells = [];
        if (widget.showIndexColumn != null && widget.showIndexColumn == true) {
          cells.add(DataCell(Text('${i + 1}')));
        }
        for (int j = 0; j < initColumnsConfig.length; j++) {
          var itemColumn = initColumnsConfig[j];
          if (itemColumn.customCellData != null) {
            cells.add(DataCell(
                SizedBox(child: itemColumn.customCellData!(itemReg!))));
          } else if (itemColumn.dataKey != null) {
            cells.add(DataCell(SizedBox(
                child: Text('${itemRegJson[itemColumn.dataKey] ?? ''}'))));
          }
        }

        DataRow row = DataRow(
          color: dataRowSelectedStyle(itemRegJson),
          cells: cells,
          onLongPress: () {
            setState(() {
              isRowSelected =
                  !isRowSelected; // Cambiar el estado de la fila seleccionada
              itemSelected = itemRegJson;
            });
            // Llamar al callback de onLongPress si está definido
            if (widget.onLongPress != null) {
              widget.onLongPress!(itemReg); // Pasar el item a la función
            }
            if (widget.onRowSelected != null) {
              widget.onRowSelected!(itemReg); // Pasar el item a la función
            }
          },
        );
        dataDataTable.add(row);
      }
    } else {
      List<DataCell> cells = [];
      for (int j = 0; j < initColumnsConfig.length; j++) {
        if (j == 0) {
          cells.add(const DataCell(Center(
            child: Text("Sin Registros", textAlign: TextAlign.center),
          )));
          if (widget.showIndexColumn == true) {
            cells.add(DataCell.empty);
          }
        } else {
          cells.add(DataCell.empty);
        }
      }
      DataRow row = DataRow(cells: cells);
      dataDataTable.add(row);
    }

    setState(() {
      parseData = dataDataTable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: parseColumns,
          rows: parseData,
          columnSpacing: 25,
          headingRowHeight: widget.headingRowHeight,
          // dataRowMinHeight: widget.dataRowMinHeight,
          // dataRowMaxHeight: widget.dataRowMaxHeight,
          dataRowHeight: widget.dataRowHeight,
          border: widget.border,
          headingRowColor: MaterialStateProperty.all(
              Theme.of(context).primaryColor.withAlpha(210)),
          headingTextStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          dataRowColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.green.withOpacity(0.08);
              }
              return null; // Color por defecto
            },
          ),
        ),
      ),
    );
  }
}
