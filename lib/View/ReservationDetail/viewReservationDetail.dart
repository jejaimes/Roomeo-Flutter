// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sprint2/Models/reserve_model.dart';
import 'package:sprint2/View_Models/reservationDetail_viewModel.dart';
import 'package:sprint2/constraints.dart';

class ReservationDetailWidget extends StatefulWidget {
  final Reserve? reserve;
  ReservationDetailWidget({Key? key, this.reserve}) : super(key: key);

  @override
  _ReservationDetailWidgetState createState() =>
      _ReservationDetailWidgetState();
}

class _ReservationDetailWidgetState extends State<ReservationDetailWidget> {
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

  Widget _btnCancelReserve() {
    return OutlinedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
      onPressed: () => _connectionStatus == ConnectivityResult.none
          ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(milliseconds: 2000),
              content: Text(
                  'Esta función no está disponible porque no tienes conexión a Internet')))
          : showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Cancelar reserva'),
                content: const Text('¿Seguro que quiere cancelar la reserva?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<ReservationDetailViewModel>(context,
                              listen: false)
                          .cancelReserve(widget.reserve!)
                          .then((res) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(milliseconds: 2000),
                            content: Text(res)));
                      });
                    },
                    child: const Text('Si'),
                  ),
                ],
              ),
            ),
      child: const Text(
        'CANCELAR RESERVA',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  Widget _buildReserve() {
    return ListView(
      children: <Widget>[
        Card(
            child: Column(
          children: [
            Text('Salón: ${widget.reserve!.room}'),
            Text(
                'Fecha: ${widget.reserve!.day}-${widget.reserve!.month}-${widget.reserve!.year}'),
            Text('Hora: ${widget.reserve!.hour}:${widget.reserve!.minute}'),
            Text('Estado: ${widget.reserve!.state}')
          ],
        )),
        widget.reserve!.state == 'Válida'
            ? Card(
                child: _btnCancelReserve(),
              )
            : SizedBox(
                height: 1,
              )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return (_connectionStatus == ConnectivityResult.none)
        ? Scaffold(
            appBar: AppBar(
              title: Text('Reserva'),
              backgroundColor: kPrimaryDarkColor,
              foregroundColor: Colors.white,
            ),
            body: _buildReserve(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Reserva'),
              backgroundColor: kPrimaryDarkColor,
              foregroundColor: Colors.white,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: Text('Cargando reserva...')),
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
}
