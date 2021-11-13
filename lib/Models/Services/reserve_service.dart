import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../reserve_model.dart';

class ReserveService {
  CollectionReference<Map<String, dynamic>> _reserves =
      FirebaseFirestore.instance.collection('reserves');
  final StreamController<List<Reserve>> _controller =
      StreamController<List<Reserve>>.broadcast();

  Stream listenToReservesRealTime() {
    _reserves.snapshots().listen((reserveSnapshot) {
      if (reserveSnapshot.docs.isNotEmpty) {
        var _newReserves = reserveSnapshot.docs
            .map((snapshot) => Reserve.fromJson(snapshot.data()))
            .toList();
        _controller.add(_newReserves);
      }
    });
    return _controller.stream;
  }

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

  Future<void> addReserve(Reserve newReserve) async {
    return await _reserves
        .add(newReserve.toJson())
        .then((value) => print('Reserve created'))
        .catchError((error) => print("Failed to create new reserve: $error"));
  }

  Future<void> deleteReserve(String idReserve) async {
    return await _reserves
        .doc(idReserve)
        .delete()
        .then((value) => print("Reserve deleted"))
        .catchError((error) => print('Failed to delete the reserve: $error'));
  }

  Future<void> updateReserve(Reserve reserve) async {
    return await _reserves
        .doc(reserve.documentId)
        .update(reserve.toJson())
        .then((value) => print('Reserve updated'))
        .catchError((error) => print('Failed to update the reserve: $error'));
  }
}
