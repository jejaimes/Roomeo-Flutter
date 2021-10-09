import 'package:flutter/material.dart';
import 'package:sprint2/Screens/Login/login_screen.dart';
import 'package:sprint2/Screens/Welcome/components/background.dart';
import 'package:sprint2/components/IngButton.dart';
import 'package:sprint2/constraints.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
        child:  SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
          Positioned(
            child: Image.asset("assets/images/logo.png"),
          ),
          SizedBox(height: 20),
          Text(
            "¡Bienvenido!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.05,
            ),
          ),
          SizedBox(height: 50),
          IngButton(
            text: "Ingresar",
            press:(){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context){
                    return LoginScreen();
                    },
                  ),
                );
              }
            ),
          
              ],
            ),
        ));
  }
}

