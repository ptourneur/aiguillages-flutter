import 'package:aiguillages/home_page.dart';
import 'package:aiguillages/model/railway.dart';
import 'package:firebase_core/firebase_core.dart';
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

    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return ChangeNotifierProvider<Railway>(
      create: (BuildContext context) => Railway(),
      child: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Erreur de connexion à firebase');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Aiguillage',
              theme: ThemeData(
                  backgroundColor: Colors.black,
                  primarySwatch: Colors.blue,
                  disabledColor: Colors.black12,
                  primaryColor: Colors.white),
              home: HomePage(),
            );
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
