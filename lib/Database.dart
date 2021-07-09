import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService{
  final String? userId;
  final CollectionReference collection = FirebaseFirestore.instance.collection('users');

  DatabaseService(this.userId);
  Future<void> add(userMap) async{
    await collection.doc(userId).set(userMap);
  }
  Future<DocumentSnapshot> getUser() async{
    return await collection.doc(userId).get();
  }
  Future<void> update(userMap) async{
    await collection.doc(userId).get().then((value) {
      value.reference.update(userMap);
    });
  }
}

