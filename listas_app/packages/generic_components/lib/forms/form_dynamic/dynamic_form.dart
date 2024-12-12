import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_components/forms/form_dynamic/entities/generic_item_form.dart';
import 'package:generic_components/forms/form_dynamic/interfaces/i_dynamic_form_methods.dart';
import 'package:generic_components/forms/form_dynamic/widgets/InputDecorationForm.dart';
import 'package:utils/toasted/toasted.dart';

import 'entities/entities.dart';

class DynamicForm<T extends IDynamicFormMethods> extends StatefulWidget {
  //propiedades
  // Map<String, GenericItemForm>? form;
  String? title;
  double? padding;
  bool? validatePropsClass;
  Map<String, GenericItemFormOptions> configItemsForm;
  ButtonFormCancelProps? buttonCancelProps;
  ButtonFormSaveProps? buttonSaveProps;
  T classBase;

  //funciones de propiedades
  void Function(Map<String, GenericItemForm> form)? getForm;
  void Function(BuildContext context)? onCancel;
  void Function(BuildContext context)? onSave;
  void Function(GlobalKey<FormState> formKey)? getFormKey;
  Future<void> Function(BuildContext context)? onSaveFuture;
  void Function(IDynamicFormMethods? form)? onParseClassToForm;

  DynamicForm(
      {super.key,
      // required this.form,
      required this.configItemsForm,
      required this.classBase,
      this.getForm,
      this.title,
      this.padding,
      this.onCancel,
      this.onSave,
      this.getFormKey,
      this.validatePropsClass,
      this.onSaveFuture,
      this.buttonCancelProps,
      this.buttonSaveProps,
      this.onParseClassToForm});

  @override
  State<DynamicForm<T>> createState() => _DynamicFormState();
}

@override
void dispose() {}

class _DynamicFormState<T extends IDynamicFormMethods>
    extends State<DynamicForm<T>> {
  Map<String, GenericItemForm> _tempForm = {};
  late final Map<String, TextEditingController> _controllers = {};

  // final Map<String, GenericItemForm> _form = {};
  void Function(Map<String, GenericItemForm> form)? getForm;
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    setState(() {
      getForm = widget.getForm;
    });
    // _tempForm = widget.form;
    if (widget.validatePropsClass != null) {
      //usamos para limitar las props a los parametros que toene la clase
      validateAttributes();
    }
    if (mounted) {
      initializeForm();
    }
  }

  void initializeForm() {
    // setState(() {
    //   _tempForm=parseClassToForm(widget.classBase);
    // });
    _tempForm = parseClassToForm(widget.classBase);
    initController();
  }

  void validateAttributes() {
    // Verifica que la clave sea un atributo válido de la clase T
    _tempForm.forEach((key, value) {
      if (T.toString().contains(key)) {
        print('La clave $key es válida para la clase $T');
      } else {
        print('La clave $key no es válida para la clase $T');
        // throw ArgumentError('La clave $key no es válida para la clase $T');
      }
    });
  }

  void initController() {
    // print(tempForm);
    var temp2 = _tempForm;
    _tempForm.forEach((key, value) {
      if (!temp2.containsKey(key)) {
        temp2[key] = value;
        return;
      }
      _controllers[key] = TextEditingController(
          text: value.value == null ? '' : value.value.toString());
    });
    // if (getForm != null) {
    //   getForm!(temp2);
    // }
  }

  TextEditingController getController(String key) {
    if (!_controllers.containsKey(key)) {
      if (_controllers[key] == null) {
        _controllers[key] = TextEditingController();
      }
    }
    return _controllers[key]!;
  }

  void _handleChangeValue(String keyForm, dynamic value) {
    if (!_tempForm.containsKey(keyForm)) {
      _tempForm[keyForm] =
          GenericItemForm(key: keyForm, value: value, editing: true);
      return;
    } else {
      var itemForm = _tempForm[keyForm];
      if (itemForm != null) {
        itemForm.value = value;
        itemForm.editing = true;
        _tempForm[keyForm] = itemForm;
      }
    }
  }

  @override
  void dispose() {
    for (TextEditingController controller in _controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  void handleCancelModal(BuildContext context) {
    if (widget.onCancel != null) {
      widget.onCancel!(context);
    } else {
      Navigator.of(context).pop(); // Cierra el modal
    }
  }

  Map<String, GenericItemForm> parseClassToForm(
      IDynamicFormMethods? dynamicForm) {
    Map<String, GenericItemForm> parseForm = {};
    //obtenemos toda la informacion del mapa
    if (dynamicForm != null) {
      ///cuando tenemos un registro usamos esa configuracion base para
      ///generar una configuracion de formulario dinamico
      var prodMap = dynamicForm.toJsonWithNull();
      prodMap.forEach((key, value) {
        parseForm[key] =
            GenericItemForm(key: key, value: value, editing: false);
      });
    } else {
      widget.classBase?.toJsonWithNull().forEach((key, value) {
        parseForm[key] = GenericItemForm(key: key, editing: false);
      });
    }
    parseForm.forEach((key, value) {
      var itemForm = parseForm[key];
      if (itemForm != null) {
        var configItemForm = widget.configItemsForm[key];
        if (configItemForm != null) {
          itemForm.options = configItemForm;
        }
        parseForm[key] = itemForm;
      }
    });
    return parseForm;
  }

  List<Widget> _generateWidgets() {
    List<Widget> list = [];
    _tempForm.forEach((key, itemForm) {
      if (itemForm.options?.hidden == null ||
          itemForm.options?.hidden == false) {
        if (itemForm.options?.typeData == TypeData.decimal) {
          list.add(
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
              onChanged: (value) => _handleChangeValue(itemForm.key, value),
              controller: getController(itemForm.key),
              decoration: InputDecoration(
                labelText: itemForm.options?.label ?? itemForm.key,
                hintText: itemForm.options?.hintText ?? itemForm.options?.label,
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                ),
              ),
            ),
          );
        } else {
          list.add(TextFormField(
              onChanged: (value) => _handleChangeValue(itemForm.key, value),
              controller: getController(itemForm.key),
              validator: (value) {
                if (itemForm.options?.isRequired == true) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio.';
                  }
                }

                return null;
              },
              decoration: inputDecorationForm2(
                  label: itemForm.options?.label ?? '',
                  hintText:
                      itemForm.options?.hintText ?? itemForm.options?.label)));
        }
        list.add(const SizedBox(
          height: 2.0,
        ));
      }
    });
    return list;
  }

  Widget generateFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _generateWidgets(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // for(var k in _tempForm.values){
    //   print('componente montado:  ${k.value}');
    // }

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.title ?? ""),
            const SizedBox(height: 2.0),
            Form(key: _formKey, child: generateFormFields()),
            const SizedBox(height: 4.0),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: widget.buttonCancelProps?.iconBtnCancelar ??
                      const Icon(Icons.arrow_back_sharp),
                  onPressed: () => handleCancelModal(context),
                  label: Text(
                      widget.buttonCancelProps?.textBtnCancelar ?? "Cancelar"),
                ),
                TextButton.icon(
                  onPressed: () {
                    var isValidForm = _formKey.currentState!.validate();
                    if (!isValidForm) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Validar campos requeridos')),
                      // );
                      Toasted.Error(message: 'Validar campos requeridos')
                          .show();
                    } else {
                      if (getForm != null) {
                        Map<String, GenericItemForm> formParseValid = {};
                        _tempForm.forEach((k, v) {
                          if (v.editing == true) {
                            formParseValid[k] = GenericItemForm(
                                key: k,
                                options: v.options,
                                value: v.editing == true ? v.value : null);
                          }
                        });
                        if (formParseValid.isEmpty) {
                          Toasted(message: "No hay datos para enviar").show();
                          return;
                        } else {
                          getForm!(_tempForm);
                        }
                      }
                      if (widget.onSave != null) {
                        widget.onSave!(context);
                      } else if (widget.onSaveFuture != null) {
                        widget.onSaveFuture!(context);
                      }
                    }
                  },
                  icon: widget.buttonSaveProps?.iconBtnAceptar ??
                      const Icon(Icons.save),
                  label:
                      Text(widget.buttonSaveProps?.textBtnAceptar ?? 'Aceptar'),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
    // return
  }
}
