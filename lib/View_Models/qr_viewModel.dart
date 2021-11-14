import 'package:flutter/foundation.dart';
import 'package:sprint2/Models/Services/building_service.dart';

class QRViewModel with ChangeNotifier {
  BuildingService _buildingService = BuildingService();

  QRViewModel();

  void addPersonToRoom(String building, int classroom) {
    print('Se agrego una persona al salon $classroom del edificio $building');
    notifyListeners();
  }
}
