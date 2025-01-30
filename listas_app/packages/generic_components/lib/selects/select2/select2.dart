import 'package:flutter/material.dart';
import '../../forms/form_dynamic/entities/generic_item_form.dart';
import '../../forms/form_dynamic/widgets/InputDecorationForm.dart';

class Select2<T> extends StatefulWidget {

  //{id:1,nombre:'ssss',descripcion:'asdadasd',...}
  @override
  State<Select2> createState() => _Select2State();
  //opciones
  late String keyValue;//id
  //opciones
  late String keyLabel;//nombre
  //input
  late String label;//
  late String? hint;
  Map<String, GenericItemForm>? formSave;
  late String? formKey;
  dynamic defaultValue;
  late List<T> data;
  late bool? required;
  late bool? search;
  late bool? showClear;

  void Function(T value)? onSelected;

  Select2(
      {super.key,
      required this.keyValue,
      this.defaultValue,
      required this.label,
        this.onSelected,
      this.formSave,
      this.formKey,
      this.hint,
      this.required,
      this.search,
      this.showClear,
      required this.data,
      required this.keyLabel});

// @override
// void parseData() {}
}

class _Select2State<T> extends State<Select2> {
  dynamic selectedValue;

  @override
  initState() {
    super.initState();
    initializedValues();
  }

  void initializedValues() {
    dynamic defaultValue;
    if (widget.formSave != null && widget.formKey != null) {
      defaultValue = widget.formSave![widget.formKey!]?.value;
    } else {
      defaultValue = widget.defaultValue;
    }
    setState(() {
      selectedValue = defaultValue;
    });
  }

  List<DropdownMenuItem<dynamic>> generateItems() {
    var list = widget.data.map((dynamic option) {
      var json = option.toJson();
      var reg = DropdownMenuItem<dynamic>(
        value: json[widget.keyValue],
        child: Text(json[widget.keyLabel]),
      );
      return reg;
    }).toList();

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<dynamic>(
      decoration: inputDecorationForm2(
          label: widget.label,
          hintText: widget.hint ?? '',
          required: widget.required),
      validator: (value) {
        if (widget.required == true) {
          if (value == null ) {
            return 'Este campo es obligatorio.';
          }
        }

        return null;
      },
      value: selectedValue,
      isExpanded: true,
      hint: Text(widget.hint ?? ''),
      onChanged: (dynamic value) {
        if (widget.formSave != null) {
          widget.formSave![widget.formKey!] =
              GenericItemForm(key: widget.formKey!, value: value);
        }
        if (widget.onSelected != null) {
          widget.onSelected!(value);
        }
      },
      // validator: (dynamic value) {
      //   if (value == null || value.isEmpty) {
      //     return 'Please select an option';
      //   }
      //   return null;
      // },
      items: generateItems(),
    );
  }
}
