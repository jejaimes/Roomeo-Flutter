import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sprint2/View/components/noConnectionWidget.dart';
import 'package:sprint2/constraints.dart';
import 'package:sprint2/View_Models/qr_viewModel.dart';

class ScanQRView extends StatefulWidget {
  const ScanQRView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQRViewState();
}

class _ScanQRViewState extends State<ScanQRView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
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

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return _codeScanned(context);
  }

  Widget _codeScanned(BuildContext context) {
    return _connectionStatus == ConnectivityResult.none
        ? NoConnectionWidget()
        : result != null
            ? AlertDialog(
                title: const Text('Registrar ingreso al salón'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Seguro que desea entrar al salón ${result!.code}?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      List<String> res = result!.code!.split('-');
                      Provider.of<QRViewModel>(context, listen: false)
                          .addPersonToRoom(res[0], int.parse(res[1]))
                          .then((res) => ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  duration: Duration(milliseconds: 2000),
                                  content: Text(res))));
                      setState(() {
                        controller!.stopCamera();
                        result = null;
                      });
                    },
                  ),
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      print('Cancelar escaneo');
                      setState(() {
                        controller!.stopCamera();
                        result = null;
                      });
                    },
                  ),
                ],
              )
            : Column(
                children: <Widget>[
                  Expanded(flex: 10, child: _buildQrView(context)),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(4),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                kPrimaryColor)),
                                    onPressed: () async {
                                      await controller?.toggleFlash();
                                      setState(() {});
                                    },
                                    child: FutureBuilder(
                                      future: controller?.getFlashStatus(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          return (snapshot.data as bool)
                                              ? Icon(
                                                  Icons.flashlight_off_rounded,
                                                  semanticLabel: 'Flash Off',
                                                  color: Colors.black,
                                                )
                                              : Icon(
                                                  Icons.flashlight_on_rounded,
                                                  semanticLabel: 'Flash On',
                                                  color: Colors.black,
                                                );
                                        } else {
                                          return const Icon(
                                            Icons.flashlight_on_rounded,
                                            semanticLabel: 'Flash On',
                                            color: Colors.black,
                                          );
                                        }
                                      },
                                    )),
                              ),
                              Container(
                                margin: const EdgeInsets.all(8),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                kPrimaryColor)),
                                    onPressed: () async {
                                      await controller?.flipCamera();
                                      setState(() {});
                                    },
                                    child: FutureBuilder(
                                      future: controller?.getCameraInfo(),
                                      builder: (context, snapshot) {
                                        return Icon(
                                            Icons.flip_camera_ios_rounded,
                                            semanticLabel: 'Flip camera',
                                            color: Colors.black);
                                      },
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.teal,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No se tiene permiso para usar la cámara')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
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
}
