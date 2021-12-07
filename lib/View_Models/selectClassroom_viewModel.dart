import 'package:flutter/foundation.dart';
import 'package:sprint2/Models/building_model.dart';
import 'package:sprint2/Models/building_repository.dart';
import 'package:sprint2/Models/reserve_model.dart';
import 'package:sprint2/Models/reserve_repository.dart';

class SelectClassroomViewModel extends ChangeNotifier {
  BuildingRepository _buildingRepository = BuildingRepository();
  ReserveRepository _reserveRepository = ReserveRepository();

  List<String> classrooms = [];

  List<String> getClassrooms() {
    return classrooms;
  }

  void setClassrooms(List<String> classrooms) {
    classrooms = classrooms;
    notifyListeners();
  }

  SelectClassroomViewModel();

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

  Future<String> reserveClassroom(int day, int hour, int minute, int month,
      String name, String room, int year) {
    return _reserveRepository
        .createReserve(Reserve(
            day: day,
            hour: hour,
            minute: minute,
            month: month,
            name: name,
            room: room,
            year: year))
        .then((res) => res)
        .catchError((error) => 'Hubo un error creando la reserva: $error');
  }

  void getClassroomsWithNoReservesAtTime(int month, int day, int hour) async {
    List<Building> buildings = await _buildingRepository.fetchBuildingList();
    List<Map<String, dynamic>> reserves = await _reserveRepository
        .fetchClassroomsWithReservesAtTime(month, day, hour);
    List<int> exceptClassrooms = [];
    for (var building in buildings) {
      int i = 0;
      while (i < reserves.length) {
        if (reserves[i]['building'] == building.name.toLowerCase()) {
          exceptClassrooms.add(reserves[i]['number']);
          reserves.removeAt(i);
        } else {
          i++;
        }
      }
      for (var item in building.getClassroomsExcept(exceptClassrooms)) {
        classrooms.add('${building.name} - ${item.number}');
      }
      exceptClassrooms.clear();
    }
    notifyListeners();
  }
}
