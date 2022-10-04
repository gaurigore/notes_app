import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_example/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email ;
  late String password ;
  String verificationId = " ";
  late TextEditingController code;
  bool loading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: const Image(
                        image: AssetImage("assets/images/notes.jpg"),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (val) {
                        email = val;
                      },
                      decoration: const InputDecoration(
                          labelText: "Enter Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (val) {
                        password = val;
                      },
                      decoration: const InputDecoration(
                          labelText: "Enter Password",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),),

                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No user found for that email.")));
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong password provided for that user.")));
                            print('Wrong password provided for that user.');
                          }
                        }
                      },
                      child: const Text("LOG IN")),
                  const SizedBox(
                    height: 15,
                  ),
                 /* const Text(
                    "or connect using",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: ()async {
                            final facebookLoginResult =
                                await FacebookAuth.instance.login();
                            final userData =
                                await FacebookAuth.instance.getUserData();
                            final facebookAuthCredential =
                                FacebookAuthProvider.credential(
                                    facebookLoginResult.accessToken!.token);
                            await FirebaseAuth.instance
                                .signInWithCredential(facebookAuthCredential);


                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          },
                          child: const Text("FACEBOOK")),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            try {
                              FirebaseAuth auth = FirebaseAuth.instance;
                              GoogleSignIn _googleSignIn = GoogleSignIn();
                              GoogleSignInAccount? account = await _googleSignIn.signIn();
                              if (account != null) {
                                final GoogleSignInAuthentication googleSignInAuthentication = await account.authentication;
                                final AuthCredential authCredential = GoogleAuthProvider.credential(
                                    idToken: googleSignInAuthentication.idToken,
                                    accessToken: googleSignInAuthentication.accessToken);

                                // // Getting users credential
                                UserCredential result = await auth.signInWithCredential(authCredential);

                                User user = result.user!;
                                Map<String, dynamic> myUser = {
                                  'name': user.displayName,
                                  'email': user.email,
                                  'phone': user.phoneNumber,
                                  'avatar': user.photoURL
                                };
                                FirebaseDatabase.instance.reference().child('Users')
                                    .push().set(myUser);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()));
                              } else {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  // false = user must tap button, true = tap outside dialog
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content:
                                          const Text('Some Error occurred'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(dialogContext)
                                                .pop(); // Dismiss alert dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: const Text("GOOGLE")),
                    ],
                  ),*/
                 /* const SizedBox(
                    height: 15,
                  ),*/
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text("Don't have an Account?",
                        style: TextStyle(color: Colors.grey)),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: const Text("SignUp"))
                  ]),
                ]),
              ),
            ),
    );
  }

 
  }

