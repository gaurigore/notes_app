import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";

import 'homescreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email = "";
  String password = "";
  String confirmPassword = "";
  String phone = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Let's Get Started!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: const InputDecoration(
                      labelText: "Enter Name",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  onChanged: (value) {
                    phone = value;
                  },
                  decoration: const InputDecoration(
                      labelText: "Enter PhoneNumber",
                      prefixIcon: Icon(Icons.call),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: const InputDecoration(
                      labelText: "Enter Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: const InputDecoration(
                      labelText: "Enter Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "ConfirmPassword",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(64)),
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      User user = userCredential.user!;
                      await user.updateDisplayName(name);

                      Map<String, dynamic> myUser = {
                        'name': name,
                        'email': email,
                        'phone': phone,
                      };
                      FirebaseDatabase.instance
                          .reference()
                          .child('Users')
                          .push()
                          .set(myUser);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("The account already exists for that email")));
                        Navigator.pop(context);
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text("SignUp"),
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(120, 40))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
