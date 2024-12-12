import 'package:flutter/material.dart';
import 'package:generic_components/generic_components.dart';
import 'package:listas_app/domain/services/product_service.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:utils/toasted/toasted.dart';

import '../../../data/service/product_service_impl.dart';
import '../../../domain/entities/producto_entity.dart';
import 'package:generic_components/forms/form_dynamic/entities/generic_item_form.dart';

class ComprasPage extends StatefulWidget {
  const ComprasPage({super.key});

  @override
  State<ComprasPage> createState() => _ComprasPageState();
}

class _ComprasPageState extends State<ComprasPage> {
  final ProductService _service = ProductServiceImpl();
  List<Product> _listProduct = [];
  Map<String, GenericItemForm> formSave = {
    // 'productID': GenericItemForm(key: 'productID', value: 1)
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProducts();
  }

  void setListProductsState(List<Product> products) {
    setState(() {
      _listProduct = products;
    });
  }

  Future<void> loadProducts() async {
    onLoading(true);
    final response = await _service.findAll();

    if (response.statusCode == 200) {
      setListProductsState(response.data ?? []);
      onLoading(false);
    } else {
      setListProductsState([]);
      onLoading(false);
    }
  }

  void onLoading(bool? loading) {
    if (loading == null || loading == false) {
      context.loaderOverlay.hide();
    } else {
      context.loaderOverlay.show();
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Compras'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: .0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            child: TextFormField2(
                                label: "Nombre",
                                hint: 'Nombre',
                                required: true,
                                formKey: 'nombre',
                                formSave: formSave),
                          )),
                          const SizedBox(width: 5.0),
                          Expanded(
                              child: Container(
                            child: Select2<Product>(
                                data: _listProduct,
                                formSave: formSave,
                                required: true,
                                search: true,
                                showClear: true,
                                formKey: 'productID',
                                label: 'Productos',
                                hint: 'Productos',
                                keyLabel: 'nombre',
                                keyValue: 'productID'),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            child: Select2<Product>(
                                data: _listProduct,
                                formSave: formSave,
                                required: true,
                                search: true,
                                showClear: true,
                                formKey: 'product2ID',
                                label: 'Productos',
                                hint: 'Productos',
                                keyLabel: 'nombre',
                                keyValue: 'productID'),
                          )),
                          const SizedBox(width: 5.0),
                          Expanded(
                              child: Container(
                            child: TextFormField2(
                                label: "Precio",
                                hint: 'Precio',
                                type: TypeTextField.decimal,
                                required: true,
                                formKey: 'precio',
                                formSave: formSave),
                          ))
                        ],
                      ),
                    ],
                  )),
              const SizedBox(
                height: 2.0,
              ),
              TextButton.icon(
                onPressed: () {
                  var isValidForm = _formKey.currentState!.validate();
                  if (!isValidForm) {
                    Toasted.Error(message: 'Validar campos requeridos').show();
                  } else {
                    print(formSave.toString());
                    Toasted(message: 'Registrando información').show();
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Aceptar'),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white),
              ),
            ],
          ),
        ));
  }
}
