import 'package:aiguillages/model/duration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService({this.uid});

  final String uid;

  // collection reference
  final CollectionReference durationsCollection =
      FirebaseFirestore.instance.collection('durations');

  Future<void> updateDuration(int night, int day) async {
    return await durationsCollection
        .doc('IytuzQtT2Rh5H8DXXqny')
        .update(<String, dynamic>{'night': night, 'day': day});
  }

  Future<Duration> getDuration() async {
    final DocumentSnapshot doc =
        await durationsCollection.doc('IytuzQtT2Rh5H8DXXqny').get();
    return Duration(
        night: doc.data()['night'] as int, day: doc.data()['day'] as int);
  }
}
