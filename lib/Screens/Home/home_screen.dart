import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sprint2/Screens/Login/components/body.dart';

class HomeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Entraste este página es home!")),
    );
  }
}