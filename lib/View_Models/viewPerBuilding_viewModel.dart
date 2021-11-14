import 'package:flutter/foundation.dart';
import 'package:sprint2/Models/building_model.dart';
import 'package:sprint2/Models/building_repository.dart';

class ViewPerBuildingViewModel with ChangeNotifier {
  BuildingRepository _buildingRepository = BuildingRepository();

  ViewPerBuildingViewModel();

  Future<String> addPersonToRoom(String building, int classroom) {
    return _buildingRepository
        .addPersonToClassroom(building, classroom)
        .then((value) {
      notifyListeners();
      return value;
    }).catchError(
            (error) => 'Hubo un error registrando su ingreso al salón: $error');
  }

  Future<Building?> getBuildingByName(String name) {
    return _buildingRepository.fetchBuildingByName(name);
  }

  void addClassroomsToList(List<dynamic> data, List<Classroom> classrooms) {
    for (var item in data) {
      Classroom room = Classroom(
          number: item['number'],
          maxCap: item['maxCap'],
          currentCap: item['currentCap']);
      classrooms.add(room);
    }
  }
}
