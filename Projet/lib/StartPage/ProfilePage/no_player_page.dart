import 'package:flutter/material.dart';

import '../../composents/app_theme.dart';
import '../../composents/navigation.dart';
import '../../composents/ui/app_button.dart';

/// Shown on the profile page when no child profile is selected yet.
class NoPlayerSelectedPage extends StatelessWidget {
  const NoPlayerSelectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg-image2.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Stack(
            children: [
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
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.child_care_rounded, size: 52, color: AppColors.lightBlue),
                      const SizedBox(height: 8),
                      const Text(
                        'Aucun profil choisi',
                        style: TextStyle(fontFamily: 'Digital', fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Choisis qui joue pour voir sa progression.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Digital', color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        label: 'Choisir un profil',
                        icon: Icons.people_rounded,
                        color: AppColors.green,
                        onTap: () => Navigator.pushNamed(context, '/ChildSelector'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
