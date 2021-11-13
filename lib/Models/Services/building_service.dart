import 'package:cloud_firestore/cloud_firestore.dart';

import '../building_model.dart';

class BuildingService {
  Future<List<Building>> get() async {
    Building building;
    List<Building> buildingsList = [];
    await FirebaseFirestore.instance
        .collection('Buildings')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs
          .forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
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
