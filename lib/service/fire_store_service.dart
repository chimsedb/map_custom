import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FireStoreService extends ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  FirebaseFirestore get fireStore => _fireStore;

  Stream<QuerySnapshot<Map<String, dynamic>>> get streamAreas =>
      _fireStore.collection('areas').snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> get streamZones =>
      _fireStore.collection('zones').snapshots();
}
