import 'Services/building_service.dart';
import 'building_model.dart';

class BuildingRepository {
  BuildingService _buildingService = BuildingService();

  Future<List<Building>> fetchBuildingList() async {
    dynamic response = await _buildingService.get();
    response.toList();
    return response;
  }

  Future<Building?> fetchBuildingByName(String name) {
    return _buildingService.getBuilding(name);
  }

  Future<String> addPersonToClassroom(
      String buildingName, int classroomNumber) async {
    Building? building = await _buildingService.getBuilding(buildingName);
    if (building == null) {
      return 'No se pudo encontrar un edificio con ese nombre';
    } else {
      for (var i = 0; i < building.classrooms.length; i++) {
        if (building.classrooms[i].number == classroomNumber &&
            building.classrooms[i].currentCap < building.classrooms[i].maxCap) {
          building.classrooms[i].currentCap++;
          _buildingService.updateClassrooms(
              buildingName, building.classroomsToJson());
          return 'Se ha registrado su ingreso en la base de datos';
        }
      }
      return 'No se pudo registrar su ingreso. El salón ya esta lleno';
    }
  }
}
