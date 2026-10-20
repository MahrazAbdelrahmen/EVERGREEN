import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sorttrash/BackEnd/PlayerProgress/player.dart';
import 'package:uuid/uuid.dart';

import '../../composents/app_theme.dart';
import '../../composents/ui/app_button.dart';
import '../../player_box.dart';

/// Waits for the new account's e-mail to be verified, then opens the profiles.
class VerifyUserEmail extends StatefulWidget {
  const VerifyUserEmail({super.key});
  @override
  State<VerifyUserEmail> createState() => _VerifyUserEmailState();
}

class _VerifyUserEmailState extends State<VerifyUserEmail> {
  static const _resendDelay = 30;

  late final User user = FirebaseAuth.instance.currentUser!;
  late final Timer _check;
  Timer? _countdown;
  int _secondsBeforeResend = _resendDelay;

  @override
  void initState() {
    super.initState();
    user.sendEmailVerification();
    _startCountdown();
    _check = Timer.periodic(const Duration(seconds: 3), (_) => _checkVerified());
  }

  @override
  void dispose() {
    _check.cancel();
    _countdown?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdown?.cancel();
    setState(() => _secondsBeforeResend = _resendDelay);
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _secondsBeforeResend--);
      if (_secondsBeforeResend <= 0) timer.cancel();
    });
  }

  void _resend() {
    user.sendEmailVerification();
    _startCountdown();
  }

  Future<void> _cancel() async {
    final navigator = Navigator.of(context);
    _check.cancel();
    try {
      await user.delete();
    } catch (e) {
      debugPrint('$e');
    }
    await FirebaseAuth.instance.signOut();
    navigator.pushNamedAndRemoveUntil('/StartPage', (route) => false);
  }

  Future<void> _checkVerified() async {
    try {
      final current = FirebaseAuth.instance.currentUser;
      if (current == null) return;
      await current.reload();
      if (!(FirebaseAuth.instance.currentUser?.emailVerified ?? false)) return;
      _check.cancel();
      // Create the family's online record, without overwriting an existing one.
      final existing = await Parent([], 0, '').fetchParentData(current.uid);
      final parent = existing ?? Parent([], 0, const Uuid().v4());
      if (existing == null) parent.createData(current.uid);
      // Ready the new account for online profiles.
      onlineProgress.setUID(current.uid);
      onlineProgress.setParent(parent);
      onlineProgress.setPlayers(parent.children);
      playersOnline = onlineProgress.returnPlayers();
      onlineParentBox.put(current.uid, parent);
      currentProfileIndex = 0;
      if (mounted) Navigator.of(context).pushReplacementNamed('/ChildSelector');
    } on FirebaseAuthException catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg-image.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 460),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 6))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.mark_email_unread_rounded, size: 56, color: AppColors.lightBlue),
                  const SizedBox(height: 8),
                  const Text(
                    'Vérifie ton e-mail',
                    style: TextStyle(fontFamily: 'Digital', fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(children: [
                      const TextSpan(text: 'On a envoyé un lien à '),
                      TextSpan(text: user.email ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: '. Clique dessus, puis reviens ici !'),
                    ]),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.5)),
                      SizedBox(width: 10),
                      Text('En attente de vérification…', style: TextStyle(fontFamily: 'Digital', color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton(
                        label: _secondsBeforeResend > 0 ? 'Renvoyer (${_secondsBeforeResend}s)' : 'Renvoyer',
                        icon: Icons.refresh_rounded,
                        color: AppColors.lightBlue,
                        fontSize: 15,
                        onTap: _secondsBeforeResend > 0 ? null : _resend,
                      ),
                      const SizedBox(width: 12),
                      AppButton(
                        label: 'Annuler',
                        icon: Icons.close_rounded,
                        color: Colors.redAccent,
                        fontSize: 15,
                        onTap: _cancel,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
