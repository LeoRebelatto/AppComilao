import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ModeloBase {
  ModeloBase();

  ModeloBase.fromMap(DocumentSnapshot document);
  toMap();
  String documentId();
}