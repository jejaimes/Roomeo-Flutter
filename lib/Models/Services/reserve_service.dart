import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../reserve_model.dart';

class ReserveService {
  late CollectionReference<Map<String, dynamic>> _reserves =
      FirebaseFirestore.instance.collection('reserves');

  Future<List<Reserve>> get() async {
    Reserve reserve;
    List<Reserve> reservesList = [];
    await _reserves
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs
          .forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        reserve = Reserve.fromJson(doc.data());
        reservesList.add(reserve);
      });
    })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => {print(error)});

    print(reservesList);
    return reservesList;
  }

  Future<List<Reserve>> getUserReserves(String name) async {
    Reserve reserve;
    List<Reserve> reservesList = [];
    await _reserves
        .where('name', isEqualTo: name)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs
          .forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        reserve = Reserve.fromJson(doc.data());
        reservesList.add(reserve);
      });
    })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => {print(error)});

    print(reservesList);
    return reservesList;
  }

  Future<List<Reserve>> getReservesAtTime(int month, int day, int hour) async {
    Reserve reserve;
    List<Reserve> reservesList = [];
    await _reserves
        .where('month', isEqualTo: month)
        .where('day', isEqualTo: day)
        .where('hour', isGreaterThanOrEqualTo: hour)
        .where('hour', isLessThan: hour + 3)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      querySnapshot.docs
          .forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        reserve = Reserve.fromJson(doc.data());
        reservesList.add(reserve);
      });
    })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => {print(error)});

    print(reservesList);
    return reservesList;
  }

  Future<String> addReserve(Reserve newReserve) async {
    return await _reserves
        .add(newReserve.toJson())
        .then((value) => 'Reserva creada exitosamente')
        .catchError((error) => "$error");
  }

  Future<String> updateReserve(Reserve reserve) async {
    return await _reserves
        .doc(reserve.documentId)
        .update(reserve.toJson())
        .then((value) => 'Reserva actualizada exitosamente')
        .catchError((error) => 'Failed to update the reserve: $error');
  }
}
