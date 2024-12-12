import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_components/forms/form_dynamic/entities/generic_item_form.dart';

import '../../forms/form_dynamic/widgets/InputDecorationForm.dart';

enum TypeTextField { string, int, decimal }

class TextFormField2 extends StatefulWidget {
  late String label;
  late String? hint;
  Map<String, GenericItemForm>? formSave;
  late String? formKey;
  dynamic defaultValue;
  late bool? required;
  late bool? search;
  late bool? showClear;
  late TypeTextField? type;
  void Function(dynamic value)? onChange;

  TextFormField2({
    super.key,
    this.defaultValue,
    required this.label,
    this.formSave,
    this.formKey,
    this.hint,
    this.required,
    this.search,
    this.type,
    this.showClear,
  });

  @override
  State<TextFormField2> createState() => _TextFormField2State();
}

class _TextFormField2State extends State<TextFormField2> {
  TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      initValues();
    }
  }

  void initValues(){
    initController();
  }


  void initController() {
    dynamic letValue='';
    if(widget.formSave!=null && widget.formKey!=null){
      var formValue=widget.formSave![widget.formKey];
    }
    _controller.text=letValue.toString();
  }

  void _handleChangeValue(String? key, dynamic value) {
    if (widget.formSave != null && widget.formKey != null) {
      widget.formSave![widget.formKey!] =
          GenericItemForm(key: widget.formKey!, value: value);
    }
    dynamic valueParse=value;

    if(widget.type==TypeTextField.decimal || widget.type==TypeTextField.int){
      valueParse=value.toString();
    }else if(widget.type==TypeTextField.string){
      valueParse=value;
    }else{
      valueParse=valueParse.toString();
    }
    //setear valor de controller
    setController(valueParse);
    if (widget.onChange != null) {
      widget.onChange!(value);
    }
  }

  void setController(String valor) {
    _controller.text=valor;
  }

  TextEditingController getController() {
    return _controller;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.type == TypeTextField.decimal
          ? TextInputType.numberWithOptions(decimal: true)
          : null,
      inputFormatters: widget.type == TypeTextField.decimal
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              // Permite dígitos y un solo punto decimal
            ]
          : null,
      validator: (value) {
        if (widget.required == true) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio.';
          }
        }

        return null;
      },
      onChanged: (value) => _handleChangeValue(widget.formKey, value),
      controller: getController(),
      decoration: inputDecorationForm2(
          label: widget.label,
          hintText: widget.hint ?? '',
          required: widget.required),
    );
  }
}

//
// class TextFormField2 extends StatelessWidget {
//   late String label;
//   late String? hint;
//   Map<String, GenericItemForm>? formSave;
//   late String? formKey;
//   dynamic defaultValue;
//   late bool? required;
//   late bool? search;
//   late bool? showClear;
//   late TypeTextField? type;
//   void Function(dynamic value)? onChange;
//
//   TextFormField2({
//     super.key,
//     this.defaultValue,
//     required this.label,
//     this.formSave,
//     this.formKey,
//     this.hint,
//     this.required,
//     this.search,
//     this.type,
//     this.showClear,
//   });
//
//   void _handleChangeValue(String? key, dynamic value) {
//     if (formSave != null && formKey!=null) {
//       formSave![formKey!] =
//           GenericItemForm(key: formKey!, value: value);
//     }
//
//     if(onChange!=null){
//       onChange!(value);
//     }
//
//   }
//
//   TextEditingController getController(String? fomKey) {
//     return TextEditingController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       keyboardType: type == TypeTextField.decimal
//           ? TextInputType.numberWithOptions(decimal: true)
//           : null,
//       inputFormatters: type == TypeTextField.decimal
//           ? [
//               FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
//               // Permite dígitos y un solo punto decimal
//             ]
//           : null,
//       validator: (value) {
//         if (required == true) {
//           if (value == null || value.isEmpty) {
//             return 'Este campo es obligatorio.';
//           }
//         }
//
//         return null;
//       },
//       onChanged: (value) => _handleChangeValue(formKey, value),
//       controller: getController(formKey),
//       decoration: inputDecorationForm2(
//           label: label, hintText: hint ?? '', required: required),
//     );
//   }
// }
