import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint2/View_Models/selectClassroom_viewModel.dart';
import 'package:sprint2/View_Models/user_viewModel.dart';
import 'package:sprint2/constraints.dart';
import 'SelectClassroom.dart';

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
      SelectClassroomViewModel seleccionarsalonViewModel =
          SelectClassroomViewModel();
      seleccionarsalonViewModel.getClassroomsWithNoReservesAtTime(
          fecha.month, fecha.day, fecha.hour);
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: seleccionarsalonViewModel),
          ChangeNotifierProvider.value(
              value: Provider.of<UserViewModel>(context)),
        ],
        child: SelectClassroom(
          dateTime: fecha,
        ),
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
          Text(
            'Por favor seleccione la fecha y hora de la reserva',
            style: const TextStyle(
              fontSize: 20,
            ), //color: Color(0xFF005662),),
          ),
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
                labelStyle: new TextStyle(color: kPrimaryDarkColor),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'Selecciona la fecha',
                hintStyle: new TextStyle(color: Color(0xFF005662)),
                border: OutlineInputBorder(gapPadding: 2),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryDarkColor, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryDarkColor)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF60000))),
              ),
              validator: (String? value) {
                if (value!.trimRight().isEmpty) {
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
                labelStyle: new TextStyle(color: kPrimaryDarkColor),
                //errorStyle: new TextStyle(color: Color(0xFFC2847A)),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'Selecciona la hora',
                hintStyle: new TextStyle(color: Color(0xFF005662)),
                border: OutlineInputBorder(gapPadding: 2),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryDarkColor, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryDarkColor)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF60000))),
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
                  var amOrPm = _data.time.split(' ')[1];
                  var fecha = DateTime.parse(_data.date);
                  var hora = _data.time.split(' ')[0].split(':');
                  DateTime fechaReserva = DateTime(
                      fecha.year,
                      fecha.month,
                      fecha.day,
                      amOrPm == 'AM'
                          ? int.parse(hora[0])
                          : int.parse(hora[0]) + 12,
                      int.parse(hora[1]));
                  print({'fechaReserva': fechaReserva});
                  _seleccionarSalon(fechaReserva);
                }
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kPrimaryDarkColor)),
              child: const Text('Continuar'))
        ],
      ),
    );
  }
}
