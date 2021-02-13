import 'package:aiguillages/model/duration.dart';
import 'package:aiguillages/service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DayNightDisplay extends StatefulWidget {
  final DatabaseService databaseService = DatabaseService();

  @override
  _DayNightDisplayState createState() => _DayNightDisplayState();
}

class _DayNightDisplayState extends State<DayNightDisplay> {
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _nightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.databaseService.durationStream.listen((Duration duration) {
      _dayController.text = (duration.day / 1000).toString() + ' s';
      _nightController.text = (duration.night / 1000).toString() + ' s';
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dayController.dispose();
    _nightController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: _dayController,
            enabled: false,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.wb_sunny,
                color: Colors.white,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: _nightController,
            enabled: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.nightlight_round,
                color: Colors.white,
              ),
            ),
            keyboardType: TextInputType.number,
          )
        ],
      ),
    );
  }
}
