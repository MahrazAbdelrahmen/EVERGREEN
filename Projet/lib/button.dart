import 'package:flutter/material.dart';

import 'composents/ui/app_button.dart';

class RoundButton extends StatelessWidget {
  final String? href; //pour indiquer le chemin à prendre en cliquant sur l'icon
  final IconData myIcon;
  final Color couleur;
  final Color shadowColor;

  /// When false the screen opens on top of the current one, so Back returns here.
  final bool replace;
  const RoundButton(
      {super.key, required this.href, required this.myIcon, required this.couleur, required this.shadowColor, this.replace = true});

  @override
  Widget build(BuildContext context) {
    return RoundIconButton(
      icon: myIcon,
      color: couleur,
      onTap: href == '-'
          ? null
          : () => replace
              ? Navigator.popAndPushNamed(context, '$href')
              : Navigator.pushNamed(context, '$href'),
    );
  }
}

class RectangleButton extends StatelessWidget {
  final Color couleur1;
  final Color couleur2;
  final String? text;
  const RectangleButton(
      {super.key,
      required this.couleur1,
      required this.couleur2,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          //le grand container vert
          height: 35.0,
          width: 86.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: couleur1, //secondaire
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          ),
        ),
        Positioned(
          top: 2.0,
          left: 2.0,
          child: Container(
            height: 28.0,
            width: 82.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: couleur2, //principal
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                child: Text(
                  "$text",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
