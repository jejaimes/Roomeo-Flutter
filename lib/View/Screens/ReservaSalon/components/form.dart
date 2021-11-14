import 'package:flutter/material.dart';
import 'SeleccionarSalon.dart';

class InitialForm extends StatefulWidget {
  const InitialForm({Key? key}) : super(key: key);

  @override
  _InitialFormState createState() => _InitialFormState();
}

class _FormData {
  String date = '';
  String time = '';
}

class _InitialFormState extends State<InitialForm> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  _FormData _data = new _FormData();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  void _seleccionarSalon(DateTime fecha) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SeleccionarSalon(
        dateTime: fecha,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Por favor seleccione la fecha y hora de la reserva'),
          SizedBox(
            height: 30,
          ),
          //Text(
          //  'Fecha',
          //  style: TextStyle(fontWeight: FontWeight.bold),
          //),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              readOnly: true,
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Fecha',
                labelStyle: new TextStyle(color: Color(0xFF4FB3BF)),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'Selecciona la fecha',
                hintStyle: new TextStyle(color: Color(0xFF005662)),
                border: OutlineInputBorder(gapPadding: 2),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF4FB3BF), width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF4FB3BF))),
              ),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'No se seleccionó una fecha.';
                }
                return null;
              },
              onTap: () async {
                var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100));
                dateController.text =
                    (date ?? '          ').toString().substring(0, 10);
              },
              onSaved: (String? value) {
                this._data.date = value!;
              }),
          SizedBox(
            height: 30,
          ),
          //Text(
          //  'Hora',
          //  style: TextStyle(fontWeight: FontWeight.bold),
          //),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              readOnly: true,
              controller: timeController,
              decoration: InputDecoration(
                labelText: 'Hora',
                labelStyle: new TextStyle(color: Color(0xFF4FB3BF)),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'Selecciona la hora',
                hintStyle: new TextStyle(color: Color(0xFF005662)),
                border: OutlineInputBorder(gapPadding: 2),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF4FB3BF), width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF4FB3BF))),
              ),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'No se seleccionó una hora.';
                }
                return null;
              },
              onTap: () async {
                var time = await showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: context,
                );
                timeController.text = time != null ? time.format(context) : '';
              },
              onSaved: (String? value) {
                this._data.time = value!;
              }),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                if (this._key.currentState!.validate()) {
                  _key.currentState!.save();
                  var fecha = _data.date.split('-');
                  var hora = _data.time.split(':');
                  DateTime fechaReserva = DateTime(
                      int.parse(fecha[2]),
                      int.parse(fecha[1]),
                      int.parse(fecha[0]),
                      int.parse(hora[0]),
                      int.parse(hora[1]));
                  print(fechaReserva);
                  _seleccionarSalon(fechaReserva);
                }
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF4AB3BF))),
              child: const Text('Continuar'))
        ],
      ),
    );
  }
}
