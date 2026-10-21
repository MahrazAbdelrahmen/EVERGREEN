<p align="center"> <img src="docs/media/splash.gif" width="720" /> </p>

<p align="center">
  <a href="https://github.com/MahrazAbdelrahmen/EVERGREEN/releases/latest"><img src="https://img.shields.io/github/v/release/MahrazAbdelrahmen/EVERGREEN?label=T%C3%A9l%C3%A9charger%20l%27APK&logo=android&color=67EB00" alt="Télécharger l'APK" /></a>
</p>

## Projet 2CP - Jeu mobile pour la protection de l'environnement -

"EVERGREEN", le jeu mobile engagé pour la protection de l'environnement.

## Utilisé par

Ce jeu est utilisé par :
- Un public varié, y compris les enfants âgés de 7 ans et plus qui ont déjà acquis la capacité de lire. Offrant une expérience éducative divertissante, il encourage les jeunes à s'immerger dans un monde virtuel tout en apprenant les valeurs de la durabilité et de la préservation de notre planète.

## Aperçu

### Profils

Chaque enfant choisit son profil avant de jouer. Les profils peuvent rester sur l'appareil ou être synchronisés avec un compte parent.

<table>
  <tr>
    <td><img src="docs/media/start.jpg" /></td>
    <td><img src="docs/media/picker.jpg" /></td>
  </tr>
  <tr>
    <td><img src="docs/media/menu.jpg" /></td>
    <td><img src="docs/media/games.jpg" /></td>
  </tr>
</table>

### Puzzle

Les pièces sont découpées comme un vrai puzzle et s'aimantent quand elles sont posées au bon endroit.

<table>
  <tr>
    <td width="60%"><img src="docs/media/jigsaw.gif" /></td>
    <td><img src="docs/media/levels.jpg" /><br /><img src="docs/media/bravo-confetti.jpg" /></td>
  </tr>
</table>

### Tri

L'enfant fait glisser chaque déchet vers la poubelle qui lui correspond.

<table>
  <tr>
    <td width="60%"><img src="docs/media/tri.gif" /></td>
    <td><img src="docs/media/tri-progress.jpg" /></td>
  </tr>
</table>

### Quiz

Après chaque question, la bonne réponse est affichée avec une courte explication.

<table>
  <tr>
    <td width="60%"><img src="docs/media/quiz.gif" /></td>
    <td><img src="docs/media/quiz-answer.jpg" /><br /><img src="docs/media/quiz-explain.jpg" /></td>
  </tr>
</table>

### Livre

Le livre se feuillette page par page, et les chapitres sont accessibles depuis la barre du haut.

<table>
  <tr>
    <td width="60%"><img src="docs/media/pageturn.gif" /></td>
    <td><img src="docs/media/livre.jpg" /><br /><img src="docs/media/livre-bins.jpg" /></td>
  </tr>
</table>

### Défis et trophées

Les défis donnent des clés, qui servent à débloquer les histoires.

<table>
  <tr>
    <td><img src="docs/media/defis.jpg" /></td>
    <td><img src="docs/media/defi-dialog.jpg" /></td>
  </tr>
  <tr>
    <td><img src="docs/media/trophies.jpg" /></td>
    <td><img src="docs/media/profile.jpg" /></td>
  </tr>
</table>

### Histoires

<table>
  <tr>
    <td><img src="docs/media/stories.jpg" /></td>
    <td><img src="docs/media/nemo.jpg" /></td>
  </tr>
</table>

### Compte parent

<table>
  <tr>
    <td><img src="docs/media/auth.jpg" /></td>
    <td><img src="docs/media/settings.jpg" /></td>
  </tr>
</table>

## Nouveautés de la v2.0

* Nouvelle interface et écran de démarrage animé.
* Choix et création des profils, classement en ligne.
* Puzzle avec de vraies pièces découpées.
* Livre qui se feuillette comme un vrai livre.
* Défi quotidien et trophées.
* Connexion, inscription et mot de passe oublié sur une seule page.
* La musique se coupe quand l'application passe en arrière-plan.
* Règles de sécurité Firestore : chaque famille n'a accès qu'à ses propres données.
* Passage à Flutter 3.47 et correction de nombreux bugs.

## Installation

Téléchargez l'APK depuis la page [Releases](https://github.com/MahrazAbdelrahmen/EVERGREEN/releases/latest) et ouvrez-le sur votre téléphone Android.

* `app-arm64-v8a-release.apk` convient à la plupart des téléphones récents.
* `app-release.apk` fonctionne sur tous les téléphones, mais il est plus lourd.

## Auteurs

* [CHERGUELAINE Oussama](https://github.com/ousscher)
* [MAHRAZ Abderahman](https://github.com/MahrazAbdelrahmen)
* [BELHARDA Aya]
* [KADRI Lyna]
* [TOUTOU Salsabila]
* [CHERRAF Nourelhouda]

## Charte graphique

| Couleur             | Code Hexadécimal                                                                |
| ----------------- | ------------------------------------------------------------------ |
| bleu clair | ![#4CDAFE](https://placehold.co/10x10/4CDAFE/4CDAFE.png) #4CDAFE |
| beige foncé | ![#FFD217](https://placehold.co/10x10/FFD217/FFD217.png) #FFD217 |
| vert | ![#67EB00](https://placehold.co/10x10/67EB00/67EB00.png) #67EB00 |
| mauve clair | ![#DD67ED](https://placehold.co/10x10/DD67ED/DD67ED.png) #DD67ED |



## Guide d'utilisation

* [Notice d’utilisation PDF](https://drive.google.com/file/d/1eJQVIbXojgwJAjK8qin-A1Yq0Aaun63N/view?usp=sharing)


## Guide d’installation

* [Notice d’installation PDF](https://drive.google.com/file/d/1Ip1xgkHyk78BL5WucTI9bh4KQ6w3NnVH/view?usp=sharing)


## Développement

Le code de l'application se trouve dans `Projet/`. Il nécessite Flutter 3.47+ (Dart 3.13+) et un JDK 17.

```bash
cd Projet
flutter pub get
flutter test
flutter run
```

* Après une modification de `lib/BackEnd/PlayerProgress/player.dart`, régénérer les adaptateurs Hive avec `dart run build_runner build`.
* **Règles Firestore** : elles se trouvent dans `Projet/firestore.rules` et se déploient avec `firebase deploy --only firestore:rules` (Firebase CLI).
* **Signature release Android** : créer `Projet/android/key.properties` (jamais versionné) contenant `storeFile`, `storePassword`, `keyAlias` et `keyPassword`. Sans ce fichier, la build release est signée avec la clé de debug. Les APK sont ensuite générés avec `flutter build apk --release --split-per-abi`.
* **iOS** : ajouter `GoogleService-Info.plist` (ou lancer `flutterfire configure`) avant de compiler pour iOS.

## Remerciement

* Nous souhaitons exprimer nos sincères remerciements à Mr Balla A. et Mme Bourai S. pour leur encadrement précieux tout au long de ce projet. Leur expertise, leurs conseils et leur soutien nous ont permis de mener à bien notre travail.
* Un grand merci à vous, utilisateurs de notre projet, pour votre confiance et l'utilisation de notre produit au service de votre association caritative.
