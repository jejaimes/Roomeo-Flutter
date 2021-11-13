import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sprint2/View/Screens/Login/components/body.dart';

class LoginScreen extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}