import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sorttrash/player_box.dart';

import '../../../composents/app_theme.dart';
import '../../../composents/ui/app_button.dart';
import '../../../composents/ui/pressable.dart';

/// Creates a child profile: name, age and avatar, with a live preview.
/// Pops with the new child's id so the profile picker can select it.
class AddPlayer extends StatefulWidget {
  const AddPlayer({super.key});

  @override
  State<AddPlayer> createState() => _AddPlayer();
}

class _AddPlayer extends State<AddPlayer> {
  // Bounds enforced by DataBaseService.addElementProgress.
  static const _minAge = 4;
  static const _maxAge = 99;
  // assets/profiles/13.png is a trophy, not an avatar.
  static final _avatars = [for (int i = 0; i < 13; i++) 'assets/profiles/$i.png'];

  final User? user = FirebaseAuth.instance.currentUser;
  final _nameController = TextEditingController();
  String profileImage = _avatars.first;
  int childAge = 7;

  String get _name => _nameController.text.trim();
  bool get _isValid => _name.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _create() {
    if (!_isValid) return;
    int newChildId = -1;
    try {
      if (currentProfileIndex == 1) {
        offlineProgress.addElementProgress(_name, childAge, profileImage);
        offlineGlobalPlayers = offlineProgress.returnPlayers();
        parentBox.putAt(0, offlineProgress.returnParent());
        newChildId = offlineGlobalPlayers.last.childID;
      } else if (user != null) {
        onlineProgress.addElementProgress(_name, childAge, profileImage);
        onlineParentBox.put(onlineProgress.getUID(), onlineProgress.returnParent());
        playersOnline = onlineProgress.returnPlayers();
        onlineProgress.returnParent().updateData(onlineProgress.getUID());
        newChildId = playersOnline.last.childID;
      }
    } on Exception catch (e) {
      debugPrint('$e');
    }
    HapticFeedback.mediumImpact();
    Navigator.pop(context, newChildId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Let the keyboard cover the bottom instead of squeezing the one-page layout.
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg-image2.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Row(
                  children: [
                    RoundIconButton(
                      icon: Icons.arrow_back_rounded,
                      color: AppColors.darkBeige,
                      tooltip: 'Retour',
                      onTap: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Nouveau profil',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Digital',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Center(child: _preview())),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 24, 8),
                        child: Center(child: _form()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _preview() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Container(
            key: ValueKey(profileImage),
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10)],
            ),
            child: CircleAvatar(
              radius: 52,
              backgroundColor: AppColors.lightBlue.withValues(alpha: 0.3),
              child: ClipOval(child: Image.asset(profileImage, height: 94, width: 94)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _isValid ? '$_name, $childAge ans' : 'Ton prénom ?',
            style: TextStyle(
              fontFamily: 'Digital',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isValid ? Colors.black87 : Colors.black38,
            ),
          ),
        ),
        const SizedBox(height: 14),
        AppButton(
          label: 'Créer le profil',
          icon: Icons.check_rounded,
          color: AppColors.green,
          onTap: _isValid ? _create : null,
        ),
      ],
    );
  }

  Widget _form() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Label('Prénom'),
                    TextField(
                      controller: _nameController,
                      maxLength: 15,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      decoration: const InputDecoration(
                        hintText: 'Ex : Lina',
                        prefixIcon: Icon(Icons.badge_rounded),
                        counterText: '',
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Label('Âge'),
                  _AgeStepper(
                    age: childAge,
                    onChanged: (age) => setState(() => childAge = age),
                    min: _minAge,
                    max: _maxAge,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _Label('Avatar'),
          LayoutBuilder(
            builder: (context, constraints) {
              // Two rows of seven, sized to the card's width.
              const perRow = 7;
              const gap = 6.0;
              final cell = ((constraints.maxWidth - gap * (perRow - 1)) / perRow)
                  .clamp(32.0, 52.0);
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final avatar in _avatars)
                    Pressable(
                      onTap: () => setState(() => profileImage = avatar),
                      semanticLabel: 'Avatar',
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: cell,
                        height: cell,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade100,
                          border: Border.all(
                            color: avatar == profileImage
                                ? AppColors.green
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(child: Image.asset(avatar)),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text,
          style: const TextStyle(
              fontFamily: 'Digital', fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

class _AgeStepper extends StatelessWidget {
  const _AgeStepper({
    required this.age,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  final int age;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RoundIconButton(
          icon: Icons.remove_rounded,
          color: AppColors.lightBlue,
          size: 36,
          tooltip: 'Moins',
          onTap: age > min ? () => onChanged(age - 1) : null,
        ),
        SizedBox(
          width: 56,
          child: Text(
            '$age',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: 'Digital', fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        RoundIconButton(
          icon: Icons.add_rounded,
          color: AppColors.lightBlue,
          size: 36,
          tooltip: 'Plus',
          onTap: age < max ? () => onChanged(age + 1) : null,
        ),
      ],
    );
  }
}
