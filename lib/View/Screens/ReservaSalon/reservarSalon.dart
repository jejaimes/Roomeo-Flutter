import 'package:flutter/material.dart';
import 'package:sprint2/View/Screens/ReservaSalon/components/form.dart';

class ReservarSalonWidget extends StatefulWidget {
  @override
  _ReservarSalonWidgetState createState() => _ReservarSalonWidgetState();
}

class _ReservarSalonWidgetState extends State<ReservarSalonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: InitialForm(),
    );
  }
}
