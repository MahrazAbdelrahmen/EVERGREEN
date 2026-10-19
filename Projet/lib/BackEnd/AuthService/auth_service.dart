import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sorttrash/BackEnd/AuthService/user_info.dart';
import 'package:sorttrash/player_box.dart';

import '../../main.dart';

class AuthService {
  bool error = false;
  String errorMessage = '';
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
  Future<void> resetPassword(String email) async {
    error = false;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      error  = true;
      errorMessage = e.toString();
    }

  }

  Future logIn( String email, String password ) async {
    error = false;
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email, password: password);
      final uid = credential.user!.uid;
      final parent = await onlineParent.fetchParentData(uid);
      onlineProgress.setUID(uid);
      if (parent != null) {
        onlineProgress.setParent(parent);
        onlineProgress.setPlayers(parent.children);
        playersOnline = onlineProgress.returnPlayers();
        onlineParentBox.put(uid, parent);
      }
    }
    on FirebaseAuthException   catch (e) {
      error  = true;
      errorMessage = e.message ?? e.code;
    }
    on Exception catch (e) {
      debugPrint('$e');
      error  = true;
      errorMessage = e.toString();
    }

    if (!error) {
        navigatorKey.currentState!.pushNamed('/ChildSelector');
    }
  }

  Future registerWithEmail( String email, String password ) async {
    error = false;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email, password: password);

    }
    on FirebaseAuthException catch (e) {
      error  = true;
      errorMessage = e.message ?? e.code;
    }
    if ( !error  ) {
      navigatorKey.currentState!.pushReplacementNamed('/VerifyUserEmail');
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