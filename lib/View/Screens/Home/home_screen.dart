import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint2/View/Screens/ReservaSalon/reservarSalon.dart';
import 'package:sprint2/View/components/IngButton.dart';
import 'package:sprint2/View/components/BuildingButtons.dart';
import 'package:sprint2/View_Models/building_viewModel.dart';
import 'package:sprint2/constraints.dart';
import 'package:intl/intl.dart';

Duration timeLastHW = new Duration();

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Pide la lista del ViewModel de edificios.
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
    Edificios(optionStyle: optionStyle),
    HandWash(optionStyle: optionStyle),
    ReservarSalonWidget(),
    Text(
      'Scan Code',
      style: optionStyle,
    ),
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
        title: const Text('Roomeo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
            tooltip: 'Saved Suggestions',
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
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Edificios extends StatelessWidget {
  Edificios({
    Key? key,
    required this.optionStyle,
  }) : super(key: key);

  final TextStyle optionStyle;
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
      TextField(
          enabled: false,
          decoration: InputDecoration(
            labelText: "La fecha de hoy es: " + formattedDate,
            fillColor: kPrimaryLightColor,
            labelStyle: TextStyle(color: Colors.black),
          )),
      SizedBox(height: 20),
      /*BuildingButton(
        text: 'ML',
        press: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ViewPerBuildingWidget(
              building: 'ML',
            );
          }));
        },
        codigo: "ML",
      ),
      SizedBox(height: 20),
      BuildingButton(
        text: 'W',
        press: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ViewPerBuildingWidget(
              building: 'W',
            );
          }));
        },
        codigo: "W",
      ),
      SizedBox(height: 20),
      BuildingButton(
        text: 'C',
        press: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ViewPerBuildingWidget(
              building: 'C',
            );
          }));
        },
        codigo: "C",
      ),
      SizedBox(height: 20),
      BuildingButton(
        text: 'RGD',
        press: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ViewPerBuildingWidget(
              building: 'RGD',
            );
          }));
        },
        codigo: "RGD",
      ),
      SizedBox(height: 20),
      BuildingButton(
        text: 'SD',
        press: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ViewPerBuildingWidget(
              building: 'SD',
            );
          }));
        },
        codigo: "SD",
      ),*/
      BuidlingButtons(),
    ]);
  }
}

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
    Duration duracionMin = new Duration(
        days: 0, hours: 0, minutes: 0, seconds: 10, milliseconds: 0);
    if (timeLastHW.compareTo(duracionMin) < 0) {
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
              "Time since last handwash:",
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
