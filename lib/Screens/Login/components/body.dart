import 'package:flutter/material.dart';
import 'package:sprint2/Screens/Login/login_screen.dart';
import 'package:sprint2/Screens/Register/register_screen.dart';
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
              decoration: InputDecoration(
                hintText: "Email",
              ),
            ),
          ),
          SizedBox(height: 50),
          TextFieldContainer(
            child: TextField(
              obscureText: true ,
              decoration: InputDecoration(
                hintText: "Passsword",

              ),),
          ),
          SizedBox(height: 50),
          IngButton(
            text: "Log In",
            press:(){}
            ),
            SizedBox(height: 20),
          IngButton(
            text: "Register",
            press:(){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context){
                    return RegisterScreen();
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

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container( 
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width*0.8,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}

