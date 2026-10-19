import 'package:flutter/material.dart';
import 'package:sorttrash/button.dart';
import 'package:sorttrash/histoires/storydesign.dart';
import 'package:video_player/video_player.dart';

import '../StartPage/settings.dart';

class levelsStory extends StatefulWidget {
  final List<dynamic> histoires = [
    storyDesign(storys: [
      Histoire(
          text:
              "Nemo, un petit poisson-clown, et ses amis Dory, une demoiselle bleue étourdie, et Marlin, le père protecteur de Nemo, vivent au milieu des coraux dans l'océan. Ils jouent et s'amusent, heureux de leur vie sous-marine.",
          picture: "assets/images/storys/nemo1.png",
          SoundPath: "music/histoires/story1/chap1Nemo.m4a"),
      Histoire(
          text:
              "Nemo et ses amis vivaient heureux dans les coraux de l'océan. Chaque jour, ils jouaient et s'amusaient dans leur petit paradis aquatique. Ils avaient toutes sortes de jeux et de divertissements, comme courir après les bulles, chasser les petits poissons, ou simplement se détendre en admirant la beauté des coraux.",
          picture: "assets/images/storys/nemo2.png",
          SoundPath: "music/histoires/story1/chap2Nemo.m4a"),
      Histoire(
          text:
              "Nemo et ses amis ont remarqué la présence de débris de plastique dans leur environnement de corail. Marlin, inquiet, a décidé d'enquêter pour découvrir d'où venait cette pollution. Avec l'aide de ses amis, ils ont suivi les débris de plastique et ont finalement atteint une grande usine sur le bord de l'océan, qui était la source de la pollution.",
          picture: "assets/images/storys/nemo3.png",
          SoundPath: "music/histoires/story1/chap3Nemo.m4a"),
      Histoire(
          text:
              "La première tentative de persuasion Nemo et ses amis décident de parler à monsieur Philippe Sherman le chef de l’usine pour le convaincre de cesser de polluer la mer. Ils lui demandent d'arrêter l'usine car jeter les déchets en mer est la solution la moins coûteuse. Mais Philippe refuse.",
          picture: "assets/images/storys/nemo4.png",
          SoundPath: "music/histoires/story1/chap4Nemo.m4a"),
      Histoire(
          text:
              "La deuxième tentative de persuasion Nemo et ses amis décident d'essayer une approche différente. Ils suggèrent à Philippe de recycler les déchets au lieu de les jeter en mer. Mais il refuse à cause du coût trop élevé.",
          picture: "assets/images/storys/nemo5.png",
          SoundPath: "music/histoires/story1/chap5Nemo.m4a"),
      Histoire(
          text:
              "La troisième tentative de persuasion Nemo et ses amis décident de montrer l'impact de ses actions à Philippe en lui ramenant des jarres d'eau polluée extraite de leur habitat. Il est choqué de voir l'étendue de la pollution et réalise l'importance de protéger l'environnement.",
          picture: "assets/images/storys/nemo6.png",
          SoundPath: "music/histoires/story1/chap6Nemo.m4a"),
      Histoire(
          text:
              "La prise de conscience Philippe Sherman réalise qu'il a fait une erreur en polluant la mer. Il décide qu'il doit changer ses méthodes et faire sa part pour protéger l'environnement.",
          picture: "assets/images/storys/nemo7.png",
          SoundPath: "music/histoires/story1/chap7Nemo.m4a"),
      Histoire(
          text:
              "Philippe Sherman met en place de nouvelles pratiques pour recycler les déchets de son usine et éviter de polluer la mer.Nemo revient à l'océan pour annoncer la bonne nouvelle à ses amis.",
          picture: "assets/images/storys/nemo8.png",
          SoundPath: "music/histoires/story1/chap8Nemo.m4a"),
      Histoire(
          text:
              "La célébration de la victoire Nemo et ses amis célèbrent leur victoire avec tous les animaux de l'océan. Ils sont heureux de voir que leur habitat est plus propre et plus sûr grâce à leur détermination à protéger l'environnement.",
          picture: "assets/images/storys/nemo9.png",
          SoundPath: "music/histoires/story1/chap9Nemo.m4a"),
    ]),
    VideoPlayerWidget(videoPath: 'assets/Videos/video1.mp4'),
    VideoPlayerWidget(videoPath: 'assets/Videos/video2.mp4'),
    VideoPlayerWidget(videoPath: 'assets/Videos/video3.mp4'),
    VideoPlayerWidget(videoPath: 'assets/Videos/video4.mp4'),
    VideoPlayerWidget(videoPath: 'assets/Videos/video5.mp4'),
  ];
  int nbrKeys;

  levelsStory({
    super.key,
    required this.nbrKeys,
  });

  @override
  State<levelsStory> createState() => _levelsStoryState();
}

class _levelsStoryState extends State<levelsStory> {
  late List<bool> hasEnoughKeys;

  // bool hasEnoughKeys = false;
  @override
  @override
  void initState() {
    hasEnoughKeys = List.generate(widget.histoires.length, (index) => false);
    globalMusicPlayerStartPage.stop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.nbrKeys >= 1) {
      hasEnoughKeys[0] = true;
    }
    if (widget.nbrKeys >= 5) {
      hasEnoughKeys[1] = true;
    }
    if (widget.nbrKeys >= 10) {
      hasEnoughKeys[2] = true;
    }
    if (widget.nbrKeys >= 14) {
      hasEnoughKeys[3] = true;
    }
    if (widget.nbrKeys >= 19) {
      hasEnoughKeys[4] = true;
    }
    if (widget.nbrKeys >= 24) {
      hasEnoughKeys[5] = true;
    }
    return Scaffold(
      body: Container(
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
                  child: const Center(
                    child: RoundButton(
                      href: '/',
                      myIcon: Icons.arrow_back,
                      couleur: Color.fromARGB(255, 102, 235, 0),
                      shadowColor: Color.fromARGB(255, 102, 235, 0),
                    ),
                  ),
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
                      children: const [
                        RoundButton(
                          href: '/',
                          myIcon: Icons.home,
                          couleur: Color.fromRGBO(255, 210, 23, 1),
                          shadowColor: Color.fromRGBO(255, 210, 23, 1),
                        ), //le premier button
                      ]),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 0.7 * MediaQuery.of(context).size.height,
            width: 0.7 * MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (hasEnoughKeys[0]) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => widget.histoires[0],
                            ),
                          );
                        } else {
                          // Handle case when user doesn't have enough keys
                        }
                      },
                      child: Image(
                        image: AssetImage(hasEnoughKeys[0]
                            ? "assets/images/book1.png"
                            : "assets/images/book1closed.png"), // Change image based on keys
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (hasEnoughKeys[1]) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => widget.histoires[1],
                            ),
                          );
                        } else {
                          // Handle case when user doesn't have enough keys
                        }
                      },
                      child: Image(
                        image: AssetImage(hasEnoughKeys[1]
                            ? "assets/images/book2open.png"
                            : "assets/images/book2.png"), // Change image based on keys
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (hasEnoughKeys[2]) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => widget.histoires[2],
                            ),
                          );
                        } else {
                          // Handle case when user doesn't have enough keys
                        }
                      },
                      child: Image(
                        image: AssetImage(hasEnoughKeys[2]
                            ? "assets/images/book3open.png"
                            : "assets/images/book3.png"), // Change image based on keys
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (hasEnoughKeys[3]) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => widget.histoires[3],
                            ),
                          );
                        } else {
                          // Handle case when user doesn't have enough keys
                        }
                      },
                      child: Image(
                        image: AssetImage(hasEnoughKeys[3]
                            ? "assets/images/book4open.png"
                            : "assets/images/book4.png"), // Change image based on keys
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (hasEnoughKeys[4]) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => widget.histoires[4],
                            ),
                          );
                        } else {
                          // Handle case when user doesn't have enough keys
                        }
                      },
                      child: Image(
                        image: AssetImage(hasEnoughKeys[4]
                            ? "assets/images/book5open.png"
                            : "assets/images/book5.png"), // Change image based on keys
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (hasEnoughKeys[5]) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => widget.histoires[5],
                            ),
                          );
                        } else {
                          // Handle case when user doesn't have enough keys
                        }
                      },
                      child: Image(
                        image: AssetImage(hasEnoughKeys[5]
                            ? "assets/images/book6open.png"
                            : "assets/images/book6.png"), // Change image based on keys
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({super.key, required this.videoPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoFuture;
  bool _isVideoComplete = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(widget.videoPath);
    _initializeVideoFuture = _videoController.initialize();
    _videoController.play();

    _videoController.addListener(() {
      if (_videoController.value.position >= _videoController.value.duration) {
        // Video is complete
        setState(() {
          _isVideoComplete = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _replayVideo() {
    _videoController.seekTo(Duration.zero);
    _videoController.play();

    setState(() {
      _isVideoComplete = false; // Reset the flag
    });

    _videoController.removeListener(
        _checkVideoCompletion); // Remove the listener temporarily

    _videoController.addListener(
        _checkVideoCompletion); // Add the listener back after replaying
  }

  void _checkVideoCompletion() {
    setState(() {
      _isVideoComplete = true;
    });
  }

  void _exitVideo() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: _initializeVideoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                // alignment: Alignment.center,       
                child: AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        Visibility(
          visible: _isVideoComplete,
          child: Positioned(
            left: 0,
            right: 0,
            bottom: 16.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _replayVideo,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.purpleAccent), // Set the desired color

                    textStyle: WidgetStateProperty.all<TextStyle>(
                      TextStyle(
                        fontSize: 16, // Set the desired font size
                        fontWeight:
                            FontWeight.bold, // Set the desired font weight
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: Text('Replay'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _exitVideo,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.purpleAccent), // Set the desired color

                    textStyle: WidgetStateProperty.all<TextStyle>(
                      TextStyle(
                        fontSize: 16, // Set the desired font size
                        fontWeight:
                            FontWeight.bold, // Set the desired font weight
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: Text('Exit'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
