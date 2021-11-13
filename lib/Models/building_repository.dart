import 'Services/building_service.dart';
import 'building_model.dart';

class BuildingRepository {
  BuildingService _buildingService = BuildingService();

  Future<List<Building>> fetchBuildingList() async {
    dynamic response=await _buildingService.get();
    response.toList();
    return response;
  }
}
