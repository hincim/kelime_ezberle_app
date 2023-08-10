

import 'package:cloud_firestore/cloud_firestore.dart';

class WordFirestore{

  String? id;
  String? eng;
  String? tr;

  WordFirestore({required this.id, required this.eng, required this.tr});

  factory WordFirestore.fromSnapshot(DocumentSnapshot snapshot){

    return WordFirestore(id: snapshot.id,
    eng: snapshot["eng"],
    tr: snapshot["tr"]);
  }
}