import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint2/View/Screens/Welcome/welcome_screen.dart';
import 'package:sprint2/View_Models/qr_viewModel.dart';
import 'package:sprint2/View_Models/viewPerBuilding_viewModel.dart';
import 'package:sprint2/constraints.dart';

import 'View/Screens/Home/home_screen.dart';
import 'View_Models/building_viewModel.dart';
import 'View_Models/reserve_viewModel.dart';
import 'View_Models/user_viewModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: BuildingViewModel()),
        ChangeNotifierProvider.value(value: QRViewModel()),
        ChangeNotifierProvider.value(value: ViewPerBuildingViewModel()),
        ChangeNotifierProvider.value(value: ReserveViewModel()),
        ChangeNotifierProvider.value(value: UserViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        theme: ThemeData(
            primaryColor: kPrimaryColor, scaffoldBackgroundColor: Colors.white),
        home: LandingPage(),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // SOLO EN MODO TEST HACEMOS SIGN OUT ANTES DE EMEPEZAR
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: " + snapshot.error.toString()),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                Object? user = snapshot.data;

                if (user == null) {
                  return WelcomeScreen();
                } else {
                  return HomeScreen();
                }
              } else {
                return Scaffold(
                    body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cargando la app...'),
                    Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryDarkColor,
                      ),
                    )
                  ],
                ));
              }
            },
          );
        }

        return Scaffold(
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Conectandose a la app...'),
              Center(
                child: CircularProgressIndicator(
                  color: kPrimaryDarkColor,
                ),
              )
            ],
          )),
        );
      },
    );
  }
}
