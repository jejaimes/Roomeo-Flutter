import 'package:flutter/material.dart';
import 'package:sprint2/constraints.dart';

class NoConnectionWidget extends StatefulWidget {
  const NoConnectionWidget({Key? key}) : super(key: key);

  @override
  _NoConnectionWidgetState createState() => _NoConnectionWidgetState();
}

class _NoConnectionWidgetState extends State<NoConnectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Icon(
            Icons.cloud_off_rounded,
            color: kPrimaryColor,
            size: 100,
          ),
        ),
        Text(
          'Sin conexión a Internet! :(',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Esta funcionalidad se reactivará cuando se restablezca la connexión',
        ),
      ],
    );
  }
}
