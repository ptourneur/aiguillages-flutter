import 'package:aiguillages/bluetooth_icon.dart';
import 'package:aiguillages/day_night_display.dart';
import 'package:aiguillages/model/railway.dart';
import 'package:aiguillages/railway_painter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchable/touchable.dart';

class HomePage extends StatelessWidget {
  final ValueNotifier<Offset> notifier = ValueNotifier<Offset>(Offset.zero);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: <Widget>[
          Consumer<Railway>(
            builder: (BuildContext context, Railway railway, Widget child) =>
                CanvasTouchDetector(
              builder: (BuildContext context) {
                return CustomPaint(
                  painter: RailwayPainter(context),
                  size: MediaQuery.of(context).size,
                );
              },
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.20,
              left: 0,
              child: BluetoothIcon(Provider.of<Railway>(context).bluetooth)),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.01,
            right: MediaQuery.of(context).size.height * 0.10,
            child: DayNightDisplay(),
          )
        ],
      ),
    );
  }
}
