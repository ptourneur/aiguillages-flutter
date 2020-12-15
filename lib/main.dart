import 'package:aiguillages/home_page.dart';
import 'package:aiguillages/model/railway.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return ChangeNotifierProvider<Railway>(
      create: (BuildContext context) => Railway(),
      child: MaterialApp(
        title: 'Aiguillage',
        theme: ThemeData(
            backgroundColor: Colors.black,
            primarySwatch: Colors.blue,
            disabledColor: Colors.black12,
            primaryColor: Colors.green[800]),
        home: HomePage(),
      ),
    );
  }
}
