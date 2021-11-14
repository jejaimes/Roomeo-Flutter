import 'Services/reserve_service.dart';
import 'reserve_model.dart';

class ReserveRepository {
  ReserveService _reserveService = ReserveService();

  Future<List<Reserve>> fetchReservesList() async {
    dynamic response = await _reserveService.get();
    response.toList();
    return response;
  }

  List<Reserve>? fetchRealTimeReservesList() {
    List<Reserve> updatedReserves = [];
    _reserveService.listenToReservesRealTime().listen((reserveData) {
      updatedReserves = reserveData;
    });
    return updatedReserves;
  }

  Future<List<Map<String, dynamic>>> fetchClassroomsWithReservesAtTime(
      int month, int day, int hour) async {
    List<Reserve> apiResponse =
        await _reserveService.getReservesAtTime(month, day, hour);
    List<Map<String, dynamic>> response = [];
    for (var reserve in apiResponse) {
      List<String> place = reserve.room.split(' - ');
      print({'reserve at repository': reserve});
      response.add({'building': place[0], 'number': int.parse(place[1])});
    }
    return response;
  }

  Future<List<Reserve>> fetchUserReserves(String name) async {
    dynamic response = await _reserveService.getUserReserves(name);
    response.toList();
    return response;
  }

  Future<String> createReserve(Reserve reserve) async {
    return await _reserveService.addReserve(reserve);
  }
}
