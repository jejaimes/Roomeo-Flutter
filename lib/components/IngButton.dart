import 'package:flutter/material.dart';
import '../constraints.dart';

class IngButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color, textColor;
  const IngButton({
    Key? key,
    required this.text,
    required this.press,
    this.color=kPrimaryColor,
    this.textColor=Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      width: size.width*0.8,
      child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[kPrimaryColor, kPrimaryLightColor],
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              
              padding: const EdgeInsets.all(16.0),
              primary: textColor,
              textStyle: const TextStyle(fontSize: 30),
            ),
            
            onPressed: press,
            child: Align(
              alignment: Alignment.center,
              child: Text(text)
            ),
          ),
        ],
      ),
    ),

    );
  }
}
