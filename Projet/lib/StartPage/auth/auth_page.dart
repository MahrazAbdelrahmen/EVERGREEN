import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../BackEnd/AuthService/auth_service.dart';
import '../../composents/app_theme.dart';
import '../../composents/brand.dart';
import '../../composents/navigation.dart';
import '../../composents/ui/app_button.dart';
import '../../composents/ui/pressable.dart';
import '../../player_box.dart';

enum AuthMode { login, register, reset }

/// Sign in, create an account, or get a password-reset link — one screen.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.initialMode = AuthMode.login});
  final AuthMode initialMode;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _auth = AuthService();
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  late AuthMode _mode = widget.initialMode;
  bool _busy = false;
  bool _showPassword = false;
  String? _error;
  String? _success;

  @override
  void initState() {
    super.initState();
    // An account left unverified is removed so the e-mail can be used again.
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      user.delete();
      FirebaseAuth.instance.signOut();
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _switchTo(AuthMode mode) {
    if (_busy || mode == _mode) return;
    HapticFeedback.selectionClick();
    setState(() {
      _mode = mode;
      _error = null;
      _success = null;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
      _success = null;
    });
    final email = _email.text.trim();
    final password = _password.text;
    final navigator = Navigator.of(context);

    final error = switch (_mode) {
      AuthMode.login => await _auth.logIn(email, password),
      AuthMode.register => await _auth.registerWithEmail(email, password),
      AuthMode.reset => await _auth.resetPassword(email),
    };
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      HapticFeedback.heavyImpact();
      setState(() => _error = error);
      return;
    }
    switch (_mode) {
      case AuthMode.login:
        currentProfileIndex = 0; // land on the online profiles
        navigator.pushReplacementNamed('/ChildSelector');
      case AuthMode.register:
        navigator.pushReplacementNamed('/VerifyUserEmail');
      case AuthMode.reset:
        setState(() => _success = '📧 Lien envoyé à $email. Regarde ta boîte mail !');
    }
  }

  String get _greeting => switch (_mode) {
        AuthMode.login => 'Content de te revoir !',
        AuthMode.register => 'Crée un compte pour sauvegarder ta progression en ligne !',
        AuthMode.reset => 'Pas de panique, on t\'envoie un lien pour changer ton mot de passe !',
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg-image.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(flex: 4, child: _mascot()),
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(8, 12, 32, 12),
                        child: _card(),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 20,
                top: 8,
                child: RoundIconButton(
                  icon: Icons.arrow_back_rounded,
                  color: AppColors.darkBeige,
                  tooltip: 'Retour',
                  onTap: () => goBack(context, '/StartPage'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The logo and Terry with a speech bubble that changes with the mode.
  Widget _mascot() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 56, 8, 16),
      child: Column(
        children: [
          const Expanded(flex: 3, child: FittedBox(child: EvergreenWordmark())),
          const SizedBox(height: 8),
          Expanded(
            flex: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Expanded(flex: 2, child: FittedBox(child: BlinkingTerry())),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                      child: Container(
                        key: ValueKey(_mode),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                            bottomLeft: Radius.circular(4),
                          ),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
                        ),
                        child: Text(
                          _greeting,
                          style: const TextStyle(fontFamily: 'Digital', fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card() {
    final register = _mode == AuthMode.register;
    final reset = _mode == AuthMode.reset;
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Form(
        key: _form,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (reset)
                const Text(
                  'Mot de passe oublié',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Digital', fontSize: 22, fontWeight: FontWeight.bold),
                )
              else
                _Tabs(mode: _mode, onChanged: _switchTo),
              const SizedBox(height: 14),
              _field(
                controller: _email,
                label: 'E-mail',
                icon: Icons.email_rounded,
                keyboard: TextInputType.emailAddress,
                validator: (v) => v != null && EmailValidator.validate(v.trim()) ? null : 'Adresse e-mail invalide',
              ),
              if (!reset) ...[
                const SizedBox(height: 10),
                _field(
                  controller: _password,
                  label: 'Mot de passe',
                  icon: Icons.lock_rounded,
                  obscure: !_showPassword,
                  suffix: IconButton(
                    tooltip: _showPassword ? 'Cacher' : 'Afficher',
                    icon: Icon(_showPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                    onPressed: () => setState(() => _showPassword = !_showPassword),
                  ),
                  validator: (v) => v != null && v.length >= 6 ? null : 'Au moins 6 caractères',
                ),
              ],
              if (register) ...[
                const SizedBox(height: 10),
                _field(
                  controller: _confirm,
                  label: 'Confirme le mot de passe',
                  icon: Icons.lock_outline_rounded,
                  obscure: !_showPassword,
                  validator: (v) => v == _password.text ? null : 'Les mots de passe ne correspondent pas',
                ),
              ],
              if (_error != null) _Banner(text: _error!, error: true),
              if (_success != null) _Banner(text: _success!, error: false),
              const SizedBox(height: 14),
              AppButton(
                label: switch (_mode) {
                  AuthMode.login => _busy ? 'Connexion…' : 'Se connecter',
                  AuthMode.register => _busy ? 'Création…' : 'Créer mon compte',
                  AuthMode.reset => _busy ? 'Envoi…' : 'Envoyer le lien',
                },
                icon: _busy
                    ? Icons.hourglass_top_rounded
                    : switch (_mode) {
                        AuthMode.login => Icons.login_rounded,
                        AuthMode.register => Icons.person_add_rounded,
                        AuthMode.reset => Icons.send_rounded,
                      },
                color: AppColors.green,
                expand: true,
                onTap: _busy ? null : _submit,
              ),
              const SizedBox(height: 6),
              if (_mode == AuthMode.login)
                TextButton(
                  onPressed: () => _switchTo(AuthMode.reset),
                  child: const Text('Mot de passe oublié ?', style: TextStyle(fontFamily: 'Digital', fontWeight: FontWeight.bold)),
                ),
              if (reset)
                TextButton.icon(
                  onPressed: () => _switchTo(AuthMode.login),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Retour à la connexion', style: TextStyle(fontFamily: 'Digital', fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboard,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboard,
      obscureText: obscure,
      autocorrect: false,
      enableSuggestions: !obscure,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        if (_mode == AuthMode.reset || controller == (_mode == AuthMode.register ? _confirm : _password)) _submit();
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

/// Connexion | Inscription switch.
class _Tabs extends StatelessWidget {
  const _Tabs({required this.mode, required this.onChanged});
  final AuthMode mode;
  final ValueChanged<AuthMode> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget tab(String label, AuthMode value) {
      final selected = mode == value;
      return Expanded(
        child: Pressable(
          onTap: () => onChanged(value),
          semanticLabel: label,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: selected ? AppColors.lightBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Digital',
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.black54,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [tab('Connexion', AuthMode.login), tab('Inscription', AuthMode.register)]),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.text, required this.error});
  final String text;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final color = error ? Colors.redAccent : AppColors.green;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            Icon(error ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: TextStyle(color: color.withValues(alpha: 1), fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
