import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';


class Service{
 FirebaseAuth auth=FirebaseAuth.instance;
 late FirebaseFirestore ref=FirebaseFirestore.instance;

  //User? user = auth.currentUser;
 void  saveData(){
    ref.collection("notes");

  }


}