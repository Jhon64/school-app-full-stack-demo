import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormProduct<T extends dynamic> extends StatelessWidget {
  Map<String, dynamic> tempForm = {};
  bool? resetForm;

  void Function(Map<String, dynamic> form)? getForm;
  T form;

  FormProduct({super.key, required this.form, this.getForm, this.resetForm})
      : tempForm = (jsonDecode(jsonEncode(form)));



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
  Widget build(BuildContext context) {
    print('componente montado:  ${tempForm.toString()}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: (value) => _handleChangeValue('nombre', value),
          // controller: getController('nombre'),
          // Controlador dinámico para "name"
          decoration: InputDecoration(labelText: "Nombre", hintText: "Nombre"),
        ),
        SizedBox(
          height: 2.0,
        ),
        TextField(
          onChanged: (value) => _handleChangeValue('descripcion', value),
          // controller: getController('descripcion'),
          // Controlador dinámico para "name"
          decoration: const InputDecoration(
              labelText: "Descripción", hintText: "Descripción"),
        ),
        SizedBox(
          height: 2.0,
        ),
        TextField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          // Activa el teclado con punto decimal
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            // Permite dígitos y un solo punto decimal
          ],
          onChanged: (value) => _handleChangeValue('precio', value),
          // controller: getController('precio'),
          decoration: InputDecoration(labelText: "Precio", hintText: "Precio"),
        ),
      ],
    );
  }
}
