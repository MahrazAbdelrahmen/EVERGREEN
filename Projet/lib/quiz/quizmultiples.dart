import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../composents/game_settings.dart';

bool Indi = false;

class Indication {
  String text; //le corps de l'indication
  String SoundPath; //le son 
  Indication({required this.text, required this.SoundPath});
}

class EXPLICATION {
  String text; //corps
  String SoundPath; //son
  EXPLICATION({required this.text, required this.SoundPath});
}

class QuizMultiples extends StatefulWidget { //le ui et le corps des quiz multiples
  final String question;
  final String reponse1;
  final String reponse2;
  final String reponse3;
  final String reponse4;
  final int reponseCorrecte; //pour indiquer le numero de la reponse correcte
  final Indication indication;
  final EXPLICATION explication;
  final String SoundPath;
  const QuizMultiples(
      {super.key,
      required this.question,
      required this.reponse1,
      required this.reponse2,
      required this.reponse3,
      required this.reponse4,
      required this.reponseCorrecte,
      required this.indication,
      required this.explication,
      required this.SoundPath});

  @override
  State<QuizMultiples> createState() => _QuizMultiplesState();
}

class _QuizMultiplesState extends State<QuizMultiples> {
  final _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
  int? reponseUtilisateur; //la reponse d'utilisateur
  String showState = "none"; //pour afficher si vert si juste, rouge si faux ou rien si n'est pas selectionné

  Future<void> waitAndPop() async {
    await Future.delayed(const Duration(seconds: 1)); //attendre une seconde avant le retour à l'ancienne page
    if (!mounted) return;
    Navigator.pop(context, false);
    // Navigator.push(context, MaterialPageRoute(builder: ((context) => const ExplicationPage(Explication: "Explication"))));
  }

  void replay() {
    Navigator.pop(context, true);
  }

  void decoy() {}

  @override
  void initState() {
    _player.play(AssetSource(widget.SoundPath));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg-image3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20.0,
                    ),
                    InkWell(
                      onTap: () async {
                        _player.stop();
                        await Navigator.popAndPushNamed(context, '/Nquiz');
                      },
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 102, 235, 0),
                              spreadRadius: 0,
                              blurRadius: 0,
                              offset: const Offset(
                                  0, 4.2), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Container(
                            height: 35.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 102, 235, 0),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [ 
                    GamesSettings( //le boutton des parametres
                      functionToBeUsed: replay,
                      functionToResumeTimer: decoy,
                      functionToStopTimer: decoy,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                  ],
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  //le container qui contient le corps du quiz
                  height: 0.7 * MediaQuery.of(context).size.height,
                ),
                Positioned(
                  child: Center(
                    child: Container(
                      //le carré blanc qui contient les quiz
                      height: 0.7 * MediaQuery.of(context).size.height,
                      width: 0.75 * MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(33.0),
                        color: Colors.white.withValues(alpha: 0.8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withValues(alpha: 0.5),
                            offset: const Offset(0, 5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        //les reponses sont dans tous ce qui suit
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            //le container des questions
                            height: 0.2 * MediaQuery.of(context).size.height,
                            width: 0.6 * MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 242, 220, 247),
                              borderRadius: BorderRadius.circular(18.0),
                              border: Border.all(
                                color: const Color.fromARGB(255, 251, 194, 240),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(181, 44, 43, 43)
                                      .withValues(alpha: 0.5),
                                  offset: const Offset(0, 5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Center(
                                child: Text(
                              widget.question,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 218, 78, 204),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ),
                          SizedBox(
                            //le container des reponses
                            height: 0.35 * MediaQuery.of(context).size.height,
                            width: 0.5 * MediaQuery.of(context).size.width,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            reponseUtilisateur = 1;
                                            showState =
                                                widget.reponseCorrecte == 1
                                                    ? "yes"
                                                    : "no";
                                            if (showState == "yes") {
                                              _player.play(AssetSource(
                                                  'music/correct.mp3'));
                                              _player.stop();
                                            } else {
                                              _player.play(AssetSource(
                                                  'music/wrong.mp3'));
                                              _player.stop();
                                            }
                                          });
                                          await waitAndPop();
                                        },
                                        child: SizedBox(
                                          height: 0.15 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                          width: 0.21 *
                                              MediaQuery.of(context).size.width,
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 0.13 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height,
                                                width: 0.2 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  border: Border.all(
                                                    width: 2,
                                                    color: showState == "yes" &&
                                                            reponseUtilisateur ==
                                                                1
                                                        ? Colors.green
                                                        : showState == "no" &&
                                                                reponseUtilisateur ==
                                                                    1
                                                            ? Colors.red
                                                            : const Color
                                                                    .fromARGB(
                                                                255,
                                                                251,
                                                                194,
                                                                240),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Center(
                                                    child: Text(
                                                  widget.reponse1,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 218, 78, 204),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                              ),
                                              Positioned(
                                                bottom: -1,
                                                right: -1,
                                                child: showState == "yes" &&
                                                        reponseUtilisateur == 1
                                                    ? SizedBox(
                                                        height: 0.06 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height,
                                                        width: 0.03 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                        child: const Image(
                                                          image: AssetImage(
                                                              "assets/images/juste.png"),
                                                        ),
                                                      )
                                                    : showState == "no" &&
                                                            reponseUtilisateur ==
                                                                1
                                                        ? SizedBox(
                                                            height: 0.06 *
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            width: 0.03 *
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: const Image(
                                                              image: AssetImage(
                                                                  "assets/images/faux.png"),
                                                            ),
                                                          )
                                                        : Container(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            reponseUtilisateur = 2;
                                            showState =
                                                widget.reponseCorrecte == 2
                                                    ? "yes"
                                                    : "no";
                                            if (showState == "yes") {
                                              _player.play(AssetSource(
                                                  'music/correct.mp3'));
                                              _player.stop();
                                            } else {
                                              _player.play(AssetSource(
                                                  'music/wrong.mp3'));
                                              _player.stop();
                                            }
                                          });
                                          await waitAndPop();
                                          // await waitAndPop();
                                        },
                                        child: SizedBox(
                                          height: 0.15 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                          width: 0.21 *
                                              MediaQuery.of(context).size.width,
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 0.13 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height,
                                                width: 0.2 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  border: Border.all(
                                                    width: 2,
                                                    color: showState == "yes" &&
                                                            reponseUtilisateur ==
                                                                2
                                                        ? Colors.green
                                                        : showState == "no" &&
                                                                reponseUtilisateur ==
                                                                    2
                                                            ? Colors.red
                                                            : const Color
                                                                    .fromARGB(
                                                                255,
                                                                251,
                                                                194,
                                                                240),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Center(
                                                    child: Text(
                                                  widget.reponse2,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 218, 78, 204),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                              ),
                                              Positioned(
                                                bottom: -1,
                                                right: -1,
                                                child: showState == "yes" &&
                                                        reponseUtilisateur == 2
                                                    ? SizedBox(
                                                        height: 0.06 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height,
                                                        width: 0.03 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                        child: const Image(
                                                          image: AssetImage(
                                                              "assets/images/juste.png"),
                                                        ),
                                                      )
                                                    : showState == "no" &&
                                                            reponseUtilisateur ==
                                                                2
                                                        ? SizedBox(
                                                            height: 0.06 *
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            width: 0.03 *
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: const Image(
                                                              image: AssetImage(
                                                                  "assets/images/faux.png"),
                                                            ),
                                                          )
                                                        : Container(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            reponseUtilisateur = 3;
                                            showState =
                                                widget.reponseCorrecte == 3
                                                    ? "yes"
                                                    : "no";
                                            if (showState == "yes") {
                                              _player.play(AssetSource(
                                                  'music/correct.mp3'));
                                              _player.stop();
                                            } else {
                                              _player.play(AssetSource(
                                                  'music/wrong.mp3'));
                                              _player.stop();
                                            }
                                          });
                                          await waitAndPop();
                                        },
                                        child: SizedBox(
                                          height: 0.15 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                          width: 0.21 *
                                              MediaQuery.of(context).size.width,
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 0.13 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height,
                                                width: 0.2 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  border: Border.all(
                                                    width: 2,
                                                    color: showState == "yes" &&
                                                            reponseUtilisateur ==
                                                                3
                                                        ? Colors.green
                                                        : showState == "no" &&
                                                                reponseUtilisateur ==
                                                                    3
                                                            ? Colors.red
                                                            : const Color
                                                                    .fromARGB(
                                                                255,
                                                                251,
                                                                194,
                                                                240),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Center(
                                                    child: Text(
                                                  widget.reponse3,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 218, 78, 204),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                              ),
                                              Positioned(
                                                bottom: -1,
                                                right: -1,
                                                child: showState == "yes" &&
                                                        reponseUtilisateur == 3
                                                    ? SizedBox(
                                                        height: 0.06 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height,
                                                        width: 0.03 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                        child: const Image(
                                                          image: AssetImage(
                                                              "assets/images/juste.png"),
                                                        ),
                                                      )
                                                    : showState == "no" &&
                                                            reponseUtilisateur ==
                                                                3
                                                        ? SizedBox(
                                                            height: 0.06 *
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            width: 0.03 *
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: const Image(
                                                              image: AssetImage(
                                                                  "assets/images/faux.png"),
                                                            ),
                                                          )
                                                        : Container(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            reponseUtilisateur = 4;
                                            showState =
                                                widget.reponseCorrecte == 4
                                                    ? "yes"
                                                    : "no";
                                            if (showState == "yes") {
                                              _player.play(AssetSource(
                                                  'music/correct.mp3'));
                                              _player.stop();
                                            } else {
                                              _player.play(AssetSource(
                                                  'music/wrong.mp3'));
                                              _player.stop();
                                            }
                                          });
                                          await waitAndPop();
                                        },
                                        child: SizedBox(
                                          height: 0.15 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                          width: 0.21 *
                                              MediaQuery.of(context).size.width,
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 0.13 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height,
                                                width: 0.2 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  border: Border.all(
                                                    width: 2,
                                                    color: showState == "yes" &&
                                                            reponseUtilisateur ==
                                                                4
                                                        ? Colors.green
                                                        : showState == "no" &&
                                                                reponseUtilisateur ==
                                                                    4
                                                            ? Colors.red
                                                            : const Color
                                                                    .fromARGB(
                                                                255,
                                                                251,
                                                                194,
                                                                240),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Center(
                                                    child: Text(
                                                  widget.reponse4,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 218, 78, 204),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                              ),
                                              Positioned(
                                                bottom: -1,
                                                right: -1,
                                                child: showState == "yes" &&
                                                        reponseUtilisateur == 4
                                                    ? SizedBox(
                                                        height: 0.06 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height,
                                                        width: 0.03 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                        child: const Image(
                                                          image: AssetImage(
                                                              "assets/images/juste.png"),
                                                        ),
                                                      )
                                                    : showState == "no" &&
                                                            reponseUtilisateur ==
                                                                4
                                                        ? SizedBox(
                                                            height: 0.06 *
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            width: 0.03 *
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: const Image(
                                                              image: AssetImage(
                                                                  "assets/images/faux.png"),
                                                            ),
                                                          )
                                                        : Container(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 20.0,
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          _player.stop();
                          _player.play(AssetSource(widget.SoundPath));
                        });
                      },
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(255, 210, 23, 1),
                              spreadRadius: 0,
                              blurRadius: 0,
                              offset: const Offset(
                                  0, 4.2), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Container(
                            height: 35.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 210, 23, 1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.volume_up,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        //aaaaaaa
                        Indi = true;
                        setState(() {
                          _player.stop();
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PageIndication(
                                  indica: widget.indication.text,
                                  SoundPath: widget.indication.SoundPath),
                            ));
                      },
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(255, 210, 23, 1),
                              spreadRadius: 0,
                              blurRadius: 0,
                              offset: const Offset(
                                  0, 4.2), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Container(
                            height: 35.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 210, 23, 1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.help,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PageIndication extends StatefulWidget {
  final String indica;
  final String SoundPath;
  const PageIndication(
      {super.key, required this.indica, required this.SoundPath});

  @override
  State<PageIndication> createState() => _PageIndicationState();
}

class _PageIndicationState extends State<PageIndication> {
  final _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    _player.play(AssetSource(widget.SoundPath));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/bg-image3.png"),
        fit: BoxFit.cover,
      )),
      child: Center(
        child: Container(
          height: 0.8 * MediaQuery.of(context).size.height,
          width: 0.7 * MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/forme.png"),
          )),
          child: Column(
            children: [
              SizedBox(
                height: 0.2 * MediaQuery.of(context).size.height,
              ),
              SizedBox(
                //le text de l'indication
                height: 0.35 * MediaQuery.of(context).size.height,
                width: 0.4 * MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    widget.indica,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 18, 2, 81),
                      fontFamily: "Digitalt",
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                    {Navigator.pop(context), _player.stop(), Indi = false},
                child: Stack(
                  children: [
                    Container(
                      //le grand container vert
                      height: 35.0,
                      width: 86.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: const Color.fromARGB(
                            255, 145, 245, 64), //secondaire
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
                          color: const Color.fromARGB(
                              255, 102, 235, 0), //principal
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                            child: Text(
                              "OK",
                              style: TextStyle(
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
                ),
              ),
              InkWell(
                onTap: () {
                  _player.stop();
                  _player.play(AssetSource(widget.SoundPath));
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(255, 210, 23, 1),
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset:
                            const Offset(0, 4.2), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Container(
                      height: 35.0,
                      width: 35.0,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 210, 23, 1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.volume_up,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
