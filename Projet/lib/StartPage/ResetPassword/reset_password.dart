import 'package:flutter/material.dart';
import 'package:sorttrash/BackEnd/AuthService/auth_service.dart';
import 'package:sorttrash/button.dart';
import '../LoginPage/Cred/login_cred.dart';

class ResetPasswordButton extends StatefulWidget {
  const ResetPasswordButton({super.key});

  @override
  _ResetPasswordButtonState createState() => _ResetPasswordButtonState();
}

class _ResetPasswordButtonState extends State<ResetPasswordButton> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _auth = AuthService();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  final _mykey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg-image.png'), fit: BoxFit.fill
                )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(alignment : Alignment.bottomLeft,child: RoundButton(href: '/LoginPage', myIcon: Icons.exit_to_app, couleur: Colors.greenAccent, shadowColor:Colors.white)),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: 0.42*MediaQuery.of(context).size.width,
                    height: 0.75*MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1, color: Colors.black),
                    ),
                    child: SingleChildScrollView(
                      child: Center(
                        child: Form(
                          key: _mykey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 0.09 * MediaQuery.of(context).size.height,
                                width: 0.35 * MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(103, 235, 0, 1),
                                    side: const BorderSide(width: 1, color: Colors.black38),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                  ),
                                  child: const Text(
                                    'Réinitialiser le mot de passe',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Digital',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 0.15 * MediaQuery.of(context).size.height,
                              ),
                              EmailCred(
                                  hint: 'Entrez votre adresse e-mail !',
                                  controller: _emailController,
                                  obscureText: false),
                              Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    _auth.error = false;
                                    if (_mykey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Colors.greenAccent,
                                          content: Text(
                                            "🌐 : Envoi d'un e-mail.. ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Digital',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          )));
                                      await _auth.resetPassword(_emailController.text.trim());
                                      setState(() {
                                        if (_auth.error) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              duration: const Duration(seconds: 6),
                                              backgroundColor: Colors.redAccent,
                                              content: Text(
                                                '📢 : ${_auth.errorMessage} ',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Digital',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              )));
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              duration: Duration(seconds: 6),
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                '📧 : E-mail de réinitialisation envoyé !',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Digital',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              )));
                                        }
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightBlueAccent,
                                      padding: const EdgeInsets.only(
                                          left: 40, right: 40, top: 5, bottom: 8)),
                                  child: const Text(
                                    'Réinitialiser',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Digital',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
