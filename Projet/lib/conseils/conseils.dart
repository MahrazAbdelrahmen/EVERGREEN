import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../StartPage/settings.dart';


class advice {
  final String titre;
  final String contenu;
  final String SoundPath;
  advice({required this.titre, required this.contenu, required this.SoundPath});
}

class Conseils extends StatefulWidget {
  List<advice> cons = [
    advice(
      titre: "INTRODUCTION",
      contenu:
          "Bonjour à tous ! Je suis votre chère Terry, votre planète, votre maison. ",
      SoundPath: "music/Introduction1.m4a",
    ),
    advice(
        titre: "INTRODUCTION",
        SoundPath: "music/Introduction2.m4a",
        contenu:
            "Je suis ravie de vous parler aujourd'hui de quelque chose qui me tient particulièrement à cœur : le recyclage. "),
    advice(
        titre: "INTRODUCTION",
        SoundPath: "music/Introduction3.m4a",
        contenu:
            "Malheureusement, je souffre de plus en plus  chaque  jour à cause des  tonnes de déchets que vous produisez,  car ils polluent mes océans, mes rivières, mes forêts et mon air."),
    advice(
        titre: "INTRODUCTION",
        SoundPath: "music/Introduction4.m4a",
        contenu:
            "Je vous demande donc de faire un geste important pour moi : recycler."),
    advice(
        titre: "RECYCLAGE",
        SoundPath: "music/Recyclage.m4a",
        contenu:
            "Le recyclage est un moyen de réutiliser les choses que nous avons déjà utilisées afin que nous n'ayons pas à fabriquer de nouvelles choses à partir de zéro."),
    advice(
        titre: "TRI",
        SoundPath: "music/tri.m4a",
        contenu:
            "Maintenant ,On va ensemble apprendre comment trier et classer chaque déchet dans sa propre poubelle?"),
    advice(
        titre: "COMPOST",
        SoundPath: "music/COMPOST.m4a",
        contenu:
            "COULEUR DE POUBELLE: Gris\nSes déchets: déchets verts,restes de repas.\nIndication: Jette-les en vrac dans le composteur de ton jardin. Il y a aussi des composteurs à disposition dans ta ville !"),
    advice(
        titre: "PLASTIQUE",
        SoundPath: "music/PLASTIQUE.m4a",
        contenu:
            "COULEUR DE POUBELLE: Orange\nSes déchets: boîtes de conserve,bouteilles et flacons en plastique,sachets\nIndication :Jette-les en vrac, vidés de leur contenu,avec leurs bouchons."),
    advice(
        titre: "VERRE",
        SoundPath: "music/VERRE.m4a",
        contenu:
            "COULEUR DE POUBELLE: Vert\nSes déchets: bouteille, bocaux et flacons\nIndication: Jette-les en vrac, lavés, sans bouchon ou couvercle."),
    advice(
        titre: "PAPIER ET CARTON",
        SoundPath: "music/CARTON.m4a",
        contenu:
            "COULEUR DE POUBELLE: Bleu\nSes déchets: briques alimentaires et petits cartons,feuilles,magazines et journaux,livres,cahiers et enveloppes\nIndication :Jette-les en vrac, vidés de leur contenu,aplatis et compactés "),
    advice(
        titre: "METAL",
        SoundPath: "music/METAL.m4a",
        contenu:
            "COULEUR DE POUBELLE: Jaune\nSes déchets: barquettes en aluminium et emballages métalliques \nIndication: Jette-les en vrac, vidés de leur contenu,avec leurs bouchons."),
    advice(
        titre: "ELECTRONIQUE",
        SoundPath: "music/ELECTRONIQUE.m4a",
        contenu:
            "COULEUR DE POUBELLE: Rouge\nSes déchets: Lampes,calclatrice cassées,Micro-onde et PC."),

// advice(titre: titre,SoundPath: audio, contenu: contenu),
// advice(titre: titre,SoundPath: audio, contenu: contenu),
//Quoi recycler?
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI1.m4a",
        contenu:
            "Recyclez du papier contenant des agrafes ou des enveloppes en plastique. Le métal et le plastique sont finalement triés."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI2.m4a",
        contenu:
            "Recyclez les piles usagées en les déposant dans un point de collecte approprié. Ne les jetez jamais à la poubelle ordinaire."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI3.m4a",
        contenu:
            "Recyclez les publicités non sollicitées. La plupart des adultes en reçoivent de grandes quantités chaque semaine et la plupart peuvent être recyclées."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI4.m4a",
        contenu:
            "Retirez les bouchons de toutes les bouteilles en verre. Vérifiez également si votre communauté prend le verre des conteneurs de recyclage sur le trottoir."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI5.m4a",
        contenu:
            "Rincez les canettes en aluminium et en acier pour les rendre plus faciles à traiter."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI6.m4a",
        contenu: "Recyclez les aérosols vides et les cintres en métal."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI7.m4a",
        contenu:
            "Recyclez les vieux appareils électroniques en les apportant dans un centre de recyclage. Cela permet de récupérer les matériaux précieux qu'ils contiennent."),
    advice(
        titre: "QUOI RECYCLER?",
        SoundPath: "music/QUOI8.m4a",
        contenu:
            "Recyclez les cartouches d'encre en les renvoyant au fabricant. Cela peut aider à réduire les déchets toxiques qui se retrouvent dans les décharges."),

//Pourquoi recycler?
    advice(
        titre: "POURQUOI ?",
        SoundPath: "music/POURQUOI1.m4a",
        contenu:
            "En recyclant, nous aidons à réduire la quantité de déchets que nous produisons et à garder notre planète propre."),
    advice(
        titre: "POURQUOI ?",
        SoundPath: "music/POURQUOI2.m4a",
        contenu:
            "Le recyclage peut économiser de l'énergie, de l'eau et des ressources naturelles qui seraient autrement utilisées pour créer de nouveaux produits."),
    advice(
        titre: "POURQUOI ?",
        SoundPath: "music/POURQUOI3.m4a",
        contenu:
            "En recyclant, nous pouvons réduire la quantité de pollution dans l'air, l'eau et le sol."),
    advice(
        titre: "POURQUOI ?",
        SoundPath: "music/POURQUOI4.m4a",
        contenu:
            "Grâce au tri, les déchets peuvent être recyclés et avoir une seconde vie."),
    advice(
        titre: "POURQUOI ?",
        SoundPath: "music/POURQUOI5.m4a",
        contenu:
            "En recyclant, vous faites votre part pour aider à protéger l'environnement pour les générations futures."),
    advice(
        titre: "POURQUOI ?",
        SoundPath: "music/POURQUOI6.m4a",
        contenu:
            "Le recyclage est facile et amusant ! Vous pouvez transformer les vieux objets en nouveaux objets et faire preuve de créativité avec vos projets d'art."),

//CONSEILS
    advice(
        titre: "CONSEIL 01",
        SoundPath: "music/CONSEIL1.m4a",
        contenu:
            "Faites attention aux symboles de recyclage sur les emballages. Ils vous indiquent quel type de matériau a été utilisé et s'il peut être recyclé."),
    advice(
        titre: "CONSEIL 02",
        SoundPath: "music/CONSEIL2.m4a",
        contenu:
            "Réduisez les déchets de nourriture en achetant seulement ce dont vous avez besoin et en utilisant les restes pour les repas suivants."),
    advice(
        titre: "CONSEIL 03",
        SoundPath: "music/CONSEIL3.m4a",
        contenu:
            "Évitez d'acheter des articles jetables pour les fêtes et les événements. Au lieu de cela, utilisez de la vaisselle et des serviettes réutilisables."),
    advice(
        titre: "CONSEIL 04",
        SoundPath: "music/CONSEIL4.m4a",
        contenu:
            "Séparez les couvercles et les bocaux, les cartons et les bouteilles afin que les conteneurs puissent être facilement écrasés lors du recyclage."),
    advice(
        titre: "CONSEIL 05",
        SoundPath: "music/CONSEIL5.m4a",
        contenu:
            "Séparez les déchets électroniques. La plupart peuvent être recyclés, mais ils doivent généralement être apportés à un centre de recyclage et non placés dans des conteneurs sur le trottoir."),
    advice(
        titre: "CONSEIL 06",
        SoundPath: "music/CONSEIL6.m4a",
        contenu:
            "Réutilisez les objets avant de les recycler. Par exemple, utilisez des bocaux vides comme contenants pour vos crayons ou utilisez des vieux vêtements pour faire des chiffons."),
    advice(
        titre: "CONSEIL 07",
        SoundPath: "music/CONSEIL7.m4a",
        contenu:
            "Évitez d'utiliser des produits jetables comme des couverts ou des pailles en plastique. Au lieu de cela, apportez vos propres objets réutilisables avec vous."),
    advice(
        titre: "CONSEIL 08",
        SoundPath: "music/CONSEIL8.m4a",
        contenu:
            "Assurez-vous de disposer correctement des matériaux dangereux tels que les batteries et les appareils électroniques. Ils nécessitent une manipulation spéciale pour éviter les dommages environnementaux."),
    advice(
        titre: "CONSEIL 10",
        SoundPath: "music/CONSEIL09.m4a",
        contenu:
            "Essayez d'acheter des produits fabriqués à partir de matériaux recyclés. Cela soutient l'industrie du recyclage et contribue à boucler la boucle."),
    advice(
        titre: "CONSEIL 11",
        SoundPath: "music/CONSEIL10.m4a",
        contenu:
            "Envisagez de composter les restes de nourriture et les déchets de jardin. Cela peut aider à réduire la quantité de déchets envoyés dans les décharges."),

//FIN
    advice(
        titre: "FIN",
        SoundPath: "music/FIN1.m4a",
        contenu:
            "Soyez un modèle pour les autres en recyclant régulièrement et en parlant des avantages du recyclage avec votre famille et vos amis."),
    advice(
        titre: "FIN",
        SoundPath: "music/FIN2.m4a",
        contenu:
            "Continuez à apprendre sur le recyclage et les problèmes environnementaux. Plus vous en savez, plus vous pouvez faire pour aider à protéger notre planète."),
    advice(
        titre: "FIN",
        SoundPath: "music/FIN3.m4a",
        contenu:
            "Rappelez-vous que le recyclage n'est qu'une partie de l'équation. Nous devons également chercher à réduire la quantité de déchets que nous produisons et réutiliser les objets chaque fois que possible."),
  ];
  int currentAdvice = 0;

  Conseils({super.key});
  @override
  State<Conseils> createState() => _ConseilsState();
}

class _ConseilsState extends State<Conseils> {
  bool isSignedIn = false;
  final _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    globalMusicPlayerStartPage.stop();
    _player.play(AssetSource(widget.cons[0].SoundPath));
    if (user != null) {
      if (!user!.emailVerified) {
        setState(() {
          user!.delete();
          FirebaseAuth.instance.signOut();
        });
      } else {
        setState(() {
          isSignedIn = true;
        });
      }
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg-image2.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Container(
              alignment: Alignment.center,
              height: 0.88 * MediaQuery.of(context).size.height,
              // width: ,
              // color: Colors.amber,
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
                              await Navigator.popAndPushNamed(context, '/');
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
                                        offset: const Offset(0, 4.2), // changes position of shadow
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
                          // isSignedIn
                          //     ? RoundButtonSettingsWhileLogged(
                          //         myIcon: Icons.settings, value: 5)
                          //     : RoundButtonSettings(
                          //         myIcon: Icons.settings, value: 5),
                          const SizedBox(
                            width: 20.0,
                          ),
                        ],
                      ),
                    ],
                  ), //les bouttons en haut
                  SizedBox(
                    //debut de corps de conseils
                    height: 0.67 * MediaQuery.of(context).size.height,
                    width: 0.6 * MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 0.1 * MediaQuery.of(context).size.height,
                            ),
                            InkWell(
                              onTap: () {
                                if ((widget.currentAdvice != 0)) {
                                  setState(() {
                                    widget.currentAdvice -= 1;
                                    _player.play(AssetSource(widget
                                        .cons[widget.currentAdvice].SoundPath));
                                  });
                                }
                              },
                              child: Container(
                                child: (widget.currentAdvice != 0)
                                    ? const Image(
                                        image: AssetImage(
                                            "assets/images/leftbutton.png"),
                                      )
                                    : Container(),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              //le contenu
                              width: 0.5 * MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(21.0),
                              ),
                              child: Center(
                                child: Container(
                                  height:
                                      0.54 * MediaQuery.of(context).size.height,
                                  width:
                                      0.45 * MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Color.fromARGB(255, 76, 218, 254),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      height: 0.35 *
                                          MediaQuery.of(context).size.height,
                                      width: 0.4 *
                                          MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: Text(
                                          widget.cons[widget.currentAdvice].contenu,
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Color.fromARGB(
                                                255, 118, 120, 120),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0.015 * MediaQuery.of(context).size.height,
                              left: 0.15 * MediaQuery.of(context).size.width,
                              child: Container(
                                height:
                                    0.12 * MediaQuery.of(context).size.height,
                                width: 0.2 * MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 76, 218, 254),
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        widget.cons[widget.currentAdvice].titre,
                                        style: const TextStyle(
                                          fontFamily: 'Digital',
                                          color: Colors.white,
                                          fontSize: 25.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0.02 * MediaQuery.of(context).size.height,
                              left: 0.05 * MediaQuery.of(context).size.width,
                              child: const Image(
                                image: AssetImage("assets/images/pointsh.png"),
                              ),
                            ),
                            Positioned(
                              top: 0.2 * MediaQuery.of(context).size.height,
                              right: 0.01 * MediaQuery.of(context).size.width,
                              child: const Image(
                                image: AssetImage("assets/images/pointsv.png"),
                              ),
                            ),
                            Positioned(
                              top: 0.4 * MediaQuery.of(context).size.height,
                              right: 0.01 * MediaQuery.of(context).size.width,
                              child: const Image(
                                image: AssetImage("assets/images/logo1.png"),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 0.1 * MediaQuery.of(context).size.height,
                            ),
                            InkWell(
                              onTap: () {
                                if ((widget.currentAdvice !=
                                    widget.cons.length - 1)) {
                                  setState(() {
                                    widget.currentAdvice += 1;
                                    _player.play(AssetSource(widget
                                        .cons[widget.currentAdvice].SoundPath));
                                  });
                                }
                              },
                              child: Container(
                                child: (widget.currentAdvice !=
                                        widget.cons.length - 1)
                                    ? Image(
                                        image: AssetImage(
                                            "assets/images/rightbutton.png"),
                                      )
                                    : Container(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ), //le corps du conseils
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
