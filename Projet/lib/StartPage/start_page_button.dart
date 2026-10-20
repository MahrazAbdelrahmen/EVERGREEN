import 'package:flutter/material.dart';

import '../composents/ui/app_button.dart';
import '../player_box.dart';

class AnonButton extends StatelessWidget {
  const AnonButton(
      {super.key, required this.href, required this.color, required this.text, this.icon});
  final String href;
  final Color color;
  final String text;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: text,
      icon: icon,
      color: color,
      fontSize: 22,
      onTap: () {
        getProgress();
        Navigator.pushNamed(context, href);
      },
    );
  }
}
