import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sorttrash/BackEnd/AuthService/user_info.dart';
import 'package:sorttrash/player_box.dart';

/// Account actions. Each returns null on success, or a message in French to
/// show the player.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserInfos? _userfromfirebaseUser( User? user ){ /// this is a method to get user uid from a FirebaseUser to use to login
    return user != null ? UserInfos(uid: user.uid) : null;
  }
  Stream<UserInfos?> get user { /// A stream of UserInfos objects are returned by the code's defined getter function.
    return _auth.authStateChanges()
        .map(_userfromfirebaseUser); /// the map method is used to transform each event in the stream of authentication state changes, from FireBaseUser to UserInfos
  }
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userfromfirebaseUser(user);
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return authErrorMessage(e.code);
    } catch (e) {
      debugPrint('$e');
      return authErrorMessage('');
    }
  }

  /// Signs in and loads this family's online profiles.
  Future<String?> logIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final uid = credential.user!.uid;
      final parent = await onlineParent.fetchParentData(uid);
      onlineProgress.setUID(uid);
      if (parent != null) {
        onlineProgress.setParent(parent);
        onlineProgress.setPlayers(parent.children);
        playersOnline = onlineProgress.returnPlayers();
        onlineParentBox.put(uid, parent);
        parent.syncLeaderboard(uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return authErrorMessage(e.code);
    } catch (e) {
      debugPrint('$e');
      return authErrorMessage('');
    }
  }

  Future<String?> registerWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return authErrorMessage(e.code);
    } catch (e) {
      debugPrint('$e');
      return authErrorMessage('');
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      debugPrint('$error');
      return null;
    }
  }
}

/// Firebase error codes, explained simply in French.
String authErrorMessage(String code) => switch (code) {
      'invalid-credential' || 'wrong-password' || 'user-not-found' || 'INVALID_LOGIN_CREDENTIALS' =>
        'E-mail ou mot de passe incorrect.',
      'invalid-email' => 'Cette adresse e-mail n\'est pas valide.',
      'email-already-in-use' => 'Cet e-mail est déjà utilisé. Essaie de te connecter.',
      'weak-password' => 'Mot de passe trop faible : au moins 6 caractères.',
      'user-disabled' => 'Ce compte a été désactivé.',
      'too-many-requests' => 'Trop d\'essais. Réessaie dans quelques minutes.',
      'network-request-failed' => 'Pas de connexion internet.',
      'missing-email' => 'Entre ton adresse e-mail.',
      _ => 'Une erreur est survenue. Réessaie.',
    };
