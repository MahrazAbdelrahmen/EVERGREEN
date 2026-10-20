import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'button.dart';
import 'composents/app_theme.dart';
import 'composents/ui/pressable.dart';

/// Menu card (dans le UI): a coloured frame around a white panel with a
/// picture, and the title on a plaque at the bottom. Navigates to a route.
class cardBg extends StatelessWidget {
  final String Photo; //pour insere la photo;
  final String? title; //pour rajouter de contenu dans le frame
  final Color coleur1;
  final Color coleur2;
  final Color couleur3;
  final String href;
  final double width;
  final double height;
  final String? badge;
  final String? badgeAsset;
  final int floatIndex;
  const cardBg({
    super.key,
    required this.title,
    required this.coleur1,
    required this.coleur2,
    required this.couleur3,
    required this.href,
    required this.Photo,
    this.width = 180,
    this.height = 250,
    this.badge,
    this.badgeAsset,
    this.floatIndex = 0,
  });
  @override
  Widget build(BuildContext context) {
    return MenuCard(
      title: title,
      photo: Photo,
      frameColor: coleur2,
      plaqueShadowColor: coleur1,
      panelColor: couleur3,
      width: width,
      height: height,
      badge: badge,
      badgeAsset: badgeAsset,
      floatIndex: floatIndex,
      onTap: () => Navigator.pushReplacementNamed(context, href),
    );
  }
}

/// Same card, opening a widget instead of a named route.
class CardBgWithWidget extends StatelessWidget {
  final String Photo; //pour insere la photo;
  final String? title; //pour rajouter de contenu dans le frame
  final Color coleur1;
  final Color coleur2;
  final Color couleur3;
  final Widget href;
  final double width;
  final double height;
  final String? badge;
  final int floatIndex;
  const CardBgWithWidget({
    super.key,
    required this.title,
    required this.coleur1,
    required this.coleur2,
    required this.couleur3,
    required this.href,
    required this.Photo,
    this.width = 180,
    this.height = 250,
    this.badge,
    this.floatIndex = 0,
  });
  @override
  Widget build(BuildContext context) {
    return MenuCard(
      title: title,
      photo: Photo,
      frameColor: coleur2,
      plaqueShadowColor: coleur1,
      panelColor: couleur3,
      width: width,
      height: height,
      badge: badge,
      floatIndex: floatIndex,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => href)),
    );
  }
}

class MenuCard extends StatefulWidget {
  const MenuCard({
    super.key,
    required this.title,
    required this.photo,
    required this.frameColor,
    required this.plaqueShadowColor,
    required this.panelColor,
    required this.width,
    required this.height,
    required this.onTap,
    this.badge,
    this.badgeAsset,
    this.floatIndex = 0,
  });

  final String? title;
  final String photo;
  final Color frameColor;
  final Color plaqueShadowColor;
  final Color panelColor;
  final double width;
  final double height;
  final VoidCallback onTap;
  final String? badge;

  /// Picture shown before [badge]; a star when null.
  final String? badgeAsset;

  /// Position in its row, so neighbouring cards bob out of step.
  final int floatIndex;

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> with SingleTickerProviderStateMixin {
  late final _float = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))
    ..repeat();

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width;
    final h = widget.height;
    final frameHeight = h * 0.92;
    return Pressable(
      pressedScale: 0.95,
      onTap: widget.onTap,
      semanticLabel: widget.title,
      child: AnimatedBuilder(
        animation: _float,
        builder: (context, child) {
          final phase = _float.value * 2 * math.pi + widget.floatIndex * 1.3;
          return Transform.translate(offset: Offset(0, math.sin(phase) * 4), child: child);
        },
        child: SizedBox(
          width: w,
          height: h,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Coloured frame with its shadow.
              Container(
                width: w,
                height: frameHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(27),
                  color: widget.frameColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 70, 67, 67),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
              // White panel holding the picture.
              Positioned(
                top: 4,
                left: 5,
                right: 5,
                child: Container(
                  height: frameHeight - 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: widget.panelColor,
                  ),
                  padding: EdgeInsets.fromLTRB(12, 12, 12, h * 0.12),
                  child: Image.asset('assets/images/${widget.photo}', fit: BoxFit.contain),
                ),
              ),
              // Title plaque straddling the bottom edge.
              Positioned(
                top: frameHeight - 24,
                child: Transform.scale(
                  scale: (w / 180).clamp(1.0, 1.4),
                  child: RectangleButton(
                    couleur2: widget.frameColor,
                    couleur1: widget.plaqueShadowColor,
                    text: widget.title,
                  ),
                ),
              ),
              if (widget.badge != null)
                Positioned(
                  top: -10,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: widget.frameColor, width: 2),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 2))],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.badgeAsset == null
                            ? const Icon(Icons.star_rounded, color: AppColors.darkBeige, size: 18)
                            : Image.asset(widget.badgeAsset!, height: 16),
                        const SizedBox(width: 3),
                        Text(
                          widget.badge!,
                          style: const TextStyle(
                            fontFamily: 'Digital',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
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
