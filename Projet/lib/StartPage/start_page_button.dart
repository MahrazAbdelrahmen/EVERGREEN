
import 'package:flutter/material.dart';

import '../player_box.dart';


class AnonButton extends StatelessWidget {
  const AnonButton({super.key, required this.href, required this.color, required this.text});
  final String href;
  final Color color ;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: ()  {
          getProgress();
          Navigator.pushNamed(context, href);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            side: const BorderSide(width: 3, color: Colors.white),
            elevation: 0,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding:
            const EdgeInsets.only(left: 30, right: 30, top: 8, bottom: 10)),
        child:  Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Digital',
          ),
        ));
  }
}

