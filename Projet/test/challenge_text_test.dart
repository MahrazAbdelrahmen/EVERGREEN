import 'package:flutter_test/flutter_test.dart';
import 'package:sorttrash/defis/show_challenge_screen.dart';

void main() {
  test('readableChallengeText turns shouted text into a sentence', () {
    expect(readableChallengeText('PRÉPAREZ UN DÉJEUNER SANS DÉCHETS.'), 'Préparez un déjeuner sans déchets.');
    expect(
      readableChallengeText('FABRIQUEZ DES PETITS BACS EN CARTON   DE RECYCLAGE.'),
      'Fabriquez des petits bacs en carton de recyclage.',
    );
  });

  test('readableChallengeText keeps normal sentences and capitalises them', () {
    expect(readableChallengeText('Démarrez un composteur.'), 'Démarrez un composteur.');
    expect(readableChallengeText("organisez un événement."), "Organisez un événement.");
  });
}
