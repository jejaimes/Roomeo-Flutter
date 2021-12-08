import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sprint2/constraints.dart';

class PhotoItem {
  final String image;
  final int type;
  PhotoItem(this.image, this.type);
}

class CustomCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 1),
      maxNrOfCacheObjects: 10,
    ),
  );
}

final List<List<PhotoItem>> _items = [
  [
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/person-sick-in-your-household-what-to-do-es.png",
        0),
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/person-sick-in-your-household-prepare-es.jpg",
        0),
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/grocery-shopping-es.jpg",
        0),
  ],
  [
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/medical-mask-do-sp.jpg?sfvrsn=c67232f0_19",
        1),
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/medical-mak-dont-spd846cb194a4943a4bcd929fc0fe945e0.jpg?sfvrsn=3bcd5aa0_13",
        1),
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/who-clothing-masks-dos-infographic-es.jpg?sfvrsn=679fb6f1_28",
        1),
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/who-clothing-masks-donts-infographic-es.jpg?sfvrsn=d7b0f88d_22",
        1),
  ],
  [
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/visiting-family.jpg",
        2),
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/dont-put-off-medical-appointments-es.jpg",
        2),
  ]
];

class careInfoView extends StatefulWidget {
  const careInfoView({Key? key}) : super(key: key);

  @override
  _careInfoViewState createState() => _careInfoViewState();
}

class _careInfoViewState extends State<careInfoView> {
  ConnectivityResult _connectionStatus = ConnectivityResult.wifi;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  int typeOfPoster = 0;
  List<PhotoItem> currentList = _items[0];
  @override
  Widget build(BuildContext context) {
    CustomCacheManager.instance.emptyCache();
    return Scaffold(
      appBar: AppBar(
        title: Text('Información oficial sobre el Covid-19'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
          children: [
            ButtonBar(
              buttonPadding: new EdgeInsets.only(left: 30),
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.deepPurple,
                  highlightColor: Colors.deepPurple,
                  onPressed: () => {
                    setState(() {
                      typeOfPoster = 0;
                      currentList = _items[typeOfPoster];
                    })
                  },
                ),
                IconButton(
                  icon: Icon(Icons.school),
                  color: Colors.green,
                  highlightColor: Colors.green,
                  onPressed: () => {
                    setState(() {
                      typeOfPoster = 1;
                      currentList = _items[typeOfPoster];
                    })
                  },
                ),
                IconButton(
                  color: Colors.red,
                  highlightColor: Colors.red,
                  icon: Icon(Icons.local_hospital_outlined),
                  onPressed: () => {
                    setState(() {
                      typeOfPoster = 2;
                      currentList = _items[typeOfPoster];
                    })
                  },
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                itemCount: currentList.length,
                itemBuilder: (context, index) {
                  return new GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RouteTwo(
                              image: _items[typeOfPoster][index].image,
                            ),
                          ));
                    },
                    child: CachedNetworkImage(
                      cacheManager: CustomCacheManager.instance,
                      imageUrl: _items[typeOfPoster][index].image,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Column(
                        children: [
                          Icon(Icons.error),
                          Text(
                              "No se ha podido cargar la imagen\nPor favor revisa tu conexión a internet")
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

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
    if (result == ConnectivityResult.none &&
        _connectionStatus != ConnectivityResult.none) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sin conexión'),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.25,
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
                      'No hay conexión a internet. Es posible que parte de la información no este actualizada o no se haya cargado por completo.',
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

class RouteTwo extends StatelessWidget {
  final String image;

  RouteTwo({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: double.infinity,
        child: CachedNetworkImage(
          cacheManager: CustomCacheManager.instance,
          imageUrl: image,
          errorWidget: (context, url, error) => Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: kPrimaryDarkColor,
              title: Center(
              child: Text('Error cargando imagen'),
            ),
            ),
            body: Center(
              child: Column(children: [
                Icon(Icons.error),
                Text(
                  "La imagén no se ha podido cargar de manera correcta por favor revisa tu conexión a internet.",
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
