// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sprint2/Screens/ViewPerBuilding/viewPerBuilding.dart';

class SeleccionarSalon extends StatefulWidget {
  final DateTime? dateTime;
  const SeleccionarSalon({Key? key, this.dateTime}) : super(key: key);

  @override
  _SeleccionarSalonState createState() => _SeleccionarSalonState();
}

class _SeleccionarSalonState extends State<SeleccionarSalon> {
  CollectionReference reservas =
      FirebaseFirestore.instance.collection('reserves');
  final _classroms = <Classroom>[
    Classroom(603, 40, 5, 'B'),
    Classroom(604, 40, 10, 'B')
  ];

  Widget _buildRow(Classroom salon) {
    return ListTile(
      title: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Text(salon.building + salon.number.toString()),
          const Divider(),
          Text('${salon.maxCap}'),
          const Icon(
            Icons.person_rounded,
            size: 24,
          ),
          const Divider(),
          _btnReservarSalon(salon)
        ],
      ),
    );
  }

  Widget _buildClassooms() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: _classroms.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildRow(_classroms[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservar salón'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        flexibleSpace: Image.asset(
          "assets/images/W.png",
          fit: BoxFit.cover,
        ),
      ),
      body: _buildClassooms(),
    );
  }

  Widget _btnReservarSalon(Classroom salon) {
    return OutlinedButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('${salon.building} - ${salon.number}'),
          content: Text(
              'Reserva exitosa para el ${widget.dateTime!.day} de ${widget.dateTime!.month} a las ${widget.dateTime!.hour}'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Reservar'),
    );
  }
}
