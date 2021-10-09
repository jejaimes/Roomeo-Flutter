import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sprint2/Screens/Welcome/welcome_screen.dart';
import 'package:sprint2/constraints.dart';

import 'Screens/Home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {



  final Future<FirebaseApp> _initialization=Firebase.initializeApp();
  
  @override
  Widget build(BuildContext context) {
    // SOLO EN MODO TEST HACEMOS SIGN OUT ANTES DE EMEPEZAR
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text("Error: " + snapshot.error.toString()),
              ),
          );
        }

        if(snapshot.connectionState==ConnectionState.done){
          return StreamBuilder(
            
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot){
              if(snapshot.connectionState== ConnectionState.active){
                Object? user=snapshot.data;

                if(user ==null){
                  return WelcomeScreen();
                }else{
                  return HomeScreen();
                }
              }else{

                return Scaffold(
                  body: Center(child: Text("Cargando la app"),),
                );
              }

            },
          );
        }

        return Scaffold(
            body: Center(
              child: Text("Connecting to the app") ,
              ),
        );


      },
    );
  }
}

