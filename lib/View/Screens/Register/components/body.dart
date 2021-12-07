import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sprint2/View/Screens/Login/login_screen.dart';
import 'package:sprint2/View/Screens/Welcome/components/background.dart';
import 'package:sprint2/View/components/IngButton.dart';
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
            content: Text("El usuario se registro correctamente\nYa puedes entrar a la aplicación!"),
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
            "Registra te en Roomeo",
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
                hintText: "Nombre",
              ),
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              controller: iDController,
              decoration: InputDecoration(
                hintText: "Id uniandes",
              ),
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Correo uniandes",
              ),
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              controller: facultyController,
              decoration: InputDecoration(
                hintText: "Facultad",
              ),
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              controller: password1Controller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Contraseña",
              ),
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              controller: password2Controller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Repite la contraseña",
              ),
            ),
          ),
          SizedBox(height: 30),
          IngButton(
              text: "Registrarse",
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
                        content: Text("Las contraseñas no coinciden"),
                      );
                    },
                  );
                }
              }),
          SizedBox(height: 20),
          IngButton(
              text: "Atras",
              press: () {
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
