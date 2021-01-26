import 'package:aiguillages/model/duration.dart';
import 'package:aiguillages/service/bluetooth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService({this.bluetooth});

  final Bluetooth bluetooth;

  // collection reference
  final CollectionReference durationsCollection =
      FirebaseFirestore.instance.collection('durations');

  void start() {
    durationStream.forEach((Duration duration) {
      bluetooth.sendCommand('2_${duration.day}_${duration.night}');
    });
  }

  Future<void> updateDuration(int night, int day) async {
    return await durationsCollection
        .doc('IytuzQtT2Rh5H8DXXqny')
        .update(<String, dynamic>{'night': night, 'day': day});
  }

  Stream<Duration> get durationStream {
    return durationsCollection.doc('IytuzQtT2Rh5H8DXXqny').snapshots().map(
        (DocumentSnapshot doc) => Duration(
            night: doc.data()['night'] as int, day: doc.data()['day'] as int));
  }

  Future<Duration> get duration async {
    final DocumentSnapshot document =
        await durationsCollection.doc('IytuzQtT2Rh5H8DXXqny').get();
    return Duration(
        night: document.data()['night'] as int,
        day: document.data()['day'] as int);
  }
}
