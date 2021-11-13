import 'package:flutter/material.dart';
import 'package:sprint2/Models/building_model.dart';
import 'package:sprint2/View/Screens/ReservaSalon/components/SeleccionarSalon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservarSalonWidget extends StatefulWidget {
  @override
  _ReservarSalonWidgetState createState() => _ReservarSalonWidgetState();
}

class _ReservarSalonWidgetState extends State<ReservarSalonWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? fecha;

  CollectionReference buildings =
      FirebaseFirestore.instance.collection('Buildings');
  final _classroms = <Classroom>[];

  void _reservarSalon(DateTime fecha, List<Classroom> classroomsList) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SeleccionarSalon(
        dateTime: fecha,
        classroms: classroomsList,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: buildings.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.docs.isNotEmpty) {
          return Text("Document does not exist in the Collection");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data!.docs);
          snapshot.data!.docs.map((e) {
            e.get('classrooms').map((obj) => _classroms.add(Classroom(
                number: obj['number'],
                maxCap: obj['maxCap'],
                currentCap: obj['currentCap'])));
          });
          return Scaffold(
            appBar: AppBar(
              title: Text('Reservar salón'),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              flexibleSpace: Image.asset(
                "assets/images/W.png",
                fit: BoxFit.cover,
              ),
            ),
            body: Center(
              child: Column(
                children: <Widget>[
                  const Text(
                    'Por favor seleccione fecha y hora de la reserva',
                    style: TextStyle(fontSize: 20),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Fecha y Hora',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        InputDatePickerFormField(
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2022),
                          fieldHintText: 'yyyy-mm-dd h:m:s',
                          onDateSaved: (DateTime value) {
                            fecha = value;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                              if (_formKey.currentState!.validate()) {
                                _reservarSalon(fecha!, _classroms);
                              }
                            },
                            child: const Text('Continuar'),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}
