// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint2/Models/building_model.dart';
import 'package:sprint2/View_Models/viewPerBuilding_viewModel.dart';

class ViewPerBuildingWidget extends StatefulWidget {
  final String? building;
  ViewPerBuildingWidget({Key? key, this.building}) : super(key: key);

  @override
  _ViewPerBuildingWidgetState createState() => _ViewPerBuildingWidgetState();
}

class _ViewPerBuildingWidgetState extends State<ViewPerBuildingWidget> {
  CollectionReference buildings =
      FirebaseFirestore.instance.collection('Buildings');
  var _classroms = <Classroom>[];

  Widget _btnVerReservasSalon(Classroom salon) {
    return OutlinedButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Salón ${salon.number.toString()}'),
          content: const Text('¿Va a asistir al salón?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ViewPerBuildingViewModel>(context, listen: false)
                    .addPersonToRoom(widget.building!, salon.number)
                    .then((res) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(milliseconds: 2000),
                      content: Text(res)));
                  setState(() {
                    _classroms = [];
                  });
                });
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
      child: const Text(
        'ASISTIR',
        style: TextStyle(color: Colors.black, fontSize: 20),
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
    return FutureBuilder<Building?>(
      future: Provider.of<ViewPerBuildingViewModel>(context, listen: false)
          .getBuildingByName(widget.building!),
      builder: (BuildContext context, AsyncSnapshot<Building?> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (!snapshot.hasData) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: Text('Cargando salones...')),
                Expanded(
                    child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.teal,
                  ),
                ))
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          _classroms = snapshot.data!.classrooms;
          //print(_classroms);
          return Scaffold(
            appBar: AppBar(
              title: Text('${widget.building}'),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              flexibleSpace: Image.asset(
                "assets/images/${widget.building!.toUpperCase()}.png",
                fit: BoxFit.cover,
              ),
            ),
            body: _buildClassooms(),
          );
        }

        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: Text('Cargando salones...')),
              Expanded(
                  child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.teal,
                ),
              ))
            ],
          ),
        );
      },
    );
  }
}
