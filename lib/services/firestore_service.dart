import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/screens/homescreen.dart';
import 'package:flutter/material.dart';

class MyFirestoreService{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference notes = FirebaseFirestore.instance.collection('notes');
   Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance.collection('users').snapshots();
  Stream collectionStream = FirebaseFirestore.instance.collection('notes').snapshots();


  Future<void> addNotes(String title,String des) {

    // Call the user's CollectionReference to add a new user
    return notes
        .add({
      'title': title, // John Doe
      'description': des, // Stokes and Sons

    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateNotes(String title,String des,String docId) {
    print(title);
    print(des);
    return notes
        .doc(docId)
        .update({ 'title': title,
        'description': des, });

  }
  Future<void> deleteNotes(String docId) {
    return notes
        .doc(docId)
        .delete()
        .then((value) => print("notes Deleted"))
        .catchError((error) => print("Failed to delete notes: $error"));
  }

}
