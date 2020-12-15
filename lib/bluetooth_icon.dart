import 'package:aiguillages/enums/custom_bluetooth_state.dart';
import 'package:aiguillages/service/bluetooth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BluetoothIcon extends StatefulWidget {
  const BluetoothIcon(this.bluetooth, {Key key}) : super(key: key);

  final Bluetooth bluetooth;

  @override
  _BluetoothIconState createState() => _BluetoothIconState();
}

class _BluetoothIconState extends State<BluetoothIcon> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 50,
      decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(50), topRight: Radius.circular(50))),
      child: getInsideWidget(context),
    );
  }

  Widget getInsideWidget(BuildContext context) {
    const Widget progressIndicator = Center(
      child: SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            strokeWidth: 4,
          )),
    );

    return StreamBuilder<CustomBluetoothState>(
      stream: widget.bluetooth.stateStream,
      initialData: CustomBluetoothState.bluetooth_off,
      builder: (BuildContext c, AsyncSnapshot<CustomBluetoothState> snapshot) {
        switch (snapshot.data) {
          case CustomBluetoothState.bluetooth_off:
            return Icon(
              Icons.bluetooth_disabled,
              color: Colors.red[800],
              size: 25,
            );
            break;
          case CustomBluetoothState.device_connected:
            return Icon(
              Icons.bluetooth_connected,
              color: Colors.green[800],
              size: 25,
            );
            break;
          case CustomBluetoothState.searching:
          case CustomBluetoothState.device_disconnected:
            return progressIndicator;
            break;
        }
        return null;
      },
    );
  }
}
