import 'dart:async';
import 'dart:developer';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:utils/toasted/toasted.dart';

class Bluetooth {
  // Propiedades del singleton

  // List<BluetoothDevice> _devices = [];
  // FlutterBluePlus _flutterBlue = FlutterBluePlus();

  // Instancia única
  static Bluetooth? _instance;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  List<ScanResult> _scanResults = [];
  List<BluetoothDevice> _systemDevices = [];
  bool _isScanning = false;
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;
  List<BluetoothService> _services = [];
  bool _isDiscoveringServices = false;
  bool _isConnecting = false;
  bool _isDisconnecting = false;

  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;
  late StreamSubscription<bool> _isConnectingSubscription;
  late StreamSubscription<bool> _isDisconnectingSubscription;
  late StreamSubscription<int> _mtuSubscription;
  // Constructor privado
  Bluetooth._privateConstructor();

  // Método para inicializar o recuperar la instancia
  static Bluetooth initialize() {
    _instance ??= Bluetooth._privateConstructor();
    return _instance!;
  }

  // Método para acceder a la instancia sin inicializarla
  static Bluetooth get instance {
    if (_instance == null) {
      throw Exception(
          'El singleton no ha sido inicializado. Usa initialize primero.');
    }
    return _instance!;
  }

  Future<bool> isBluetoothActive() async {
    if (await FlutterBluePlus.isSupported == false) {
      log("Bluetooth not supported by this device");
      Toasted.error(message: "Bluetooth not supported by this device").show();

      return false;
    } else {
      return true;
    }
  }

  // 📌 1️⃣ Solicitar permisos en Android e iOS
  Future<bool?> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.location,
      Permission.bluetooth,
    ].request();

    var status = await Permission.bluetooth.isGranted;
    var statusLocation = await Permission.location.isGranted;
    if (status && statusLocation) {
      if (await Permission.bluetooth.request().isGranted &&
          await Permission.bluetoothScan.request().isGranted &&
          await Permission.bluetoothConnect.request().isGranted &&
          await Permission.location.request().isGranted) {
        print("📌 Permisos concedidos");
        Toasted.success(message: "Permisos concedidos").show();
      } else {
        print("❌ Permisos denegados");
        Toasted.error(message: "Permiso  ha sido denegado").show();
        Permission.bluetooth;
        Permission.bluetoothScan;
        Permission.bluetoothConnect;
        Permission.location;
      }
      // } else if (status.isPermanentlyDenied) {
      //   // Si el usuario bloquea permanentemente el permiso, abre la configuración
      //   await openAppSettings();
      // }
      return status==true && statusLocation==true;
    }
  }

  // Ejemplo de método en la clase
  Stream<List<ScanResult>> getScanResultsSubscription(){
    return  FlutterBluePlus.scanResults;
  }
  Stream<bool> getIsScanningSubscription(){
    return  FlutterBluePlus.isScanning;
  }
  void startScan(int? duration){
    FlutterBluePlus.startScan(timeout:Duration(seconds: duration??5));
  }

  // 📌 2️⃣ Escanear dispositivos BLE
  void scanForDevices() {
    _scanResults.clear();
    FlutterBluePlus.startScan(timeout:const  Duration(seconds: 5));
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
    }, onError: (e) {
      Toasted.error(message: e.toString()).show();
    });
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
    });
  }

  List<ScanResult> getDevices() {
    return _scanResults;
  }

  bool getIsScanning() {
    return _isScanning;
  }

/** para saber si esta activo el scanner */
  bool isScanningNow() {
    return FlutterBluePlus.isScanningNow;
  }

  Future onScanPressed() async {
    try {
      // `withServices` is required on iOS for privacy purposes, ignored on android.
      var withServices = [Guid("180f")]; // Battery Level Service
      _systemDevices = await FlutterBluePlus.systemDevices(withServices);
    } catch (e) {
      Toasted.error(message: "System Devices Error:$e").show();
      log(e.toString());
    }
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      Toasted.error(message: "Start Scan Error:$e").show();
      log(e.toString());
    }
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      Toasted.error(message: "Stop Scan Error:$e").show();
      log(e.toString());
    }
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }

    return Future.delayed(const Duration(milliseconds: 500));
  }

  // 📌 3️⃣ Conectar a un dispositivo BLE
  void connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      log("✅ Conectado a ${device.name} (${device.id})");
    } catch (e) {
      Toasted.error(message: "error al conectar con el dispositivo:$e").show();
      log(e.toString());
    }
  }

  void close() {
    _isScanning = false;
    _scanResults = [];
    _systemDevices = [];
    _isScanningSubscription.cancel();
    _scanResultsSubscription.cancel();
  }
}
