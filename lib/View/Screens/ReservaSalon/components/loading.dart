import 'package:flutter/material.dart';
import 'package:sprint2/constraints.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Cargando salones...'),
        SizedBox(height: 20),
        Center(
          child: CircularProgressIndicator(
            color: kPrimaryDarkColor,
          ),
        )
      ],
    ));
  }
}
