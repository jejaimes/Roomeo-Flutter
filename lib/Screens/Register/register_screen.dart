import 'package:flutter/material.dart';
import 'package:sprint2/Screens/Register/components/body.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen
({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}