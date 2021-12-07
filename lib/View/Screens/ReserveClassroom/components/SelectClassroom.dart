// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sprint2/View/Screens/ReserveClassroom/components/loading.dart';
import 'package:sprint2/View/components/noConnectionWidget.dart';
import 'package:sprint2/View_Models/selectClassroom_viewModel.dart';
import 'package:sprint2/View_Models/user_viewModel.dart';
import 'package:sprint2/constraints.dart';

class SelectClassroom extends StatefulWidget {
  final DateTime? dateTime;
  SelectClassroom({Key? key, this.dateTime}) : super(key: key);

  @override
  _SelectClassroomState createState() => _SelectClassroomState();
}

class _SelectClassroomState extends State<SelectClassroom> {
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
    if (result == ConnectivityResult.none) {
      Navigator.of(context).pop();
    }
    setState(() {
      _connectionStatus = result;
    });
  }

  Widget _buildRow(String classroom) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(child: Text(classroom)),
          Expanded(child: Container(child: _btnReservarClassroom(classroom)))
        ],
      ),
    );
  }

  Widget _buildClassooms(List<String> classroms) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: classroms.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildRow(classroms[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var selectClassrooms = context.watch<SelectClassroomViewModel>();
    return _connectionStatus == ConnectivityResult.none
        ? NoConnectionWidget()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Seleccionar salón'),
              backgroundColor: kPrimaryDarkColor,
            ),
            body: (selectClassrooms.classrooms.isNotEmpty)
                ? _buildClassooms(selectClassrooms.classrooms)
                : Builder(builder: (BuildContext context) {
                    Provider.of<SelectClassroomViewModel>(context,
                            listen: false)
                        .getClassroomsWithNoReservesAtTime(
                            widget.dateTime!.month,
                            widget.dateTime!.day,
                            widget.dateTime!.hour);
                    print({
                      'desde SeleccionarClassroom',
                      selectClassrooms.classrooms
                    });
                    return LoadingWidget();
                  }),
          );
  }

  Widget _btnReservarClassroom(String classroom) {
    return OutlinedButton(
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context1) => MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                  value: Provider.of<UserViewModel>(context)),
            ],
            child: AlertDialog(
              title: const Text('Seleccionar salón'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Seguro que desea reservar el salón $classroom?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Aceptar'),
                  onPressed: () {
                    try {
                      Provider.of<SelectClassroomViewModel>(context,
                              listen: false)
                          .reserveClassroom(
                              widget.dateTime!.day,
                              widget.dateTime!.hour,
                              widget.dateTime!.minute,
                              widget.dateTime!.month,
                              Provider.of<UserViewModel>(context, listen: false)
                                  .getEmail(),
                              classroom,
                              widget.dateTime!.year)
                          .then((res) => ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  duration: Duration(milliseconds: 2000),
                                  content: Text(res))));
                    } catch (e) {
                      print(e);
                    }
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    print('Cancelar escaneo');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: const Text('Reservar'),
    );
  }
}
