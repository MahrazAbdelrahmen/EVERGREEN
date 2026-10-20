import 'package:sorttrash/player_box.dart';
import 'package:sorttrash/quiz/quizgestes.dart';
import 'package:sorttrash/quiz/quizmultiples.dart';
import 'package:sorttrash/quiz/quizphotos.dart';
import '../BackEnd/DataBaseService/local_data_base_service.dart';
import 'level.dart';

class Management { //la classe pour faire la gestion de niveau de quiz 
  DataBaseService dataBaseService =
      currentProfileIndex == 1 ? offlineProgress : onlineProgress;
  late Level level1 = Level(
    levelIndex: 0,
    changeBooleanStatus: level2.setIsLocked,
    isLocked: dataBaseService.returnLockedState(0, 2),
    liste: [
      QuizPhotosDesign(
        quizPhotos: QuizPhotos(
          question: "Les boîtes à chaussures vides sont transformées en :",
          photoQuestion: "assets/images/quiz/niveau1/Q1.png",
          reponse1: "Boite de céréales",
          photo1: "assets/images/quiz/niveau1/Q1_3.png",
          reponse2: "Cartons de déménagement",
          photo2: "assets/images/quiz/niveau1/Q1_1.png",
          reponse3: "Papier toilettes",
          photo3: "assets/images/quiz/niveau1/Q1_2.png",
          reponse4: "Sac à dos",
          photo4: "assets/images/quiz/niveau1/Q1_4.png",
          reponseCorrecte: 2,
          explication: EXPLICATION(
              text:
                  "Il est possible que les boîtes à chaussures vides soient transformées en cartons de déménagement, car elles peuvent être de taille pratique pour transporter des objets tels que des livres ou des vêtements. Cependant, les autres options sont également possibles en fonction de l'imagination et des besoins de chacun.",
              SoundPath: "music/n1q1Exp.m4a"),
          SoundPath: "music/n1q1.m4a",
        ),
      ),
      QuizPhotosDesign(
        quizPhotos: QuizPhotos(
          question: "Les bouteilles en plastique vides sont transformées en :",
          photoQuestion: "assets/images/quiz/niveau1/Q2.png",
          reponse1: "Veste polaire",
          photo1: "assets/images/quiz/niveau1/Q2_1.png",
          reponse2: "Moquette",
          photo2: "assets/images/quiz/niveau1/Q2_2.png",
          reponse3: "Nourriture",
          photo3: "assets/images/quiz/niveau1/Q2_3.png",
          reponse4: "Nouvelles bouteilles",
          photo4: "assets/images/quiz/niveau1/Q2_4.png",
          reponseCorrecte: 4,
          explication: EXPLICATION(
              text:
                  "Le plastique recyclé est broyé en petits morceaux, nettoyé, fondu, puis transformé en granulés qui peuvent être utilisés pour fabriquer de nouveaux produits en plastique, y compris des bouteilles. Le recyclage des bouteilles en plastique permet d'économiser des matières premières et de réduire la quantité de déchets plastiques qui se retrouvent dans l'environnement.",
              SoundPath: "music/n1q2Exp.m4a"),
          SoundPath: "music/n1q2.m4a",
        ),
      ),
      QuizPhotosDesign(
        quizPhotos: QuizPhotos(
          question: "Le vieux matelas est transformé en :",
          photoQuestion: "assets/images/quiz/niveau1/Q3.png",
          reponse1: "Tapis de sport",
          photo1: "assets/images/quiz/niveau1/Q3_1.png",
          reponse2: "Lampe",
          photo2: "assets/images/quiz/niveau1/Q3_2.png",
          reponse3: "Carton",
          photo3: "assets/images/quiz/niveau1/Q3_3.png",
          reponse4: "Siège de voiture",
          photo4: "assets/images/quiz/niveau1/Q3_4.png",
          reponseCorrecte: 1,
          explication: EXPLICATION(
              text:
                  "Le vieux matelas est souvent transformé en tapis de sport car sa texture dense et résistante est idéale pour les activités physiques. Les fabricants de tapis de sport peuvent récupérer la mousse, le latex et les autres matériaux du matelas pour créer un produit de qualité.",
              SoundPath: "music/n1q3Exp.m4a"),
          SoundPath: "music/n1q3.m4a",
        ),
      ),
      QuizPhotosDesign(
        quizPhotos: QuizPhotos(
          question: "Les pommes pourries sont transformées en :",
          photoQuestion: "assets/images/quiz/niveau1/Q4.png",
          reponse1: "Compote",
          photo1: "assets/images/quiz/niveau1/Q4_1.png",
          reponse2: "Compost",
          photo2: "assets/images/quiz/niveau1/Q4_2.png",
          reponse3: "Arbre",
          photo3: "assets/images/quiz/niveau1/Q4_3.png",
          reponse4: "Meuble",
          photo4: "assets/images/quiz/niveau1/Q4_4.png",
          reponseCorrecte: 2,
          explication: EXPLICATION(
              text:
                  "Le compostage est un processus naturel de décomposition des déchets organiques qui produit un engrais naturel riche en nutriments pour les plantes. Les pommes pourries et d'autres déchets de cuisine peuvent être ajoutés à un tas de compost ou à un composteur pour se décomposer naturellement et former du compost.",
              SoundPath: "music/n1q4Exp.m4a"),
          SoundPath: "music/n1q4.m4a",
        ),
      ),
      QuizGestes(
        question: "Quel est le bon geste quand j'ai des documents à imprimer ?",
        photo1: "assets/images/quiz/niveau1/Q5_1.png",
        photo2: "assets/images/quiz/niveau1/Q5_2.png",
        reponseCorrecte: 2,
        explication: EXPLICATION(
            text:
                "Le bon geste quand on a des documents à imprimer est de n'imprimer que ce qui est nécessaire et d'imprimer en recto verso pour réduire la quantité de papier utilisée. Il est également important de recycler le papier utilisé et de ne pas le jeter à la poubelle.",
            SoundPath: "music/n1q5Exp.m4a"),
        SoundPath: "music/n1q5.m4a",
      ),
      QuizGestes(
        question: "Quel est le bon geste quand je vais faire les courses ?",
        photo1: "assets/images/quiz/niveau1/Q6_1.png",
        photo2: "assets/images/quiz/niveau1/Q6_2.png",
        reponseCorrecte: 1,
        explication: EXPLICATION(
            text:
                "Préférez les sacs réutilisables : Au lieu d'utiliser des sacs en plastique jetables, apportez vos propres sacs réutilisables en tissu ou en matériau recyclé",
            SoundPath: "music/n1q6Exp.m4a"),
        SoundPath: "music/n1q6.m4a",
      ),
      QuizGestes(
        question: "Quel est le bon geste quand mes piles sont déchargées ?",
        photo1: "assets/images/quiz/niveau1/Q7_1.png",
        photo2: "assets/images/quiz/niveau1/Q7_2.png",
        reponseCorrecte: 1,
        explication: EXPLICATION(
            text:
                "Le bon geste lorsque vos piles sont déchargées est de les déposer dans des bacs de récupération de piles usagées plutôt que de les jeter à la poubelle. Les piles contiennent des métaux lourds tels que le mercure, le plomb et le cadmium, qui peuvent être très polluants et nuire à l'environnement s'ils se retrouvent dans les décharges.",
            SoundPath: "music/n1q7Exp.m4a"),
        SoundPath: "music/n1q7.m4a",
      ),
      QuizMultiples(
        question: "Que signifie le terme \"recyclage\" ?",
        reponse1: "Transformer des déchets en de nouveaux produits",
        reponse2: "Jeter des déchets dans une décharge",
        reponse3: "Brûler des déchets pour produire de l'énergie",
        reponse4: "Nettoyer l'environnement du déchets",
        reponseCorrecte: 1,
        indication: Indication(
            text:
                "Le fait de jeter les déchets ou les brûler est mauvais pour l’environnement, qu’est-ce que vous en pensez ?",
            SoundPath: "music/n1q8Ind.m4a"),
        explication: EXPLICATION(
            text:
                "Le recyclage est le processus de collecte, de tri, de nettoyage et de transformation des matériaux recyclables en nouveaux produits. Les matériaux recyclables sont des matériaux qui peuvent être transformés en nouveaux produits, tels que le plastique, le papier, le carton, le verre et le métal.",
            SoundPath: "music/n1q8Exp.m4a"),
        SoundPath: "music/n1q8.m4a",
      ),
      QuizMultiples(
        question:
            "Avant de commencer le processus de recyclage , on doit trier les ordures selon :",
        reponse1: "La couleur",
        reponse2: "Le type (recyclable ou non)",
        reponse3: "Le volume",
        reponse4: "La matière",
        reponseCorrecte: 2,
        indication: Indication(
            text:
                "La nourriture n'est pas recyclable mais les feuilles le sont !",
            SoundPath: "music/n1q10Ind.m4a"),
        explication: EXPLICATION(
            text:
                "Il existe deux grandes familles de matériaux , la famille des matériaux recyclables c’est-à- dire que nous pouvons les retransformer en matériaux que nous pouvons réutiliser comme les bouteilles d’eau , les  feuilles en papier... et celle des matériaux non-recyclables comme les médicaments , restes de repas , la peinture...",
            SoundPath: "music/n1q10Exp.m4a"),
        SoundPath: "music/n1q10.m4a",
      ),
    ],
  );
  late Level level2 = Level(
    levelIndex: 1,
    changeBooleanStatus: level3.setIsLocked,
    isLocked: dataBaseService.returnLockedState(1, 2),
    liste: [
      QuizPhotosDesign(
        quizPhotos: QuizPhotos(
          question: "Les canettes en aluminium sont transformées en :",
          photoQuestion: "assets/images/quiz/niveau2/Q11.png",
          reponse1: "Trottinette",
          photo1: "assets/images/quiz/niveau2/Q11_1.png",
          reponse2: "Carrelage",
          photo2: "assets/images/quiz/niveau2/Q11_2.png",
          reponse3: "Encadrement de fenêtre",
          photo3: "assets/images/quiz/niveau2/Q11_3.png",
          reponse4: "Pneu",
          photo4: "assets/images/quiz/niveau2/Q11_4.png",
          reponseCorrecte: 1,
          explication: EXPLICATION(
              text:
                  "Les canettes en aluminium peuvent être recyclées pour fabriquer différents produits en aluminium, y compris des trottinettes. Le recyclage des canettes en aluminium est important car il permet d'économiser de l'énergie et des ressources naturelles, tout en réduisant les déchets dans l'environnement.",
              SoundPath: "music/n2q1Exp.m4a"),
          SoundPath: "music/n2q1.m4a",
        ),
      ),
      QuizPhotosDesign(
        quizPhotos: QuizPhotos(
            question: "Une collection de journaux est transformée en :",
            photoQuestion: "assets/images/quiz/niveau2/Q12.png",
            reponse1: "Cahier",
            photo1: "assets/images/quiz/niveau2/Q12_1.png",
            reponse2: "Journaux",
            photo2: "assets/images/quiz/niveau2/Q12_2.png",
            reponse3: "Stylo",
            photo3: "assets/images/quiz/niveau2/Q12_3.png",
            reponse4: "Bouteille en plastique",
            photo4: "assets/images/quiz/niveau2/Q12_4.png",
            reponseCorrecte: 2,
            explication: EXPLICATION(
                text:
                    "Une collection de journaux est transformée en papier recyclé pour produire de nouveaux journaux ou d'autres produits en papier tels que des mouchoirs en papier ou des essuie-tout.",
                SoundPath: "music/n2q2Exp.m4a"),
            SoundPath: "music/n2q2.m4a"),
      ),
      QuizPhotosDesign(
        quizPhotos: QuizPhotos(
            question: "Les bidons en plastique sont transformées en :",
            photoQuestion: "assets/images/quiz/niveau2/Q13.png",
            reponse1: "Bac à fleurs ",
            photo1: "assets/images/quiz/niveau2/Q13_1.png",
            reponse2: "L'engrais",
            photo2: "assets/images/quiz/niveau2/Q13_2.png",
            reponse3: "Flacons",
            photo3: "assets/images/quiz/niveau2/Q13_3.png",
            reponse4: "Chaise de jardin",
            photo4: "assets/images/quiz/niveau2/Q13_4.png",
            reponseCorrecte: 4,
            explication: EXPLICATION(
                text:
                    "Les bidons en plastique peuvent être recyclés pour fabriquer une variété de produits en plastique, y compris des chaises de jardin. Le recyclage des bidons en plastique est une façon écologique de les réutiliser au lieu de les jeter dans les décharges où ils prendraient des années à se décomposer",
                SoundPath: "music/n2q3Exp.m4a"),
            SoundPath: "music/n2q3.m4a"),
      ),
      QuizGestes(
          question: "Quel est le bon geste quand l’ampoule est usagée ?",
          photo2: "assets/images/quiz/niveau2/Q14_1.png",
          photo1: "assets/images/quiz/niveau2/Q14_2.png",
          reponseCorrecte: 2,
          explication: EXPLICATION(
              text:
                  "Le bon geste quand une ampoule est usagée est de la jeter dans une poubelle spéciale pour les déchets dangereux ou de la rapporter dans un magasin ou un centre de recyclage approprié. Les ampoules contiennent des substances toxiques comme le mercure, qui peuvent être nocives pour l'environnement et la santé humaine si elles ne sont pas correctement éliminées.",
              SoundPath: "music/n2q4Exp.m4a"),
          SoundPath: "music/n2q4.m4a"),
      QuizGestes(
          question: "Quel est le bon geste quand j’épluche un fruit ?",
          photo1: "assets/images/quiz/niveau2/Q15_1.png",
          photo2: "assets/images/quiz/niveau2/Q15_2.png",
          reponseCorrecte: 1,
          explication: EXPLICATION(
              text:
                  "Le bon geste à faire lorsque vous épluchez un fruit est de mettre les épluchures de fruits dans le compost ou le bac à compost si vous en avez un. Les épluchures de fruits sont des déchets organiques qui peuvent être facilement compostés, transformés en un engrais naturel et utilisés pour fertiliser les plantes.",
              SoundPath: "music/n2q5Exp.m4a"),
          SoundPath: "music/n2q5.m4a"),
      QuizGestes(
          question: "Quel est le bon geste quand je prépare mon goûter ?",
          photo1: "assets/images/quiz/niveau2/Q16_1.png",
          photo2: "assets/images/quiz/niveau2/Q16_2.png",
          reponseCorrecte: 2,
          explication: EXPLICATION(
              text:
                  "Le bon geste pour préparer son goûter de manière écologique est de privilégier les produits locaux, de saison et bio si possible, d'éviter les emballages jetables en optant pour des contenants réutilisables (ex: boîtes en verre, sacs en tissu), et de limiter la consommation de produits transformés qui génèrent souvent plus de déchets. Il est également important de bien gérer ses achats pour éviter le gaspillage alimentaire.",
              SoundPath: "music/n2q6Exp.m4a"),
          SoundPath: "music/n2q6.m4a"),
      QuizMultiples(
        question: "Quelle est la deuxième étape du recyclage ?",
        reponse1: "La transformation des déchets en nouveaux produits",
        reponse2: "Le transport des déchets vers une usine de recyclage",
        reponse3: "Le stockage temporaire des déchets",
        reponse4: "Le traitement des déchets et les préparer à se transformer",
        reponseCorrecte: 2,
        indication: Indication(
            text:
                "On possède maintenant des déchets, qu’est ce qu' on fait champion ?",
            SoundPath: "music/n2q7Ind.m4a"),
        explication: EXPLICATION(
            text:
                "La deuxième étape du recyclage consiste à transporter les déchets collectés vers une usine de recyclage ou un centre de tri. Cette étape est importante pour garantir la qualité des matériaux recyclables et minimiser les impacts environnementaux liés au transport.",
            SoundPath: "music/n2q7Exp.m4a"),
        SoundPath: "music/n2q7.m4a",
      ),
      QuizMultiples(
        question: "Quel type de déchet ne peut pas être recyclé ?",
        reponse1: "Le papier et le carton",
        reponse2: "Les sacs en plastique",
        reponse3: "Les boîtes de conserve",
        reponse4: "Les bouteilles en verre",
        reponseCorrecte: 2,
        indication: Indication(
            text:
                "Surement c'est un déchet qui pose un problème au niveau de machines de recyclage.",
            SoundPath: "music/n2q8Ind.m4a"),
        explication: EXPLICATION(
            text:
                "Les sacs en plastique sont généralement fabriqués à partir d'un type de plastique qui n'est pas recyclable, et ils ont tendance à se coincer dans les machines de tri des déchets.",
            SoundPath: "music/n2q8Exp.m4a"),
        SoundPath: "music/n2q8.m4a",
      ),
      QuizMultiples(
        question:
            "Quel est l'impact environnemental le plus important du gaspillage alimentaire ?",
        reponse1: "La pollution de l'air",
        reponse2: "La déforestation",
        reponse3: "L'émission de gaz à effet de serre",
        reponse4: "La perte de biodiversité",
        reponseCorrecte: 3,
        indication: Indication(
            text:
                "Les déchets alimentaires peuvent être transformés en quelque chose d'utile, comme le compostage.",
            SoundPath: "music/n2q9Ind.m4a"),
        explication: EXPLICATION(
            text:
                "Le gaspillage alimentaire contribue à l'émission de gaz à effet de serre car les aliments jetés dans les décharges produisent du méthane, un gaz qui contribue au réchauffement climatique. En outre, le gaspillage alimentaire entraîne également une utilisation inutile des ressources naturelles, telles que l'eau et l'énergie, nécessaires pour produire les aliments.",
            SoundPath: "music/n2q9Exp.m4a"),
        SoundPath: "music/n2q9.m4a",
      ),
      QuizMultiples(
        question:
            "Quelle est la meilleure façon de réduire les déchets électroniques ?",
        reponse1: "Les recycler correctement",
        reponse2: "Les réparer",
        reponse3: "Les jeter dans les décharges",
        reponse4: "Pratiquer leur location",
        reponseCorrecte: 1,
        indication: Indication(
            text:
                "Les téléphones portables sont un exemple de déchets électroniques courants.",
            SoundPath: "music/n2q10Ind.m4a"),
        explication: EXPLICATION(
            text:
                "La meilleure façon de réduire les déchets électroniques est de les recycler correctement. Les appareils électroniques contiennent souvent des matériaux toxiques qui peuvent être dangereux pour l'environnement s'ils ne sont pas éliminés correctement. Les appareils encore en bon état peuvent également être donnés ou réparés, plutôt que d'être jetés.",
            SoundPath: "music/n2q10Exp.m4a"),
        SoundPath: "music/n2q10.m4a",
      ),
    ],
  );
  late Level level3 = Level(
    levelIndex: 2,
    changeBooleanStatus: level4.setIsLocked,
    isLocked: dataBaseService.returnLockedState(2, 2),
    liste: [
      QuizMultiples(
        question: "Quel matériel ne peut pas être recyclé ?",
        reponse1: "Le verre",
        reponse2: "Le carton",
        reponse3: "Le polystyrène (Styrofoam)",
        reponse4: "Le papier",
        reponseCorrecte: 3,
        indication: Indication(
            text: "On les trouve quand on achète de nouveaux électroménagers.",
            SoundPath: "music/n3q1Ind.m4a"),
        explication: EXPLICATION(
            text:
                "Le polystyrène est un matériau qui n'est généralement pas recyclable car il est difficile à traiter et coûteux à recycler. Il est donc important de réduire la quantité de polystyrène que nous utilisons et d'en disposer correctement lorsque nous en avons besoin.",
            SoundPath: "music/n3q1Exp.m4a"),
        SoundPath: "music/n3q1.m4a",
      ),
      QuizMultiples(
        question: "Qu'est-ce que le compostage ?",
        reponse1: "La transformation des déchets en énergie",
        reponse2: "La transformation des déchets en engrais naturel",
        reponse3: "La réduction de la quantité de déchets générés",
        reponse4: "L'enfouissement des déchets dans des décharges sanitaires",
        reponseCorrecte: 2,
        indication: Indication(
            text:
                "Le compostage est une pratique courante pour réduire les déchets organiques et améliorer la qualité des sols.",
            SoundPath: "music/n3q2Ind.m4a"),
        explication: EXPLICATION(
            text:
                "Le compostage est la transformation des déchets organiques, tels que les restes de nourriture et les feuilles mortes, en un engrais naturel qui peut être utilisé pour fertiliser les sols. Cela permet de réduire la quantité de déchets générés et d'éviter qu'ils ne finissent dans les décharges. Le compostage peut également améliorer la qualité des sols en augmentant leur teneur en nutriments et en favorisant la croissance des plantes.",
            SoundPath: "music/n3q2Exp.m4a"),
        SoundPath: "music/n3q2.m4a",
      ),
      QuizMultiples(
        question:
            "\"zéro déchet\" est une méthode de gestion des déchets qui vise à :",
        reponse1: "réduire la quantité de déchets envoyés en décharge",
        reponse2: "incinérer tous les déchets pour produire de l'énergie",
        reponse3: "enfouir les déchets dans des sites d'enfouissement spéciaux",
        reponse4:
            "promouvoir une production de déchets plus élevée en utilisant des matériaux jetables",
        reponseCorrecte: 1,
        indication: Indication(
            text:
                "Le mouvement \"zéro déchet\" est de plus en plus populaire parmi les personnes soucieuses de l'environnement.",
            SoundPath: "music/n3q3Ind.m4a"),
        explication: EXPLICATION(
            text:
                "Le \"zéro déchet\" est une méthode de gestion des déchets qui vise à réduire la quantité de déchets envoyés en décharge. Cette méthode encourage la réduction à la source, le recyclage, le compostage et la réutilisation des déchets. Elle peut également encourager l'achat de produits durables et la réparation des objets plutôt que leur remplacement.",
            SoundPath: "music/n3q3Exp.m4a"),
        SoundPath: "music/n3q3.m4a",
      ),
      QuizMultiples(
        question:
            "Que signifie les trois flèches qui forment une boucle et qui sont souvent utilisées pour représenter le recyclage ?",
        reponse1: "Réduire, réutiliser, recycler",
        reponse2: "Recycler, récupérer, réutiliser",
        reponse3: "Recycler, réduire, réutiliser",
        reponse4: "Recycler, rejeter et réduire",
        reponseCorrecte: 1,
        indication: Indication(text: "", SoundPath: ""),
        explication: EXPLICATION(
            text:
                "Les trois flèches qui forment une boucle et qui sont souvent utilisées pour représenter le recyclage symbolisent le processus de \"Réduire, réutiliser, recycler\". Cela signifie réduire la  consommation de produits, réutiliser les produits autant que possible et recycler les matériaux lorsque cela est possible.",
            SoundPath: "music/n3q4Exp.m4a"),
        SoundPath: "music/n3q4.m4a",
      ),
      QuizMultiples(
        question: "Pourquoi le recyclage est-il important ?",
        reponse1: "Réduire la quantité de déchets envoyés en décharge",
        reponse2: "Economiser les ressources naturelles",
        reponse3: "Réduire la pollution de l'air et de l'eau",
        reponse4: "Réduire la pollution de l'air et de l'eau",
        reponseCorrecte: 1,
        indication: Indication(
            text:
                "le recyclage a de nombreux avantages pour l'environnement et la société.", //n'a pas d'audio
            SoundPath: "music/n3q5Ind.m4a"),
        explication: EXPLICATION(
            text:
                "le recyclage est important car il permet de réduire la quantité de déchets envoyés en décharge, ce qui limite les impacts négatifs sur l'environnement. En outre, le recyclage permet d'économiser les ressources naturelles en réutilisant les matériaux existants plutôt que d'en produire de nouveaux. Enfin, le recyclage contribue à réduire la pollution de l'air et de l'eau en évitant la production de gaz à effet de serre et en limitant les rejets toxiques dans l'environnement.",
            SoundPath: "music/n3q5Exp.m4a"),
        SoundPath: "music/n3q5.m4a",
      ),
      QuizMultiples(
        question: "Comment peut-on encourager le recyclage ?",
        reponse1: "En sensibilisant le public à l'importance du recyclage",
        reponse2: "En créant des incitations financières pour le recyclage",
        reponse3:
            "En mettant en place des infrastructures de collecte et de recyclage efficaces",
        reponse4:
            "En interdisant complètement la production de produits non recyclables",
        reponseCorrecte: 1,
        indication: Indication(
            text:
                "Le recyclage dépend de la participation de tous, comment pouvons-nous encourager les gens à s'impliquer ?",
            SoundPath: "music/n3q6Ind.m4a"),
        explication: EXPLICATION(
            text:
                "Il est important de sensibiliser le public à l'importance du recyclage et aux avantages environnementaux et sociaux qu'il offre. Les incitations financières peuvent également aider à encourager le recyclage, tout comme la mise en place d'infrastructures de collecte et de recyclage efficaces.",
            SoundPath: "music/n3q6Exp.m4a"),
        SoundPath: "music/n3q6.m4a",
      ),
      QuizMultiples(
        question:
            "Quel est le type de déchet suivant qui ne doit pas être jeté dans la poubelle normale ?",
        reponse1: "Les papiers sales",
        reponse2: "Les canettes en aluminium vides",
        reponse3: "Les emballages de nourriture en plastique",
        reponse4: "Les bouteilles en verre cassées",
        reponseCorrecte: 3,
        indication: Indication(
            text: "Ce type rend le recyclage plus difficile.",
            SoundPath: "music/n3q9Ind.m4a"),
        explication: EXPLICATION(
            text:
                "Les emballages de nourriture en plastique doivent être triés et jetés dans la poubelle de recyclage appropriée. Ils ne doivent pas être jetés dans la poubelle normale, car ils peuvent contaminer d'autres matériaux recyclables et rendre leur recyclage plus difficile.",
            SoundPath: "music/n3q9Exp.m4a"),
        SoundPath: "music/n3q9.m4a",
      ),
      QuizMultiples(
        question:
            "Quel est le type de déchet suivant qui ne peut pas être recyclé dans les programmes de recyclage municipaux ?",
        reponse1: "Les bouteilles en plastique",
        reponse2: "Les boîtes en carton",
        reponse3: "Les stylos à bille",
        reponse4: "Les piles usagées",
        reponseCorrecte: 3,
        indication: Indication(
            text: "Ce type peut contaminer d'autres matériaux recyclables.",
            SoundPath: "music/n3q10Ind.m4a"),
        explication: EXPLICATION(
            text:
                "Les stylos à bille ne peuvent pas être recyclés dans les programmes de recyclage municipaux car ils sont généralement fabriqués à partir de plastique non recyclable et contiennent de l'encre qui peut contaminer d'autres matériaux recyclables.",
            SoundPath: "music/n3q10Exp.m4a"),
        SoundPath: "music/n3q10.m4a",
      ),
      QuizMultiples(
        question: "Qu’est-ce qu’un composteur ?",
        reponse1: "Une personne qui collecte les déchets",
        reponse2: "Une poubelle",
        reponse3: "Un bac en bois ou en plastique pour composter les déchets",
        reponse4: "Rien de ce que c'est passé",
        reponseCorrecte: 3,
        indication: Indication(
            text: "Il n'y a pas d'indication pour cette question.",
            SoundPath: "music/n3q7Ind.m4a"),
        explication: EXPLICATION(
            text:
                "Un composteur est un récipient spécialement conçu pour le compostage, qui permet de décomposer les déchets organiques en compost riche en nutriments pour les plantes.",
            SoundPath: "music/n3q7Exp.m4a"), // il manque un audio ici
        SoundPath: "music/n3q7.m4a",
      ),
      QuizMultiples(
        question:
            "Faut-il préparer les déchets avant de les mettre dans le composteur ?",
        reponse1: "Oui, je les coupe en petits morceaux",
        reponse2: "Oui, je broie les coquilles d'oeuf",
        reponse3: "Non, je les mets en entier",
        reponse4: "Rien de ce que c'est passé",
        reponseCorrecte: 1,
        indication:
            Indication(text: "Pas d'indication à ce niveau !", SoundPath: ""),
        explication: EXPLICATION(text: "", SoundPath: ""),
        SoundPath: "music/n3q8.m4a",
      ),
    ],
  );
  late Level level4 = Level(
    levelIndex: 3,
    changeBooleanStatus: level5.setIsLocked,
    isLocked: dataBaseService.returnLockedState(3, 2),
    liste: [
      QuizMultiples(
          question:
              "Quels sont les conséquences de ne pas recycler les déchets sur l’environnement?",
          reponse1: "Les maladies",
          reponse2: "La pollution de l'environnement",
          reponse3: "La disparition des rares espèces d’animaux en mer",
          reponse4: "Toutes les réponses sont vraies",
          reponseCorrecte: 4,
          indication: Indication(
              text:
                  " L'accumulation des ordures ménagères a des effets néfastes sur notre santé et aussi sur l’environnement qui nous entoure !",
              SoundPath: "music/n4q1Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Parmi les bons gestes qu’on doit tous faire dans notre vie quotidienne, le recyclage , car l'accumulation des ordures affecte notre entourage négativement , par exemple elle cause en premier lieu la pollution avec tous ses type (pollution de l'air ,de l'eau et du sol) ce qui causes de nombreuses maladies (les maladies chroniques , cardiovasculaire ...)",
              SoundPath: "music/n4q1Exp.m4a"), //il manque un audio la-ba
          SoundPath: "music/n4q1.m4a"),
      QuizMultiples(
          question:
              "Quel est le principal avantage du compostage des déchets alimentaires ?",
          reponse1: "Il réduit les émissions de gaz à effet de serre",
          reponse2: "Il réduit la pollution de l'air",
          reponse3: "Il augmente la fertilité du sol",
          reponse4: "Il transforme les déchets alimentaires en nourriture",
          reponseCorrecte: 3,
          indication: Indication(
              text:
                  "Il peut être utilisé pour produire du compost riche en nutriments pour les plantes.",
              SoundPath: "music/n4q2Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Le principal avantage du compostage des déchets alimentaires est qu'il augmente la fertilité du sol, produisant du compost riche en nutriments pour les plantes.",
              SoundPath: "music/n4q2Exp.m4a"), //il manque un audio la-ba
          SoundPath: "music/n4q2.m4a"),
      QuizMultiples(
          question:
              "Qu'est-ce qui ne peut pas être recyclé dans la poubelle bleue ?",
          reponse1: "Les canettes en aluminium",
          reponse2: "Les bouteilles en plastique",
          reponse3: "Les pots de yaourt en plastique",
          reponse4: "Les sacs en plastique",
          reponseCorrecte: 4,
          indication: Indication(
              text:
                  "Les matériaux qui ne peuvent pas être recyclés dans la poubelle bleue sont souvent ceux qui sont difficiles à traiter ou qui sont contaminés.",
              SoundPath: "music/n4q3Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Les canettes en aluminium peuvent être recyclées dans la poubelle bleue car elles sont fabriquées à partir de matériaux recyclables. Les bouteilles en plastique et les pots de yaourt en plastique peuvent également être recyclés car ils sont en plastique. Cependant, les sacs en plastique ne peuvent pas car ils sont trop fins et peuvent obstruer les machines de tri. Il est recommandé de les déposer dans des conteneurs de recyclage spécifiques pour les sacs en plastique.",
              SoundPath: "music/n4q3Exp.m4a"), //il manque un audio la-ba
          SoundPath: "music/n4q3.m4a"),
      QuizMultiples(
          question: "Combien de fois peut-on recycler une feuille de papier ?",
          reponse1: "Une fois",
          reponse2: "LDeux fois",
          reponse3: "Trois fois",
          reponse4: "Indéfiniment",
          reponseCorrecte: 4,
          indication: Indication(
              text:
                  "Les matériaux qui peuvent être recyclés plusieurs fois sont souvent ceux qui peuvent être transformés en nouvelles matières premières.",
              SoundPath: "music/n4q4Ind.m4a"),
          explication: EXPLICATION(
              text:
                  " Une feuille de papier peut être recyclée plusieurs fois, en fonction de la qualité et de l'usage qu'elle a subi. Les fibres de papier se raccourcissent chaque fois qu'elles sont recyclées, ce qui rend le papier moins résistant et de moins bonne qualité. Cependant, les fibres de papier peuvent être mélangées avec d'autres matières premières pour créer de nouveaux produits en papier. Ainsi, une feuille de papier peut être recyclée indéfiniment.",
              SoundPath: "music/n4q4Exp.m4a"),
          SoundPath: "music/n4q4.m4a"),
      QuizMultiples(
          question: "Quel matériau est le plus facile à recycler ?",
          reponse1: "Le verre",
          reponse2: "Le métal",
          reponse3: "Le papier",
          reponse4: "Le plastique",
          reponseCorrecte: 2,
          indication: Indication(
              text:
                  "Les matériaux qui sont faciles à recycler sont souvent ceux qui peuvent être transformés en nouvelles matières premières avec un traitement minimal.",
              SoundPath: "music/n4q5Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Le métal est le matériau le plus facile à recycler car il peut être fondu et refondu plusieurs fois sans perdre ses propriétés. Le verre est également facile à recycler car il peut être fondu pour créer de nouveaux produits en verre. Le papier peut être recyclé plusieurs fois, mais nécessite un traitement pour retirer les encres et les additifs. Le plastique est plus difficile à recycler car il existe de nombreux types différents de plastiques avec des propriétés différentes.",
              SoundPath: "music/n4q5Exp.m4a"),
          SoundPath: "music/n4q5.m4a"),
      QuizMultiples(
          question:
              "Que signifie le symbole de recyclage avec un nombre à l'intérieur ?",
          reponse1: "Le type de matériau",
          reponse2: "Le pourcentage de matériau recyclé",
          reponse3: "Le nombre de fois qu'un matériau peut être recyclé",
          reponse4: "Le nombre de centres de recyclage dans la région",
          reponseCorrecte: 1,
          indication: Indication(
              text:
                  "Le symbole de recyclage avec un nombre à l'intérieur indique une propriété spécifique du matériau.",
              SoundPath: "music/n4q6Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Le symbole de recyclage avec un nombre à l'intérieur indique le type de matériau et le nombre de fois qu'il peut être recyclé. Par exemple, le symbole de recyclage avec le chiffre 1 signifie que le matériau est du PET, utilisé pour les bouteilles en plastique, et qu'il peut être recyclé une fois. Le symbole de recyclage avec le chiffre 7 est utilisé pour les plastiques qui ne sont pas facilement recyclables.",
              SoundPath: "music/n4q6Exp.m4a"),
          SoundPath: "music/n4q6.m4a"),
      QuizMultiples(
          question: "Quel est le principal défi du recyclage des plastiques ?",
          reponse1: "Les différents types de plastiques qui existent",
          reponse2: "La rareté des matériaux recyclables",
          reponse3: "Le manque de centres de recyclage",
          reponse4: "Le coût élevé de la technologie de recyclage",
          reponseCorrecte: 1,
          indication: Indication(
              text:
                  "Les plastiques sont souvent composés de différents types de matériaux qui nécessitent des traitements différents pour être recyclés.",
              SoundPath: "music/n4q7Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Le principal défi du recyclage des plastiques est la grande variété de types de plastiques existants. Les plastiques peuvent contenir différents types de matériaux qui nécessitent des traitements différents pour être recyclés. De plus, les différents types de plastiques ne peuvent pas toujours être mélangés ensemble car ils peuvent avoir des propriétés différentes. Cela rend le tri et le recyclage des plastiques plus difficile.",
              SoundPath: "music/n4q7Exp.m4a"),
          SoundPath: "music/n4q7.m4a"),
      QuizMultiples(
          question: "Qu'est-ce que le recyclage 'en boucle fermée' ?",
          reponse1: "Le recyclage d'un matériau en un autre matériau similaire",
          reponse2: "Le recyclage d'un matériau en un autre matériau différent",
          reponse3: "Le recyclage d'un matériau sans traitement supplémentaire",
          reponse4: "Le recyclage d'un matériau avec traitement supplémentaire",
          reponseCorrecte: 1,
          indication: Indication(
              text:
                  "Le recyclage en boucle fermée est un processus de recyclage spécifique.",
              SoundPath: "music/n4q8Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Le recyclage en boucle fermée est un processus de recyclage spécifique où un matériau est recyclé dans un autre matériau similaire sans traitement supplémentaire. Cela signifie que le matériau recyclé conserve ses propriétés et peut être réutilisé dans le même produit. Par exemple, l'aluminium peut être recyclé en aluminium sans perte de qualité.",
              SoundPath: "music/n4q8Exp.m4a"),
          SoundPath: "music/n4q8.m4a"),
      QuizMultiples(
          question:
              "Quel est l'impact environnemental de la production de papier recyclé ?",
          reponse1:
              "Nécessite moins d'eau et d'énergie que du papier non recyclé",
          reponse2:
              "Nécessite plus d'eau et d'énergie que du papier non recyclé",
          reponse3:
              "A le même impact environnemental que du papier non recyclé",
          reponse4: "N'a pas d'impact environnemental",
          reponseCorrecte: 1,
          indication: Indication(
              text:
                  "La production de papier recyclé utilise moins de matières premières que la production de papier non recyclé.",
              SoundPath: "music/n4q9Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "La production de papier recyclé nécessite moins d'eau et d'énergie que la production de papier non recyclé car elle utilise des matières premières déjà traitées plutôt que de nouveaux arbres. Cependant, la production de papier recyclé peut nécessiter plus d'eau et d'énergie que la production de papier non recyclé si le processus de recyclage n'est pas efficace.",
              SoundPath: "music/n4q9Exp.m4a"),
          SoundPath: "music/n4q9.m4a"),
      QuizMultiples(
          question: "Qu'est-ce que le recyclage des batteries ?",
          reponse1:
              "Le recyclage des matériaux contenus dans les batteries pour en fabriquer de nouvelles",
          reponse2:
              "Le recyclage des batteries usagées pour en faire des objets de décoration",
          reponse3:
              "La vente des batteries usagées à des entreprises qui les réutilisent",
          reponse4:
              "La collecte des batteries usagées pour les déposer dans les décharges",
          reponseCorrecte: 1,
          indication: Indication(
              text:
                  "Les batteries contiennent des métaux toxiques qui peuvent causer des problèmes de santé et de l'environnement.",
              SoundPath: "music/n4q10Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Le recyclage des batteries consiste à collecter les batteries usagées et à récupérer les métaux qu'elles contiennent pour les utiliser dans la fabrication de nouvelles batteries ou d'autres produits. Les batteries contiennent souvent des métaux toxiques tels que le plomb, le cadmium et le mercure, qui peuvent causer des problèmes de santé et de l'environnement s'ils ne sont pas correctement éliminés.",
              SoundPath: "music/n4q10Exp.m4a"),
          SoundPath: "music/n4q10.m4a"),
    ],
  );
  late Level level5 = Level(
    levelIndex: 4,
    changeBooleanStatus: decoyMethod,
    isLocked: dataBaseService.returnLockedState(4, 2),
    liste: [
      QuizMultiples(
          question:
              "Que peut-on faire avec les bouteilles en plastique recyclées ?",
          reponse1: "Les réutiliser pour stocker des liquides",
          reponse2:
              "Les transformer en matière première pour fabriquer de nouveaux produits en plastique",
          reponse3: "Les jeter à la poubelle",
          reponse4: "Les utiliser pour faire des décorations de Noël",
          reponseCorrecte: 2,
          indication: Indication(
              text:
                  " Le recyclage des bouteilles en plastique peut aider à réduire la pollution des océans.",
              SoundPath: "music/n5q1Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Les bouteilles en plastique recyclées peuvent être transformées en matière première pour fabriquer de nouveaux produits en plastique. Le recyclage des bouteilles en plastique est important car cela permet de réduire la quantité de plastique qui finit dans les décharges et dans les océans, où il peut causer des dommages environnementaux importants.",
              SoundPath: "music/n5q1Exp.m4a"), //il manque un audio la-ba
          SoundPath: "music/n5q1.m4a"),
      QuizMultiples(
          question: "Quel matériau ne peut pas être recyclé ?",
          reponse1: "Le verre",
          reponse2: "Le papier",
          reponse3: "Le plastique",
          reponse4: "Le chewing-gum",
          reponseCorrecte: 4,
          indication: Indication(
              text:
                  "Ce matériau est souvent collant et ne se décompose pas facilement.",
              SoundPath: "music/n5q2Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Le chewing-gum ne peut pas être recyclé car il est souvent collant et ne se décompose pas facilement. Si les chewing-gums sont jetés dans la nature, ils peuvent causer des problèmes environnementaux importants, tels que la pollution des rues, des trottoirs et des espaces publics.",
              SoundPath: "music/n5q2Exp.m4a"), //il manque un audio la-ba
          SoundPath: "music/n5q2.m4a"),
      QuizMultiples(
          question: "Que peut-on faire avec des vieux vêtements ?",
          reponse1: "Les jeter à la poubelle",
          reponse2: "Les donner à des associations caritatives",
          reponse3: "Les utiliser comme chiffons de nettoyage",
          reponse4: "Toutes les réponses ci-dessus",
          reponseCorrecte: 4,
          indication: Indication(
              text: "Les vieux vêtements peuvent encore avoir une utilité.",
              SoundPath: "music/n5q3Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Les vieux vêtements peuvent encore avoir une utilité. Au lieu de les jeter à la poubelle, nous pouvons les donner à des associations caritatives qui les redistribuent aux personnes dans le besoin. Nous pouvons également les utiliser comme chiffons de nettoyage pour éviter d'acheter des chiffons en papier jetables. ",
              SoundPath: "music/n5q3Exp.m4a"), //il manque un audio la-ba
          SoundPath: "music/n5q3.m4a"),
      QuizMultiples(
          question: "Quel est le matériau le plus difficile à recycler ?",
          reponse1: "Le verre",
          reponse2: "Le papier",
          reponse3: "Le plastique",
          reponse4: "Les piles",
          reponseCorrecte: 4,
          indication: Indication(
              text:
                  "Ce matériau est souvent utilisé pour fabriquer des batteries.",
              SoundPath: "music/n5q4Ind.m4a"),
          explication: EXPLICATION(
              text:
                  " Les piles sont le matériau le plus difficile à recycler. Les piles contiennent des métaux lourds et des produits chimiques qui peuvent être dangereux pour l'environnement. Si les piles ne sont pas recyclées correctement, elles peuvent causer des problèmes environnementaux importants. ",
              SoundPath: "music/n5q4Exp.m4a"),
          SoundPath: "music/n5q4.m4a"),
      QuizMultiples(
          question:
              "Quel est le meilleur matériau pour remplacer les sacs en plastique ?",
          reponse1: "Le papier",
          reponse2: "Le tissu",
          reponse3: "Le verre",
          reponse4: "Le métal",
          reponseCorrecte: 2,
          indication: Indication(
              text:
                  "Le matériau doit être léger, résistant et facilement recyclable.",
              SoundPath: "music/n5q5Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Le meilleur matériau pour remplacer les sacs en plastique est le tissu. Les sacs en tissu peuvent être réutilisés de nombreuses fois, ce qui les rend plus durables et plus respectueux de l'environnement que les sacs en plastique à usage unique. ",
              SoundPath: "music/n5q5Exp.m4a"),
          SoundPath: "music/n5q5.m4a"),
      QuizMultiples(
          question:
              "Quel est le principal avantage du compostage des déchets alimentaires ?",
          reponse1: "Il réduit les émissions de gaz à effet de serre",
          reponse2: "Il réduit la pollution de l'air",
          reponse3: "Il augmente la fertilité du sol",
          reponse4: "Il réduit la consommation d'eau dans les jardins",
          reponseCorrecte: 3,
          indication: Indication(
              text:
                  "Il peut être utilisé pour produire du compost riche en nutriments pour les plantes.",
              SoundPath: "music/n5q6Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Le principal avantage du compostage des déchets alimentaires est qu'il augmente la fertilité du sol, produisant du compost riche en nutriments pour les plantes.",
              SoundPath: "music/n5q6Exp.m4a"),
          SoundPath: "music/n5q6.m4a"),
      QuizMultiples(
          question:
              "Quel est le pourcentage de déchets produits dans le monde qui est recyclé ?",
          reponse1: "25%",
          reponse2: "50%",
          reponse3: "75%",
          reponse4: "90%",
          reponseCorrecte: 1,
          indication: Indication(
              text:
                  "N'oubliez pas que certains types de déchets sont non recyclables. ",
              SoundPath: "music/n5q7Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Le recyclage est un moyen important de réduire l'impact environnemental des déchets, mais il n'est pas encore largement pratiqué dans le monde. Le taux de recyclage varie considérablement d'un pays à l'autre et même au sein d'un même pays en fonction des politiques de gestion des déchets, des infrastructures de recyclage disponibles et du comportement des individus.",
              SoundPath: "music/n5q7Exp.m4a"),
          SoundPath: "music/n5q7.m4a"),
      QuizMultiples(
          question:
              "Quel est le meilleur moyen de réduire la quantité de déchets envoyés dans les décharges ?",
          reponse1: "Le compostage des déchets alimentaires",
          reponse2: "Le recyclage du papier et du carton",
          reponse3: "L'utilisation de bouteilles d'eau réutilisables",
          reponse4:
              "Le don des vieux vêtements à des organisations caritatives",
          reponseCorrecte: 1,
          indication: Indication(
              text:
                  "Cette méthode de réduction des déchets utilise des déchets organiques pour produire un engrais naturel.",
              SoundPath: "music/n5q8Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Le compostage des déchets alimentaires est le meilleur moyen de réduire la quantité de déchets envoyés dans les décharges. Le compostage utilise des déchets organiques tels que les restes de nourriture et les feuilles pour produire un engrais naturel riche en nutriments qui peut être utilisé pour nourrir les plantes. ",
              SoundPath: "music/n5q8Exp.m4a"),
          SoundPath: "music/n5q8.m4a"),
      QuizMultiples(
          question: "Quel est le principal avantage du recyclage des métaux ?",
          reponse1:
              "Il permet de réduire la quantité de métaux extraits de la terre",
          reponse2:
              "Il permet de réduire les émissions de gaz à effet de serre",
          reponse3: "Il augmente la durée de vie des produits en métal",
          reponse4: "Il est facilement accessible pour les communautés locales",
          reponseCorrecte: 1,
          indication: Indication(
              text:
                  "Le recyclage des métaux est important car il réduit la quantité de métaux extraits de la terre.",
              SoundPath: "music/n5q9Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Le principal avantage du recyclage des métaux est qu'il permet de réduire la quantité de métaux extraits de la terre. L'extraction de métaux est un processus coûteux et énergivore qui peut avoir des conséquences environnementales négatives, notamment la destruction de habitats naturels et la pollution de l'eau et de l'air.",
              SoundPath: "music/n5q9Exp.m4a"),
          SoundPath: "music/n5q9.m4a"),
      QuizMultiples(
          question:
              "Quel type de plastique est recyclable dans la plupart des centres de recyclage ?",
          reponse1: "Le PVC",
          reponse2: "Le PET",
          reponse3: "Le polystyrène",
          reponse4: "Le polypropylène",
          reponseCorrecte: 2,
          indication: Indication(
              text:
                  "Ce type de plastique est souvent utilisé pour fabriquer des bouteilles de soda et d'eau.",
              SoundPath: "music/n5q10Ind.m4a"),
          explication: EXPLICATION(
              text:
                  "Le PET (polyéthylène téréphtalate) est un type de plastique couramment utilisé pour fabriquer des bouteilles de soda et d'eau, et il peut être recyclé dans la plupart des centres de recyclage.",
              SoundPath: "music/n5q10Exp.m4a"),
          SoundPath: "music/n5q10.m4a"),
    ],
  );
  bool decoyMethod(bool te) {
    return false;
  }

  late List<Level> QuizContainer = [level1, level2, level3, level4, level5];
}
