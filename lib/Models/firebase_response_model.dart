import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseResponseModel {
  Map<String, dynamic> data;
  String docId;

  FirebaseResponseModel(this.data, this.docId);
  FirebaseResponseModel.fromResponse(DocumentSnapshot snapshot)
      : data = snapshot.data() as Map<String, dynamic>,
        docId = snapshot.id;
}
