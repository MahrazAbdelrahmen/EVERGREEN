import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/StartPage/settings.dart';

import '../defis/key_container.dart';

class BravoPage extends StatefulWidget {
  const BravoPage({super.key, required this.score});
  final int score;
  @override
  State<BravoPage> createState() => _BravoPageState();
}

class _BravoPageState extends State<BravoPage> {
  @override
  void initState() {
    setState((){
      globalMusicPlayerStartPage.stop();
      globalSoundPlayerStartPage.play(AssetSource("music/finishedgame.mp3"));
    });
    super.initState();
  }
  @override
  void dispose() {
    globalSoundPlayerStartPage.stop();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg-image2.png'),
              fit: BoxFit.fill),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                height: 0.6*MediaQuery.of(context).size.height,
                width: 0.5*MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
            ),

            Center(
              child: Container(
                height: 0.52*MediaQuery.of(context).size.height,
                width: 0.25*MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(0, 7), // changes position of shadow
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    SizedBox(height: 0.17*MediaQuery.of(context).size.height,),
                    const Text('Score', textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(96,207,255,1), fontWeight: FontWeight.bold, fontFamily: 'Digital', fontSize: 20), ),
                    const SizedBox(height: 10,),
                    Center(child : Container(
                      width: 0.2*MediaQuery.of(context).size.width,
                      height:0.12*MediaQuery.of(context).size.height ,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(194,253,255,1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 10,),
                          Container(
                            height: 40,
                            width: 45,
                            decoration: const BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/images/coin_img.png"), fit: BoxFit.fill)
                            ),
                          ),
                          const SizedBox(width: 20,),
                           Text(widget.score.toString(), style: const TextStyle(color: Color.fromRGBO(34, 138, 237, 1), fontSize: 17, fontFamily: 'Digital', fontWeight: FontWeight.bold),)
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0.732*MediaQuery.of(context).size.height,
              top: 0.06468*MediaQuery.of(context).size.width,
              child: Container(
                width: 0.32*MediaQuery.of(context).size.width,
                height:0.22*MediaQuery.of(context).size.height ,
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(image: AssetImage( "assets/images/header(2).png"), fit: BoxFit.fill)
                ),
              ),
            ),
            Positioned(
                left: 0.42*MediaQuery.of(context).size.width,
                top: 0.694444*MediaQuery.of(context).size.height,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: sm1,
                        side: const BorderSide(width: 3, color: Colors.white),
                        elevation: 0,
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding:
                        EdgeInsets.only(left: 0.0387*MediaQuery.of(context).size.width, right: 0.0387*MediaQuery.of(context).size.width, top: 8, bottom: 10)),
                    onPressed: (){
                        setState(() {
                          globalSoundPlayerStartPage.stop();
                          globalMusicPlayerStartPage.resume();
                        });
                        Navigator.pushNamed(context, '/');
                    }, child: const Text('Terminé')))
          ],
        ),
      ),
    );
  }
}
