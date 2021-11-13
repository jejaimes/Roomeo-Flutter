import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;

import '../building_model.dart';

class BuildingService {
  Future<List<Building>> get() async {
    Building building;
    List<Building> buildingsList = [];
    await FirebaseFirestore.instance
        .collection('Buildings')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        building = Building.fromJson(doc.data());
        buildingsList.add(building);
      });
    })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => {print(error)});

    print(buildingsList);
    return buildingsList;
  }
}
