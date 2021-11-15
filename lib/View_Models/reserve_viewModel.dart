import 'package:flutter/foundation.dart';
import 'package:sprint2/Models/apis/api_response.dart';
import 'package:sprint2/Models/reserve_model.dart';
import 'package:sprint2/Models/reserve_repository.dart';

class ReserveViewModel extends ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.loading('Fetching reserves data');
  ReserveRepository _reserveRepository = ReserveRepository();
  late Reserve _reserve;

  ApiResponse get response {
    return _apiResponse;
  }

  Reserve get reserve {
    return _reserve;
  }

  /// Call the reserve service and gets the data of requested reserve
  Future<void> fetchReserveData() async {
    try {
      List<Reserve> reserveList = await _reserveRepository.fetchReservesList();
      _apiResponse = ApiResponse.completed(reserveList);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  void fetchRealTimeReserveData() {
    List<Reserve>? reserveList = _reserveRepository.fetchRealTimeReservesList();
    if (reserveList != null && reserveList.isEmpty) {
      _apiResponse = ApiResponse.completed(reserveList);
    }
  }

  void setSelectedReserve(Reserve reserve) {
    _reserve = reserve;
    notifyListeners();
  }
}
