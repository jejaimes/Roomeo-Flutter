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
}
