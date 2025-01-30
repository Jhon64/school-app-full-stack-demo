import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_components/forms/form_dynamic/entities/generic_item_form.dart';

import '../../forms/form_dynamic/widgets/InputDecorationForm.dart';

enum TypeTextField { string, int, decimal }

class TextFormField2 extends StatefulWidget {
  final String? label;
  final String? hint;
  final Map<String, GenericItemForm>? formSave;
  final String? formKey;
  final dynamic defaultValue;
  final dynamic Function()? customDefaultValue;
  final bool? required;
  final bool? search;
  final bool? showClear;
  final bool? enabled;
  final TextStyle? titleTextStyle;
  final TypeTextField? type;
  final void Function(dynamic value)? onChange;
  final void Function(String value)? onBlur;
  final InputDecoration? decoration;
  final Color? colorBackground; // Nuevo parámetro

  const TextFormField2({
    super.key,
    this.defaultValue,
    this.decoration,
    this.customDefaultValue,
    this.enabled,
    this.label,
    this.formSave,
    this.titleTextStyle,
    this.formKey,
    this.hint,
    this.required,
    this.search,
    this.type,
    this.showClear,
    this.onBlur,
    this.onChange,
    this.colorBackground, // Añadido al constructor
  });

  @override
  State<TextFormField2> createState() => _TextFormField2State();
}

class _TextFormField2State extends State<TextFormField2> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      initValues();
    }
  }

  @override
  void didUpdateWidget(covariant TextFormField2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.defaultValue != oldWidget.defaultValue ||
        widget.customDefaultValue != oldWidget.customDefaultValue) {
      if (mounted) {
        initController();
      }
    }

    if (widget.formKey != null && widget.formSave != null) {
      if (widget.formKey == 'codigoProducto') {
        log("validando");
      }
      var newValue = widget.formSave![widget.formKey]?.value;
      var oldValue = oldWidget.formSave![oldWidget.formKey]?.value;
      log('${widget.formKey}: nuevo valor $newValue');
      log('${widget.formKey}: anterior valor $oldValue');

      log("ha cambiado el valor en el textinput:: ${widget.formSave![widget.formKey]?.value}");
      if (mounted) {
        initController();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (mounted) {
      _controller.dispose();
    }
  }

  void _onBlur() {
    var inputText = _controller.text;
    if (widget.onBlur != null) {
      widget.onBlur!(inputText);
    }
  }

  void initValues() {
    initController();
  }

  void initController() {
    dynamic letValue = '';
    if (widget.defaultValue != null) {
      letValue = widget.defaultValue;
    } else if (widget.customDefaultValue != null) {
      letValue = widget.customDefaultValue!();
    } else if (widget.formSave != null && widget.formKey != null) {
      letValue = widget.formSave![widget.formKey]?.value ?? '';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.text = letValue.toString();
      }
    });
  }

  void _handleChangeValue(String? key, dynamic value) {
    if (widget.formSave != null && widget.formKey != null) {
      widget.formSave![widget.formKey!] =
          GenericItemForm(key: widget.formKey!, value: value);
    }
    dynamic valueParse = value;

    if (widget.type == TypeTextField.int) {
      valueParse = int.parse(value.toString());
    } else if (widget.type == TypeTextField.decimal) {
      valueParse = value.toString();
    } else if (widget.type == TypeTextField.string) {
      valueParse = value;
    } else {
      valueParse = valueParse.toString();
    }

    if (widget.onChange != null) {
      widget.onChange!(value);
    }
  }

  void setController(String valor) {
    _controller.text = valor;
  }

  TextEditingController getController() {
    return _controller;
  }

  List<Widget> generateContent() {
    List<Widget> list = [];

    if (widget.label != null) {
      list.add(Text(
        widget.label ?? "",
        style: widget.titleTextStyle,
      ));
    }

    list.add(Container(
      child: TextFormField(
        enabled: widget.enabled ?? true,
        keyboardType: widget.type == TypeTextField.decimal
            ? const TextInputType.numberWithOptions(decimal: true)
            : widget.type == TypeTextField.int
                ? TextInputType.number
                : null,
        inputFormatters: widget.type == TypeTextField.decimal
            ? [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ]
            : widget.type == TypeTextField.int
                ? [
                    FilteringTextInputFormatter.digitsOnly,
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
        decoration: widget.decoration != null
            ? widget.decoration!.copyWith(
                filled: widget.colorBackground != null ||
                    (widget.decoration?.filled ?? false),
                fillColor:
                    widget.colorBackground ?? widget.decoration!.fillColor,
              )
            : inputDecorationForm2(
                hintText: widget.hint ?? '',
                required: widget.required,
              ).copyWith(
                filled: widget.colorBackground != null,
                fillColor: widget.colorBackground,
              ),
      ),
    ));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: generateContent(),
      ),
    );
  }
}
