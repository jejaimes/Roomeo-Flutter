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
              decoration: InputDecoration(
                hintText: "Name",
              ),
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Uniandes Id",
              ),
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Faculty",
              ),
            ),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              obscureText: true ,
              decoration: InputDecoration(
                hintText: "Passsword",

              ),),
          ),
          SizedBox(height: 30),
          TextFieldContainer(
            child: TextField(
              obscureText: true ,
              decoration: InputDecoration(
                hintText: "Repeat Passsword",

              ),),
          ),
          SizedBox(height: 30),
          IngButton(
            text: "Register",
            press:(){
              Navigator.pop(context);
              }
            ),
            SizedBox(height: 20),
          IngButton(
            text: "Return",
            press:(){
              Navigator.pop(context);
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

