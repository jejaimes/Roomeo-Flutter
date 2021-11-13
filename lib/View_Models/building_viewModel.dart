import 'package:flutter/foundation.dart';
import 'package:sprint2/Models/apis/api_response.dart';
import 'package:sprint2/Models/building_model.dart';
import 'package:sprint2/Models/building_repository.dart';

class BuildingViewModel with ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.loading('Fetching buildings data');

  late Building _building;

  ApiResponse get response {
    return _apiResponse;
  }

  Building get building {
    return _building;
  }

  /// Call the building service and gets the data of requested building
  Future<void> fetchBuildingData() async {
    try {
      List<Building> buildingList =
          await BuildingRepository().fetchBuildingList();
      _apiResponse = ApiResponse.completed(buildingList);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  void setSelectedBuilding(Building building) {
    _building = building;
    notifyListeners();
  }
}
