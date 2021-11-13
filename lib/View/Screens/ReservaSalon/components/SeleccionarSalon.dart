// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sprint2/Models/building_model.dart';

class SeleccionarSalon extends StatefulWidget {
  final DateTime? dateTime;
  final List<Classroom>? classroms;
  SeleccionarSalon({Key? key, this.dateTime, this.classroms}) : super(key: key);

  @override
  _SeleccionarSalonState createState() => _SeleccionarSalonState();
}

class _SeleccionarSalonState extends State<SeleccionarSalon> {
  CollectionReference reservas =
      FirebaseFirestore.instance.collection('reserves');

  Widget _buildRow(Classroom salon) {
    return ListTile(
      title: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Text(salon.number.toString()),
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
      itemCount: widget.classroms!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildRow(widget.classroms![index]);
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
      onPressed: () {
        reservas.add({
          'day': widget.dateTime!.day,
          'hour': widget.dateTime!.hour,
          'minute': widget.dateTime!.minute,
          'month': widget.dateTime!.month,
          'name': 'st.goat@uniandes.edu.co',
          'room': '${salon.number}',
          'year': widget.dateTime!.year
        });
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('${salon.number}'),
            content: Text(
                'Reserva exitosa para el ${widget.dateTime!.day} de ${widget.dateTime!.month} a las ${widget.dateTime!.hour}'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      child: const Text('Reservar'),
    );
  }
}
