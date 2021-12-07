// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sprint2/Models/building_model.dart';
import 'package:sprint2/View_Models/viewPerBuilding_viewModel.dart';
import 'package:sprint2/constraints.dart';

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
  ConnectivityResult _connectionStatus = ConnectivityResult.wifi;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
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
    setState(() {
      _connectionStatus = result;
    });
  }

  Widget _btnAssistToClassroom(Classroom classroom) {
    return OutlinedButton(
      onPressed: () => _connectionStatus == ConnectivityResult.none
          ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(milliseconds: 2000),
              content: Text(
                  'Esta función no está disponible porque no tienes conexión a Internet')))
          : showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Salón ${classroom.number.toString()}'),
                content: const Text('¿Va a asistir al salón?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<ViewPerBuildingViewModel>(context,
                              listen: false)
                          .addPersonToRoom(widget.building!, classroom.number)
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

  Widget _buildRow(Classroom classroom) {
    return ListTile(
      leading: Text(
        '${widget.building} - ${classroom.number}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      title: Row(
        children: <Widget>[
          Text('${classroom.currentCap}/${classroom.maxCap}',
              style: TextStyle(
                fontSize: 20,
              )),
          const Icon(
            Icons.person_rounded,
            size: 28,
          ),
        ],
      ),
      trailing: _btnAssistToClassroom(classroom),
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
                Expanded(child: Text('Cargando classroomes...')),
                SizedBox(height: 20),
                Expanded(
                    child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: kPrimaryDarkColor,
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
              Expanded(child: Text('Cargando classroomes...')),
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
