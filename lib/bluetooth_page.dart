import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothPage extends StatefulWidget {
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];

  final FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  BluetoothDevice _connectedDevice;
  List<BluetoothService> _services;

  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      devices.forEach((BluetoothDevice device) => _addDeviceToList(device));
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (final ScanResult result in results) {
        _addDeviceToList(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.devicesList.length,
      padding: const EdgeInsets.all(50),
      itemBuilder: (BuildContext context, int index) {
        final BluetoothDevice device = widget.devicesList.elementAt(index);
        return Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      device.name == '' ? '(unknown device)' : device.name,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      device.id.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              FlatButton(
                color: Colors.blue,
                child: Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  widget.flutterBlue.stopScan();
                  try {
                    await device.connect();
                  } catch (e) {
                    if (e.code != 'already_connected') {
                      throw e;
                    }
                  } finally {
                    _services = await device.discoverServices();
                  }
                  setState(() {
                    _connectedDevice = device;
                  });
                },
              ),
              FlatButton(
                color: Colors.blue,
                child: Text(
                  'Move',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  _services.forEach((BluetoothService service) => service
                          .characteristics
                          .forEach((BluetoothCharacteristic characteristic) {
                        if (characteristic.properties.write) {
                          characteristic.write(utf8.encode('1'));
                        }
                      }));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addDeviceToList(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }
}
