import 'dart:async';

import 'package:aiguillages/enums/custom_bluetooth_state.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Bluetooth {
  final FlutterBlue bluetoothInstance = FlutterBlue.instance;

  BluetoothDevice device;
  final StreamController<CustomBluetoothState> _bluetoothStateController =
      StreamController<CustomBluetoothState>();

  static const String DEVICE_ID = 'A4:DA:32:52:01:03';
  static const String SERVICE_UUID = '0000ffe0-0000-1000-8000-00805f9b34fb';
  static const String PROPERTY_UUID = '0000ffe1-0000-1000-8000-00805f9b34fb';

  Stream<CustomBluetoothState> get stateStream =>
      _bluetoothStateController.stream;

  Future<void> connectArduino(Function updateRailway) async {
    bluetoothInstance.state.listen((BluetoothState state) async {
      if (state == BluetoothState.off) {
        _bluetoothStateController.sink.add(CustomBluetoothState.bluetooth_off);
      }
      if (state == BluetoothState.on && device == null) {
        bluetoothInstance.startScan();
        _bluetoothStateController.sink.add(CustomBluetoothState.searching);
        bluetoothInstance.scanResults.listen(
            (List<ScanResult> scanResults) async {
          for (final ScanResult scanResult in scanResults) {
            if (scanResult.device.id.id == DEVICE_ID) {
              try {
                await scanResult.device.connect();
                device = scanResult.device;
                _bluetoothStateController.sink
                    .add(CustomBluetoothState.device_connected);
                print('Connected to ' + scanResult.device.name);

                for (final BluetoothService service
                    in await device.discoverServices()) {
                  for (final BluetoothCharacteristic characteristic
                      in service.characteristics) {
                    if (characteristic.uuid.toString() == PROPERTY_UUID) {
                      characteristic
                          .setNotifyValue(!characteristic.isNotifying);
                      characteristic.value.listen((List<int> dataReceived) {
                        print('received ' + dataReceived.toString());
                        updateRailway(dataReceived);
                      });
                    }
                  }
                }
                device.state.listen((BluetoothDeviceState event) {
                  if (event == BluetoothDeviceState.connected) {
                    _bluetoothStateController.sink
                        .add(CustomBluetoothState.device_connected);
                    sendCommand('199');
                  } else if (event == BluetoothDeviceState.disconnected) {
                    _bluetoothStateController.sink
                        .add(CustomBluetoothState.device_disconnected);
                  }
                });
              } catch (e) {
                if (e.code != 'already_connected') {
                  rethrow;
                }
                rethrow;
              }
            }
          }
        }, onDone: () => bluetoothInstance.stopScan());
      }
    });
  }

  Future<void> sendCommand(String command) async {
    for (final BluetoothService service in await device.discoverServices()) {
      if (service.uuid.toString() == SERVICE_UUID) {
        for (final BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid.toString() == PROPERTY_UUID) {
            print(command);
            characteristic.write(<int>[int.parse(command)]);
          }
        }
      }
    }
  }
}
