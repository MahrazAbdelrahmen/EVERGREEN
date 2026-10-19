import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../composents/game_settings.dart';

class Histoire {
  String text;
  String picture;
  String SoundPath;
  Histoire(
      {required this.text, required this.picture, required this.SoundPath});
}

class storyDesign extends StatefulWidget {
  final List<Histoire> storys;
  const storyDesign({super.key, required this.storys});
  @override
  State<storyDesign> createState() => _storyDesignState();
}

class _storyDesignState extends State<storyDesign> {
  final _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
  int CurrentIndex = 0;
  void replay() {
    setState(() {
      CurrentIndex = 0;
    });
  }

  void decoy() {}
  @override
  void initState() {
    _player.play(AssetSource(widget.storys[0].SoundPath));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //le container qui contient le bg image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          SizedBox(
            height: 0.02 * MediaQuery.of(context).size.height,
          ),
          Row(
            //les bouttons au-dessus
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  height: 60.0,
                  width: 60.0,
                  child: Center(
                      child: InkWell(
                    onTap: () async {
                      setState(() {
                        _player.stop();
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.green,
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset:
                                Offset(0, 4.2), // changes position of shadow
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
                            color: Colors.green,
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
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5.0, 15.0, 0.0),
                child: SizedBox(
                  //pour creer un alignement des elements
                  height: 60.0,
                  width: 60.0,
                  // color: Colors.amber,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GamesSettings(
                          functionToBeUsed: replay,
                          functionToResumeTimer: decoy,
                          functionToStopTimer: decoy,
                        ), //le premier button
                      ]),
                ),
              ),
            ],
          ),
          SizedBox(
            //le corps des histoires
            height: 0.8 * MediaQuery.of(context).size.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 0.09 * MediaQuery.of(context).size.width,
                  child: (CurrentIndex != 0)
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              _player.stop();
                              CurrentIndex--;
                              _player.play(AssetSource(
                                  widget.storys[CurrentIndex].SoundPath));
                            });
                          },
                          child: const Image(
                            image: AssetImage("assets/images/leftStory.png"),
                          ),
                        )
                      : Container(),
                ),
                Container(
                  width: 0.6 * MediaQuery.of(context).size.width,
                  height: 0.8 * MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/book.png"),
                  )),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 0.25 * MediaQuery.of(context).size.width,
                          height: 0.7 * MediaQuery.of(context).size.height,
                          child: (CurrentIndex % 2 != 0)
                              ? Image(
                                  image: AssetImage(
                                      widget.storys[CurrentIndex].picture),
                                )
                              : Center(
                                  child: Text(
                                    widget.storys[CurrentIndex].text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "Digital",
                                      height: 1.2,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(
                          width: 0.25 * MediaQuery.of(context).size.width,
                          height: 0.7 * MediaQuery.of(context).size.height,
                          child: (CurrentIndex % 2 == 0)
                              ? Image(
                                  image: AssetImage(
                                      widget.storys[CurrentIndex].picture),
                                )
                              : Center(
                                  child: Text(
                                    widget.storys[CurrentIndex].text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "Digital",
                                      height: 1.2,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 0.09 * MediaQuery.of(context).size.width,
                  child: (CurrentIndex != widget.storys.length - 1)
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              _player.stop();
                              CurrentIndex++;
                              _player.play(AssetSource(
                                  widget.storys[CurrentIndex].SoundPath));
                            });
                          },
                          child: const Image(
                            image: AssetImage("assets/images/rightStory.png"),
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
