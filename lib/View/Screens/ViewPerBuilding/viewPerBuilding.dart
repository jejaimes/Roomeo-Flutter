// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sprint2/Models/building_model.dart';

class ViewPerBuildingWidget extends StatefulWidget {
  final String? building;
  ViewPerBuildingWidget({Key? key, this.building}) : super(key: key);

  @override
  _ViewPerBuildingWidgetState createState() => _ViewPerBuildingWidgetState();
}

class _ViewPerBuildingWidgetState extends State<ViewPerBuildingWidget> {
  CollectionReference buildings =
      FirebaseFirestore.instance.collection('Buildings');
  final _classroms = <Classroom>[];

  Widget _btnVerReservasSalon(Classroom salon) {
    return OutlinedButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Salón ${salon.number.toString()}'),
          content: const Text('¿Va a asistir al salón?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancelar'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text(
        'ASISTIR',
        style: TextStyle(color: Colors.black, fontSize: 24),
      ),
    );
  }

  Widget _buildRow(Classroom salon) {
    return ListTile(
      leading: Text(
        '${widget.building} - ${salon.number}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      title: Row(
        children: <Widget>[
          Text('${salon.currentCap}/${salon.maxCap}',
              style: TextStyle(
                fontSize: 20,
              )),
          const Icon(
            Icons.person_rounded,
            size: 28,
          ),
        ],
      ),
      trailing: _btnVerReservasSalon(salon),
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
    return FutureBuilder<DocumentSnapshot>(
      future: buildings.doc(widget.building!).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data!.get('classrooms');
          for (var item in data) {
            Classroom room = Classroom(number: item['number'], maxCap: item['maxCap'],
                currentCap: item['currentCap']);
            _classroms.add(room);
          }
          print(_classroms);
          return Scaffold(
            appBar: AppBar(
              title: Text('${widget.building}'),
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

        return Text("loading");
      },
    );
  }
}
