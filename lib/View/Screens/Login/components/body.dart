import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint2/View/Screens/Home/home_screen.dart';
import 'package:sprint2/View/Screens/Register/register_screen.dart';
import 'package:sprint2/View/Screens/Welcome/components/background.dart';
import 'package:sprint2/View/components/IngButton.dart';
import 'package:sprint2/View_Models/user_viewModel.dart';
import 'package:sprint2/constraints.dart';

class Body extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Function to signIn
  Future<void> _signIn(email, password, context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Provider.of<UserViewModel>(context, listen: false).setEmail('');
        print('User is currently signed out!');
      } else {
        Provider.of<UserViewModel>(context, listen: false)
            .setEmail(user.email!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen();
            },
          ),
        );
      }
    });
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
            "Login to Roomeo",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: size.height * 0.05,
            ),
          ),
          SizedBox(height: 50),
          TextFieldContainer(
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
              ),
            ),
          ),
          SizedBox(height: 50),
          TextFieldContainer(
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Passsword",
              ),
            ),
          ),
          SizedBox(height: 50),
          IngButton(
              text: "Log In",
              press: () {
                _signIn(emailController.text, passwordController.text, context);
              }),
          SizedBox(height: 20),
          IngButton(
              text: "Register",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RegisterScreen();
                    },
                  ),
                );
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
