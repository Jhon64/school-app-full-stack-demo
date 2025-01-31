import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormProductMultiple<T extends dynamic> extends StatefulWidget {
  void Function(Map<String, dynamic> form)? getForm;
  T form;

  FormProductMultiple({super.key, required this.form, this.getForm});

  @override
  State<FormProductMultiple> createState() => _FormProductMultipleState();
}

@override
void dispose() {}

class _FormProductMultipleState extends State<FormProductMultiple> {
  Map<String, dynamic> tempForm = {};
  late Map<String, TextEditingController> _controllers = {};
  Map<String, dynamic> _form = {};
  void Function(Map<String, dynamic> form)? getForm;

  @override
  initState() {
    super.initState();
    setState(() {
      getForm = widget.getForm;
    });
    tempForm = jsonDecode(jsonEncode(widget.form));
    initController();
  }

  void initController() {
    // print(tempForm);
    tempForm.forEach((key, value) {
      print('key:$key=>valor:$value');
      _controllers[key] = TextEditingController(text: value.toString());
    });
  }

  TextEditingController getController(String key) {
    if (!_controllers.containsKey(key)) {
      if (_controllers[key] == null)
        _controllers[key] = TextEditingController();
    }
    return _controllers[key]!;
  }

  void _handleChangeValue(String keyForm, dynamic value) {
    if (!tempForm.containsKey(keyForm)) {
      tempForm[keyForm] = value;
      return;
    }
    tempForm[keyForm] = value;
    if (getForm != null) {
      getForm!(tempForm);
    }
  }

  @override
  void dispose() {
    for (TextEditingController controller in _controllers.values) {
      controller.dispose();
    }

    // if(mounted){
    //   setState(() {
    //     tempForm = {};
    //     _controllers = {};
    //     _form = {};
    //   });
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('componente montado:  ${tempForm.toString()}');
    return Form(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onChanged: (value) => _handleChangeValue('nombre', value),
          controller: getController('nombre'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio.';
            }
            return null;
          },
          decoration:
              const InputDecoration(labelText: "Nombre", hintText: "Nombre"),
        ),
        const SizedBox(
          height: 2.0,
        ),
        TextFormField(
          onChanged: (value) => _handleChangeValue('descripcion', value),
          controller: getController('descripcion'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio.';
            }
            return null;
          },
          decoration: const InputDecoration(
              labelText: "Descripción", hintText: "Descripción"),
        ),
        const SizedBox(
          height: 2.0,
        ),
        TextFormField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio.';
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            // Permite dígitos y un solo punto decimal
          ],
          onChanged: (value) => _handleChangeValue('precio', value),
          controller: getController('precio'),
          decoration:
              const InputDecoration(labelText: "Precio", hintText: "Precio"),
        ),
      ],
    ));
  }
}
