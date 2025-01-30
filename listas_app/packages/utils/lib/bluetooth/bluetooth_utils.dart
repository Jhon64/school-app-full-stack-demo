import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothUtils {
  /// Verifica si el Bluetooth y la ubicación están encendidos y,
  /// además, solicita los permisos necesarios para escanear dispositivos BLE.
  /// Retorna `true` si todo está correcto, `false` si faltan permisos o
  /// si la ubicación/Bluetooth no están habilitados.
  static Future<bool> checkAndRequestPermissions(BuildContext context) async {
    // 1. Verificar si la ubicación está activada
    final ServiceStatus locationServiceStatus =
        await Permission.location.serviceStatus;
    bool locationEnabled = locationServiceStatus == ServiceStatus.enabled;

    // 2. Verificar si el Bluetooth está encendido
    final bluetoothState = FlutterBluePlus.adapterState.first;
    bool bluetoothEnabled = await bluetoothState == BluetoothAdapterState.on;

    if (!locationEnabled) {
      // Opcional: Avisar al usuario
      await _showAlertDialog(
        context,
        title: 'Ubicación desactivada',
        content:
            'Por favor, activa la ubicación para escanear dispositivos BLE.',
      );
      // Aunque sigas pidiendo permisos, no funcionará el escaneo BLE sin ubicación activa
    }

    if (!bluetoothEnabled) {
      // Opcional: Avisar al usuario
      await _showAlertDialog(
        context,
        title: 'Bluetooth desactivado',
        content: 'Por favor, activa el Bluetooth para poder escanear.',
      );
      // Aunque sigas pidiendo permisos, no funcionará el escaneo BLE sin Bluetooth activo
    }

    // 3. Solicitar permisos a través de permission_handler
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    // Verifica si todos los permisos fueron concedidos
    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      // Si algún permiso fue denegado, notifica al usuario
      await _showAlertDialog(
        context,
        title: 'Permisos requeridos',
        content:
            'Por favor, concede todos los permisos para poder escanear dispositivos BLE.',
      );
      // El usuario podría abrir configuraciones, etc.
      // openAppSettings(); // Si quieres llevarlo a la config
      return false;
    }

    // Verifica nuevamente si al menos hay ubicación y bluetooth habilitados
    if (!locationEnabled || !bluetoothEnabled) {
      return false;
    }

    return true;
  }

  /// Muestra un cuadro de diálogo con el listado de dispositivos BLE cercanos.
  /// Permite seleccionar un dispositivo y se realiza la conexión.
  static Future<void> showBluetoothDevicesDialog(BuildContext context) async {
    // Paso 1: Verificar permisos, ubicación y Bluetooth
    bool granted = await checkAndRequestPermissions(context);
    if (!granted) return;

    bool isScanning = false;
    StreamSubscription<List<ScanResult>>? scanSubscription;

    // Lista de resultados de dispositivos escaneados
    List<ScanResult> scanResults = [];

    // Función para iniciar escaneo
    Future<void> startScan() async {
      // Limpia resultados previos
      scanResults.clear();

      // Inicia escaneo con timeout de 12s
      isScanning = true;
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 12));
      log('Escaneando dispositivos BLE...');

      // Suscríbete a los resultados
      scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult r in results) {
          final device = r.device;
          log('Encontrado dispositivo: ${device.remoteId} - ${device.name}');
          // Añade el dispositivo si no está ya en la lista
          final index = scanResults.indexWhere(
            (element) => element.device.remoteId == r.device.remoteId,
          );
          if (index == -1) {
            scanResults.add(r);
          } else {
            // Actualiza la entrada existente
            scanResults[index] = r;
          }
        }
      });

      // Al finalizar el escaneo
      FlutterBluePlus.isScanning.listen((scanning) {
        if (!scanning) {
          isScanning = false;
        }
      });
    }

    // Iniciamos el escaneo
    await startScan();

    // Mostrar el diálogo con la lista de dispositivos
    await showDialog<BluetoothDevice>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Dispositivos BLE cercanos'),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: scanResults.length,
                        itemBuilder: (context, index) {
                          final r = scanResults[index];
                          final device = r.device;
                          return ListTile(
                            title: Text(device.name.isNotEmpty
                                ? device.name
                                : 'Dispositivo sin nombre'),
                            subtitle: Text(device.remoteId.toString()),
                            onTap: () async {
                              // Detén el escaneo antes de conectar
                              await _stopScan(scanSubscription);

                              Navigator.of(context).pop(); // Cierra el diálogo

                              // Conectar al dispositivo
                              await connectToDevice(context, device);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isScanning
                      ? null
                      : () async {
                          setState(() {
                            isScanning = true;
                          });
                          await startScan();
                          setState(() {});
                        },
                  child: Text(isScanning ? 'Buscando...' : 'Buscar de nuevo'),
                ),
                TextButton(
                  onPressed: () async {
                    await _stopScan(scanSubscription);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      },
    );

    // Detener el escaneo si sigue en proceso
    if (isScanning) {
      await _stopScan(scanSubscription);
    }
  }

  /// Conecta a un dispositivo BLE específico y, si encuentra el servicio/característica,
  /// lee el valor (o se suscribe) y muestra el peso en un diálogo.
  static Future<void> connectToDevice(
      BuildContext context, BluetoothDevice device) async {
    try {
      // Conectar
      await device.connect(autoConnect: false);
      log('Conectado a: ${device.remoteId}');

      // Descubrir servicios
      List<BluetoothService> services = await device.discoverServices();

      // Ajusta estos UUIDs al de tu dispositivo real:
      final serviceUuid = Guid('MY_SERVICE_UUID');
      final characteristicUuid = Guid('MY_CHARACTERISTIC_UUID');

      BluetoothCharacteristic? targetCharacteristic;

      for (BluetoothService service in services) {
        if (service.uuid == serviceUuid) {
          for (BluetoothCharacteristic characteristic
              in service.characteristics) {
            if (characteristic.uuid == characteristicUuid) {
              targetCharacteristic = characteristic;
              break;
            }
          }
        }
      }

      if (targetCharacteristic == null) {
        // Error: característica no encontrada
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se encontró la característica de peso.'),
          ),
        );
        await device.disconnect();
        return;
      }

      // Si la característica soporta Notify, nos suscribimos para leer continuamente
      if (targetCharacteristic.properties.notify) {
        await targetCharacteristic.setNotifyValue(true);
        targetCharacteristic.value.listen((value) {
          // `value` es List<int>. Convierte a tu formato (ASCII, binario, etc.)
          String receivedString = String.fromCharCodes(value);
          double? weight = double.tryParse(receivedString);
          if (weight != null) {
            showWeightDialog(context, weight);
          }
        });
      } else if (targetCharacteristic.properties.read) {
        // Si solo soporta leer una vez
        final value = await targetCharacteristic.read();
        String receivedString = String.fromCharCodes(value);
        double? weight = double.tryParse(receivedString);
        if (weight != null) {
          showWeightDialog(context, weight);
        }
      }
    } catch (e) {
      log('Error al conectar o leer el dispositivo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al conectar o leer dispositivo.')),
      );
    }
  }

  /// Muestra el valor de `weight` en un AlertDialog.
  static void showWeightDialog(BuildContext context, double weight) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Peso'),
          content: Text('El peso es: $weight kg'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Detiene el escaneo y cancela la suscripción si está activa.
  static Future<void> _stopScan(
      StreamSubscription<List<ScanResult>>? subscription) async {
    try {
      await FlutterBluePlus.stopScan();
      await subscription?.cancel();
    } catch (e) {
      log('Error al detener el escaneo: $e');
    }
  }

  /// Helper para mostrar un AlertDialog genérico.
  static Future<void> _showAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    if (context.mounted) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
