import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../forms/form_dynamic/entities/generic_item_form.dart';


class Datepicker2 extends StatefulWidget {
  final String? label;
  final String? hint;
  final Map<String, GenericItemForm>? formSave;
  final String? formKey;
  final bool? required;
  final bool? enabled;
  final DateTime? defaultDate;
  final TextStyle? titleTextStyle;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime? value)? onChange;

  const Datepicker2(
      {super.key,
      this.label,
      this.formSave,
      this.formKey,
      this.hint,
      this.titleTextStyle,
      this.enabled,
      this.required,
      this.onChange,
      this.defaultDate,
      this.lastDate,
      this.firstDate});

  @override
  State<Datepicker2> createState() => _Datepicker2State();
}

class _Datepicker2State extends State<Datepicker2> {
  DateTime? fecha;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      initValues();
    }
  }

  void initValues() {
    if (widget.formSave != null && widget.formKey != null) {
      if (widget.formSave![widget.formKey] != null) {
        GenericItemForm itemForm =
            widget.formSave![widget.formKey] as GenericItemForm;
        DateTime? date = itemForm.value as DateTime?;
        setState(() {
          fecha = date;
        });
      }
    }
  }

  String getFormattedDate() {
    if (widget.defaultDate != null) {
      setState(() {
        fecha = widget.defaultDate!;
      });
      return DateFormat('dd/MM/yyyy').format(widget.defaultDate!);
    } else if (widget.formSave != null && widget.formKey != null) {
      if (widget.formSave![widget.formKey] != null) {
        GenericItemForm itemForm =
            widget.formSave![widget.formKey] as GenericItemForm;
        DateTime? date = itemForm.value as DateTime?;
        setState(() {
          fecha = date;
        });
        return date != null ? DateFormat('dd/MM/yyyy').format(date) : "";
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  Future<void> selectFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fecha,
      firstDate: widget.firstDate ?? DateTime(2015, 8),
      lastDate: widget.lastDate ?? DateTime(2101),
    );
    if (picked != null && picked != fecha) {
      setState(() {
        fecha = picked;
      });
    }
    if (fecha != null && widget.formKey != null && widget.formSave != null) {
      widget.formSave![widget.formKey!] =
          GenericItemForm(key: widget.formKey!, value: fecha);
    }
    if (widget.onChange != null) {
      widget.onChange!(fecha);
    }
  }

  List<Widget> generateContent() {
    List<Widget> list = [];

    if (widget.label != null) {
      list.add(Text(
        widget.label ?? "",
        style: widget.titleTextStyle,
      ));
    }

    list.add(InkWell(
      onTap: (widget.enabled == false)
          ? null
          : () async {
              selectFecha(context);
            },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              width: widget.required == true && getFormattedDate().isEmpty
                  ? 2.0
                  : 1.5,
              color: widget.required == true && getFormattedDate().isEmpty
                  ? Colors.red
                  : (widget.enabled == false)
                      ? Colors.grey[350]!
                      : Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 20.0),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Text(
              getFormattedDate(),
              style: TextStyle(
                  color: (widget.enabled == false) ? Colors.black54 : null,
                  fontWeight:
                      (widget.enabled == false) ? FontWeight.w500 : null),
            ),
            const Spacer(),
            Icon(
              Icons.calendar_today,
              color: widget.required == true && getFormattedDate().isEmpty
                  ? Colors.red
                  : (widget.enabled == false)
                      ? Colors.black26
                      : null,
            ),
          ],
        ),
      ),
    ));
    if (widget.required == true && getFormattedDate().isEmpty) {
      list.add(const Padding(
        padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 10.0),
        child: Text(
          "Este campo es obligatorio",
          style: TextStyle(
              fontSize: 11.0, color: Colors.red, fontWeight: FontWeight.w500),
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: generateContent(),
    ));
  }
}
