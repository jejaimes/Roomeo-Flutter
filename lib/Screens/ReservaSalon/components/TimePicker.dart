import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TimeSelector extends StatefulWidget {
  TimeSelector({Key? key}) : super(key: key);

  @override
  _TimeSelectorState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  DateTime selectedTime = DateTime.now();
  void name(args) {}
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () {
          DatePicker.showTimePicker(context, showTitleActions: true,
              onChanged: (date) {
            print('change $date in time zone ' +
                date.timeZoneOffset.inHours.toString());
          }, onConfirm: (date) {
            selectedTime = date;
            print('confirm $date');
          }, currentTime: DateTime.now());
        },
        child: Text(
          'show time picker',
        ));
  }
}
