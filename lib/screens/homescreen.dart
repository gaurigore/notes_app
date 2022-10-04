import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_example/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'loginscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _descriptionController =
      TextEditingController();
  late DatabaseReference _ref;
  final MyFirestoreService _firestoreService = MyFirestoreService();
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('notes').snapshots();

  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      _ref =
          FirebaseDatabase.instance.reference().child('notes').child(user.uid);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please Login first!")));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Notes"),
        actions: [
          IconButton(
            onPressed: () async {
              GoogleSignIn _googleSignIn = GoogleSignIn();
              _googleSignIn.signOut();
              FacebookAuth.instance.logOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            icon: const Icon(Icons.logout),
            color: Colors.black,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Card(
                    child: ListTile(
                        title: Text(data['title']),
                        subtitle: Text(data['description']),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  addNotes(document: document);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _firestoreService.deleteNotes(document.id);
                                },
                              ),
                            ],
                          ),
                        )),
                  );
                }).toList(),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNotes();
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  void addNotes({DocumentSnapshot? document}) {
    if (document != null) {
      print("in update");
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      if (data != null) {
        _titleController.text = data['title'];
        _descriptionController.text = data['description'];
      }
    }
    print("ready to add new data");
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(document != null ? "Edit Note" : 'Add Note'),
          content: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                    hintText: "Enter Title",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    hintText: "Enter Description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)))),
                controller: _descriptionController,
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                  child: Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (document != null) {
                          _firestoreService.updateNotes(_titleController.text,
                              _descriptionController.text, document.id);
                          _titleController.clear();
                          _descriptionController.clear();
                          print("we are in update method");
                        } else {
                          _firestoreService.addNotes(_titleController.text,
                              _descriptionController.text);
                          print("we are in add method");
                          _titleController.clear();
                          _descriptionController.clear();
                        }

                        // dataSnapshot != null ? saveData(dataSnapshot: dataSnapshot) : saveData();

                        Navigator.pop(context);
                      },
                      child: const Text("SUBMIT")),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _titleController.clear();
                        _descriptionController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text("CANCEL"))
                ],
              )),
            ],
          ),
        );
      },
    );
  }
}
