import 'package:flutter/foundation.dart';
import 'package:sprint2/Models/building_repository.dart';

class QRViewModel extends ChangeNotifier {
  BuildingRepository _buildingRepository = BuildingRepository();

  QRViewModel();

  Future<String> addPersonToRoom(String building, int classroom) {
    return _buildingRepository
        .addPersonToClassroom(building, classroom)
        .then((value) {
      notifyListeners();
      return value;
    }).catchError(
            (error) => 'Hubo un error registrando su ingreso al salón: $error');
  }
}
