import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sprint2/View/Screens/ReserveClassroom/reserveClassroom.dart';
import 'package:sprint2/View/Screens/ScanQR/scanQRView.dart';
import 'package:sprint2/View/components/IngButton.dart';
import 'package:sprint2/View/components/BuildingButtons.dart';
import 'package:sprint2/View_Models/building_viewModel.dart';
import 'package:sprint2/View_Models/user_viewModel.dart';
import 'package:sprint2/constraints.dart';
import 'package:intl/intl.dart';
import 'package:sprint2/main.dart';

import 'components/careInfoView.dart';

    Duration timeLastHW = new Duration();

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Pide la lista del ViewModel de Buildings.
    Provider.of<BuildingViewModel>(context, listen: false).fetchBuildingData();

    return Scaffold(
        body: Center(
      child: MyStatefulWidget(),
    ));
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions = <Widget>[
    Buildings(optionStyle: optionStyle),
    HandWash(optionStyle: optionStyle),
    ReserveClassroomWidget(),
    ScanQRView(),
    careInfoView()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: const Text('Roomeo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Seguro que quieres salir de la aplicación?'),
                      content: Text('No quisieramos que te fueras...'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            NavigatorState navigatorState =
                                Navigator.of(this.context);
                            while (navigatorState.canPop()) {
                              navigatorState.pop();
                            }

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return LandingPage();
                              }),
                            );
                          },
                          child: Text('Salir'),
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xFF11929C),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.clean_hands),
            label: 'Handwash',
            backgroundColor: Color(0xFF11929C),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Group',
            backgroundColor: Color(0xFF11929C),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'ScanQR',
            backgroundColor: Color(0xFF11929C),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.coronavirus),
            label: 'Coronavirus',
            backgroundColor: Color(0xFF11929C),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Buildings extends StatefulWidget {
  final optionStyle;

  const Buildings({Key? key, this.optionStyle}) : super(key: key);

  @override
  _BuildingsState createState() => _BuildingsState();
}

class _BuildingsState extends State<Buildings> {
  ConnectivityResult _connectionStatus = ConnectivityResult.wifi;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User? currentUser = FirebaseAuth.instance.currentUser;
  int tiempo = DateTime.now().millisecondsSinceEpoch;
  int lastHW = 0;
  

  @override
  Widget build(BuildContext context) {

    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
      lastHW = int.parse(documentSnapshot.data()!["LastHW"]);
      lastHW = tiempo - lastHW;
      timeLastHW = new Duration(
          days: 0, hours: 0, minutes: 0, seconds: 0, milliseconds: lastHW);
    });

    
    DateTime hoy = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(hoy);
    

    return Column(children: <Widget>[
      Expanded(
          flex: 2,
          child: Container(
            child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: "La fecha de hoy es: "+ formattedDate,
                  fillColor: kPrimaryLightColor,
                  labelStyle: TextStyle(color: Colors.black),
                )),
          )),
      BuidlingButtons(),
    ]);
      
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        !.addPostFrameCallback((_) => Provider.of<UserViewModel>(context, listen: false)
        .setEmail(currentUser!.email!));
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    Size size= MediaQuery.of(context).size;
    if (result == ConnectivityResult.none &&
        _connectionStatus != ConnectivityResult.none) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sin conexión'),
              content: Container(
                height: size.height * 0.25,
                width: size.width*0.25,
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(),
                      child: Icon(
                        Icons.cloud_off_rounded,
                        color: kPrimaryColor,
                      ),
                    ),
                    Text(
                      'Se acaba de perder la conexión, la información que se presenta podría estar actualizada. Cuando se restablezca la conexión se actualizará la información.',
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Aceptar'))
              ],
            );
          });
    }
    setState(() {
      _connectionStatus = result;
    });
  }
}

// ignore: must_be_immutable
class HandWash extends StatelessWidget {
  HandWash({
    Key? key,
    required this.optionStyle,
  }) : super(key: key);

  final TextStyle optionStyle;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  User? currentUser = FirebaseAuth.instance.currentUser;
  int tiempo = DateTime.now().millisecondsSinceEpoch;

  Future<void> updateUser() {
    return users
        .doc(currentUser!.email)
        .update({'LastHW': tiempo.toString()})
        .then((value) => {print("Se actualizo la base de datos")})
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    Duration durationMin = new Duration(
        days: 0, hours: 0, minutes: 0, seconds: 10, milliseconds: 0);
    if (timeLastHW.compareTo(durationMin) < 0) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                "You washed your hands recently!",
                style: optionStyle,
              ),
            ),
            IngButton(text: "Update", press: () {}),
          ]);
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Tiempo desde el último lavado de manos:",
              style: optionStyle,
            ),
            Text(
              timeLastHW.toString().split('.')[0],
              style: optionStyle,
            ),
            IngButton(
                text: "Update",
                press: () {
                  updateUser();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Thank you!"),
                      );
                    },
                  );
                }),
          ]);
    }
  }
}
