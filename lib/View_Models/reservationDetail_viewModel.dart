import 'package:flutter/foundation.dart';
import 'package:sprint2/Models/reserve_model.dart';
import 'package:sprint2/Models/reserve_repository.dart';

class ReservationDetailViewModel extends ChangeNotifier {
  ReserveRepository _reserveRepository = ReserveRepository();

  ReservationDetailViewModel();

  Future<String> cancelReserve(Reserve reserve) {
    var json = reserve.toJson();
    json['state'] = 'Cancelada';
    Reserve newReserve = Reserve.fromJson(json);
    return _reserveRepository.updateReserve(newReserve).then((value) {
      notifyListeners();
      return value;
    }).catchError((error) => error);
  }
}
