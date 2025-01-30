import 'dart:developer';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:generic_components/forms/form_dynamic/entities/generic_item_form.dart';

abstract class SelectText2Operations {
  Map<String, dynamic> toJson();
}

class SelectText2<T extends SelectText2Operations> extends StatefulWidget {
  final bool? isEnabled;

  // final dynamic? keyComponent;
  final bool? enableSearch;
  final ValueChanged<dynamic>? onChanged; // Cambiado a dynamic
  final FormFieldValidator<String>? validator;

  final String keyValue; //id
  //opciones
  final String keyLabel; //nombre
  final String Function(T data)? customLabel;

  //input
  final String? label; //
  final TextStyle? labelStyle;
  final String? hint;
  final Map<String, GenericItemForm>? formSave;
  final String? formKey;
  final dynamic defaultValue;
  final List<T> data;
  final bool? required;
  final bool? search;
  final bool? showClear;
  final double? width;
  final int? dropDownItemCount;

  final void Function(T? value)? onSelected;

  const SelectText2(
      {super.key,
      // this.keyComponent,
      this.isEnabled,
      this.enableSearch,
      this.onChanged,
      this.customLabel,
      required this.keyValue,
      this.defaultValue,
      this.labelStyle,
      this.label,
      this.width,
      this.onSelected,
      this.formSave,
      this.formKey,
      this.hint,
      this.required,
      this.search,
      this.showClear,
      required this.data,
      required this.keyLabel,
      this.dropDownItemCount,
      this.validator});

  @override
  State<SelectText2> createState() => _SelectText2State<T>();
}

class _SelectText2State<T extends SelectText2Operations>
    extends State<SelectText2<T>> {
  late SingleValueDropDownController controller =
      SingleValueDropDownController(data: null);
  late List<DropDownValueModel> dropDownList = [];
  late FocusNode focusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      focusNode = FocusNode();
      controller.addListener(() {
        if (controller.dropDownValue == null) {
          handleChange(null);
        }
      });

      inicializarControllers();
      inicializarLista();
    }
  }

  @override
  void didUpdateWidget(covariant SelectText2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      log("El state select2 data cambios regs ${widget.formKey}: ${widget.data.length}");
      Future.microtask(() {
        if (mounted) {
          inicializarLista();
        }
      });
    }

    if (widget.formSave != null && widget.formKey != null) {
      if (widget.formKey == "v2") {
        log("probando");
      }
      if (widget.formSave![widget.formKey!]?.value !=
          oldWidget.formSave![oldWidget.formKey]?.value) {
        log("El state select2 default a cambiado ${widget.formKey}: ${widget.formSave![widget.formKey]?.value}");

        if (mounted) {
          inicializarControllers();
        }
      }
    }

    if (widget.defaultValue != oldWidget.defaultValue) {
      if (mounted) {
        log("El state select2 default a cambiado ");
        inicializarControllers();
      }
    }
  }

  void inicializarLista() {
    print("El state inicial regs : ${widget.data.length}");
    List<DropDownValueModel> selectsList = [];
    for (T itemReg in widget.data ?? []) {
      Map<String, dynamic> itemMap = itemReg.toJson();
      var item = DropDownValueModel(
          name: widget.customLabel != null
              ? widget.customLabel!(itemReg)
              : itemMap[widget.keyLabel],
          value: itemMap[widget.keyValue]);
      selectsList.add(item);
    }
    if (mounted) {
      setState(() {
        dropDownList = selectsList;
      });
    }

    //revisamos si hay un valor por defecto inicial en formulario o default value

    if (widget.defaultValue != null ||
        (widget.formSave != null &&
            widget.formKey != null &&
            widget.formSave![widget.formKey!] != null)) {
      inicializarControllers();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (mounted) {
      focusNode.dispose();
    }
  }

  void inicializarControllers() {
    //inicializamos si viene con algun valor default

    SingleValueDropDownController initValue = SingleValueDropDownController();
    DropDownValueModel modelDefault;

    for (dynamic itemReg in widget.data) {
      Map<String, dynamic> itemMap = itemReg.toJson();
      if (widget.defaultValue != null) {
        if (itemMap[widget.keyValue] != null &&
            itemMap[widget.keyValue] == widget.defaultValue) {
          modelDefault = DropDownValueModel(
              name: itemMap[widget.keyLabel], value: itemMap[widget.keyValue]);
          initValue.dropDownValue = modelDefault;
          break;
        }
      } else {
        if (itemMap[widget.keyValue] != null &&
            widget.formKey != null &&
            widget.formSave != null) {
          var valueForm = widget.formSave![widget.formKey!]?.value;
          log('init value ${widget.formKey}: ${valueForm.toString()}');
          if (itemMap[widget.keyValue] == valueForm) {
            log("registor encontrado $itemMap");
            modelDefault = DropDownValueModel(
                name: itemMap[widget.keyLabel],
                value: itemMap[widget.keyValue]);
            initValue.dropDownValue = modelDefault;
            break;
          }
        } else {
          initValue.dropDownValue = null;
          break;
        }
      }
    }

    if (mounted) {
      // setState(() {
      controller = initValue;
      // });
    }
  }

  void handleChange(dynamic value) {
    log("valor seleccionado $value");

    dynamic valueSelect = '';
    if (value == '') {
      valueSelect = value;
    } else {
      valueSelect = value.value;
    }
    dynamic findRegistro;

    for (dynamic itemReg in widget.data) {
      Map<String, dynamic> itemMap = itemReg.toJson();
      if (itemMap[widget.keyValue] != null &&
          itemMap[widget.keyValue] == valueSelect) {
        findRegistro = itemReg;
        break;
      }
    }
    if (widget.formKey != null && widget.formSave != null) {
      widget.formSave![widget.formKey!] =
          GenericItemForm(key: widget.formKey!, value: valueSelect);
    }

    if (widget.onSelected != null) {
      widget.onSelected!(findRegistro);
    }

    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // / double padding = screenWidth > 600 ? 12.0 : 12.0;
    double padding = 12.0;
    return SizedBox(
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.label != null)
              Text(
                widget.label ?? "",
                style: widget.labelStyle,
              ),
            DropDownTextField(
              key: widget.key,
              controller: controller,
              clearOption: true,
              searchShowCursor: true,
              isEnabled: widget.isEnabled ?? true,
              enableSearch: widget.enableSearch ?? true,
              padding: EdgeInsets.all(padding),
              searchAutofocus: true,
              textFieldDecoration: InputDecoration(
                hintText: widget.hint ?? "Seleccione una opción",
                contentPadding: EdgeInsets.all(padding),
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              dropDownItemCount: widget.dropDownItemCount ?? 3,
              dropDownList: dropDownList,
              onChanged: handleChange,
              // Esto ahora debería funcionar
              validator: widget.validator ??
                  (value) {
                    if (widget.required != true) return null;
                    if (value == null || value.isEmpty) {
                      return 'Seleccione una opcion';
                    }
                    return null;
                  },
            ),
          ],
        ));
  }
}
