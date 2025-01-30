import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:listas_app/data/service/product_service_impl.dart';
import 'package:listas_app/domain/entities/producto_entity.dart';
import 'package:listas_app/domain/services/product_service.dart';
import 'package:listas_app/ui/screens/products/widgets/list_products.dart';
import 'package:listas_app/ui/widgets/confirmation_dialog.dart';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:utils/utils.dart';
import 'package:generic_components/forms/form_dynamic/entities/generic_item_form.dart';
import 'package:generic_components/forms/form_dynamic/dynamic_form.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  double _size = 1.0;
  final bool _loadingState = false;
  List<Product> _listProduct = [];
  List<BluetoothDevice>  devices = [];
  final Bluetooth _bluetooth = Bluetooth.initialize();
  final ProductService _service = ProductServiceImpl();
  late Product form = Product();
  late Map<String, GenericItemForm> form2 = {};

  @override
  void initState() {
    super.initState();
    // loadProducts();
    configItemsForm();

    // initializeForm(null);
  }
  void _connectToDevice(BluetoothDevice device) async {
    try{
    await device.connect();
    Toasted.success(message:"✅ Conectado a ${device.name} (${device.remoteId})").show();

    }catch(e){
    Toasted.error(message:"✅ Error al conectar con este dispoitivo ${e.toString()}").show();

    }
  }

  void initConfigBluetooth() async {
    setState(() {
      devices=[];
    });
    bool? permiso = await _bluetooth.requestPermissions();
    if (permiso== true) {
      Toasted.info(message: "Bluetooth conectado").show();
      _bluetooth.startScan(null);
      _bluetooth.getScanResultsSubscription().listen((scanResults){
        for (ScanResult r in scanResults) {
          if (!devices.contains(r.device)) {
            log("dispositivo: ${r.device.advName}" );
            setState(() {
              devices.add(r.device);
            });
          }
        }
      });
      _bluetooth.getIsScanningSubscription().listen((state){
        log('el estado del scanneo ${state.toString()}');
      });
      // var devices = _bluetooth.getDevices();
      // var isScanning = _bluetooth.getIsScanning();
      // log(devices.length.toString());
      // log(isScanning.toString());
    } else {
      Toasted.error(message: "activar Bluetooth ").show();
    }
  }

  Map<String, GenericItemFormOptions> configItemsForm() {
    Map<String, GenericItemFormOptions> config = {
      "estado": GenericItemFormOptions(
          isRequired: false, typeData: TypeData.int, hidden: true),
      "productID": GenericItemFormOptions(
          isRequired: false, typeData: TypeData.int, hidden: true),
      "imageURL": GenericItemFormOptions(
          isRequired: false, typeData: TypeData.string, hidden: true),
      "nombre": GenericItemFormOptions(
          isRequired: true,
          typeData: TypeData.string,
          label: 'Nombre',
          hintText: 'Ingrese Nombre'),
      "descripcion": GenericItemFormOptions(
          // isRequired: true,
          typeData: TypeData.string,
          label: 'Descripción',
          hintText: 'Ingrese Descripción'),
      "precio": GenericItemFormOptions(
          hintText: 'Ingrese Precio',
          isRequired: true,
          typeData: TypeData.decimal,
          label: 'Precio'),
    };
    return config;
  }

  void resetForm() {
    setState(() {
      form = Product();
    });
  }

  void setLoadingState(bool? state) {
    if (state != null) {
      setState(() {
        _loadingState != state;
      });
    } else {
      setState(() {
        _loadingState != _loadingState;
      });
    }
  }

  void setListProductsState(List<Product> products) {
    setState(() {
      _listProduct = products;
    });
  }

  void onLoading(bool? loading) {
    if (loading == null || loading == false) {
      context.loaderOverlay.hide();
    } else {
      context.loaderOverlay.show();
    }
  }

  // Leer (Read): Obtener elementos de la API
  Future<void> loadProducts() async {
    onLoading(true);
    final response = await _service.findAll();

    if (response.statusCode == 200) {
      setLoadingState(false);
      setListProductsState(response.data ?? []);
      onLoading(false);
    } else {
      setLoadingState(false);
      setListProductsState([]);
      onLoading(false);
    }
  }

  void handleCancelModal(BuildContext context) {
    Toasted(message: "Cerrando modal").show();
    resetForm();
    Navigator.of(context).pop();
  }

  Widget loadListViewProducts() {
    return ListProducts(
        products: _listProduct,
        handleOnDelete: handleDelete,
        handleOnEdit: handleEdit);
  }

  void getFormValues(Map<String, GenericItemForm> formProduct) {
    Map<String, dynamic> parseProduct = {};
    for (GenericItemForm item in formProduct.values) {
      parseProduct[item.key] = item.value;
    }
    var productForm = Product.fromJson(parseProduct);
    setState(() {
      form = productForm;
    });
  }

  Future<void> saveProduct(BuildContext _context) async {
    if (form.toJson().isEmpty) {
      Toasted(message: "No hay datos para enviar").show();
      return;
    }
    onLoading(true);
    final response = await (form.productID != null
        ? _service.update(form)
        : _service.save(form));

    if (response.statusCode == 200) {
      onLoading(false);
      resetForm();
      await loadProducts();
      if (!mounted) {
        return;
      } else {
        Navigator.of(context).pop();
      }
    } else {
      Toasted(message: response.message ?? '').show();
      onLoading(false);
    }
  }

  void handleEdit(Product prod, int? index) {
    print('obteniendo informacion: ${prod.toString()}');
    _showDialog(prod, index);
  }

  void handleDelete(Product prod, int index) async {
    print('Eliminado registro ${prod.toString()}');

    if (prod.toJson().isEmpty) {
      Toasted(message: "No hay datos para enviar").show();
      return;
    }
    // ConfirmationDialog(title: 'Seguro de eliminar?').show(context);

    onLoading(true);
    final response = await _service.delete(prod.productID!);
    if (response.statusCode == 200) {
      resetForm();
      onLoading(false);
      await loadProducts();
      // if (!mounted) {
      //   return;
      // } else {
      //   // Navigator.of(context).pop();
      // }
    } else {
      Toasted(message: response.message ?? '').show();
      onLoading(false);
    }
  }

  void _showDialog(Product? prod, int? index) {
    // var parseForm = parseClassToForm(prod);
    showDialog(
      context: context,
      barrierDismissible: false,
      // Desactiva el cierre al tocar fuera
      builder: (BuildContext context) => DynamicForm<Product>(
        onCancel: handleCancelModal,
        validatePropsClass: false,
        onSaveFuture: saveProduct,
        title: prod != null ? "Actualizar Producto" : "Nuevo Producto",
        getForm: getFormValues,
        // form: prod??form,
        classBase: prod ?? form,
        configItemsForm: configItemsForm(),
        // form: prod,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Productos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => initConfigBluetooth(),
                label: const Text("Conectar Bluetooth"),
                icon: const Icon(Icons.bluetooth),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              ElevatedButton.icon(
                onPressed: () => _showDialog(null, null),
                label: const Text("Nuevo"),
                icon: const Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
              )
            ],
          ),
          const SizedBox(height: 2),
          // Expanded(child: loadListViewProducts())
          Expanded(child: ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(devices[index].name.isNotEmpty
                    ? devices[index].name
                    : "Dispositivo Desconocido"),
                subtitle: Text(devices[index].id.toString()),
                onTap: () => _connectToDevice(devices[index]),
              );
            },
          ))
          // FutureBuilder(
          //     future: ProductServiceImpl().findAll(),
          //     builder: builderFetchProductsList)
          // Lista
        ],
      ),
    );
  }
}
