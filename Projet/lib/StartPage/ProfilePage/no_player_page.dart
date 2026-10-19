

import 'package:flutter/material.dart';
import 'package:sorttrash/button.dart';

class NoPlayerSelectedPage extends StatelessWidget {
  const NoPlayerSelectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: const [
                RoundButton(href: '/StartPage', myIcon: Icons.exit_to_app, couleur: Colors.redAccent, shadowColor: Colors.black),
                Icon(
                  Icons.supervised_user_circle,
                  color: Colors.redAccent,
                  size: 100,
                ),
                Text(
                  'Veuillez vous connecter',
                  style: TextStyle(
                      fontSize: 50,
                      color: Colors.redAccent,
                      fontFamily: 'Digital', decoration: TextDecoration.none),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
