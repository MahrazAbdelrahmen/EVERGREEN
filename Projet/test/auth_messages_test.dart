import 'package:flutter_test/flutter_test.dart';
import 'package:sorttrash/BackEnd/AuthService/auth_service.dart';

void main() {
  test('Firebase auth errors are explained in French', () {
    expect(authErrorMessage('invalid-credential'), 'E-mail ou mot de passe incorrect.');
    expect(authErrorMessage('wrong-password'), 'E-mail ou mot de passe incorrect.');
    expect(authErrorMessage('email-already-in-use'), contains('déjà utilisé'));
    expect(authErrorMessage('weak-password'), contains('6 caractères'));
    expect(authErrorMessage('network-request-failed'), 'Pas de connexion internet.');
    expect(authErrorMessage('something-new'), 'Une erreur est survenue. Réessaie.');
  });
}
