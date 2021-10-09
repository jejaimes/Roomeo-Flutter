import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sprint2/Screens/Home/home_screen.dart';
import 'package:sprint2/Screens/Login/login_screen.dart';
import 'package:sprint2/Screens/Welcome/components/background.dart';
import 'package:sprint2/components/IngButton.dart';
import 'package:sprint2/constraints.dart';

class Body extends StatelessWidget {
  final emailController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();
  final facultyController = TextEditingController();
  final nameController = TextEditingController();
  final iDController = TextEditingController();

  //Function to register users
  Future<void> _register(email, password, name, faculty, id, context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the user has entered by using the
            // TextEditingController.
            content: Text("The user registered correctly!\nPlease log in now"),
          );
        },
      );
      await Future.delayed(const Duration(seconds: 2), () {});
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      users
          .add({
            'Faculty': faculty,
            'LastHW': DateTime.now().millisecondsSinceEpoch,
            'Login': email,
            'Name': name,
            'UniandesID': id,
          })
          .then((value) => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                )
              })
          .catchError((error) => print("Failed to add user: $error"));
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the user has entered by using the
            // TextEditingController.
            content: Text(e.toString()),
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // Retrieve the text the user has entered by using the
            // TextEditingController.
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Text(
            "Register to Roomeo",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: size.height * 0.05,
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Name",
              ),
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              controller: iDController,
              decoration: InputDecoration(
                hintText: "Uniandes Id",
              ),
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Uniandes email",
              ),
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              controller: facultyController,
              decoration: InputDecoration(
                hintText: "Faculty",
              ),
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              controller: password1Controller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Passsword",
              ),
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              controller: password2Controller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Repeat Passsword",
              ),
            ),
          ),
          SizedBox(height: 30),
          IngButton(
              text: "Register",
              press: () {
                if (password1Controller.text == password2Controller.text) {
                  _register(
                      emailController.text,
                      password1Controller.text,
                      nameController.text,
                      facultyController.text,
                      iDController.text,
                      context);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        // Retrieve the text the user has entered by using the
                        // TextEditingController.
                        content: Text("The passwords do not match"),
                      );
                    },
                  );
                }
              }),
          SizedBox(height: 20),
          IngButton(text: "Return", press: () {
            Navigator.pop(context);
          }),
        ],
      ),
    ));
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
