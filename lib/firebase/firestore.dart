
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelimeezberle/firebase/model/word_firestore.dart';

class FireStoreService{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<WordFirestore>addWordFirebase(String eng, String tr) async {

    var ref = _firestore.collection("Words");

    var documentRef = await ref.add({
        "eng": eng,
        "tr": tr
    });
    
    return WordFirestore(id: documentRef.id, eng: eng, tr: tr);
  }

  Future<WordFirestore>updateWordFirebase(QueryDocumentSnapshot<Object?> id, String eng, String tr) async {

    var ref = _firestore.collection("Words");

    await ref.doc(id.id).update({"eng": eng,"tr":tr});

    return WordFirestore(id: id.id, eng: eng, tr: tr);
  }



  Stream<QuerySnapshot> getWordsFirebase(){

    var ref = _firestore.collection("Words").orderBy("eng").snapshots();

    return ref;
  }

  Future<void> removeWordsFirebase(String docID){

    var ref = _firestore.collection("Words").doc(docID).delete();

    return ref;
  }
}









