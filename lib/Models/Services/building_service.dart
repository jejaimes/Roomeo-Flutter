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

  Future<Building?> getBuilding(String name) async {
    Building? building;
    await FirebaseFirestore.instance
        .collection('Buildings')
        .doc(name.toUpperCase())
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
      if (documentSnapshot.exists) {
        building = Building.fromJson(documentSnapshot.data()!);
      }
    }).catchError((error) {
      print('Hubo un error obteniendo el edificio: $error');
      return Future.value(null);
    });
    return building;
  }

  Future<void> updateClassrooms(
      String buildingName, List<Map<String, dynamic>> classroomList) async {
    return await FirebaseFirestore.instance
        .collection('Buildings')
        .doc(buildingName.toUpperCase())
        .update({'classrooms': classroomList})
        .then((value) => print('Building updated'))
        .catchError((error) => print('Failed to update the building: $error'));
  }
}
