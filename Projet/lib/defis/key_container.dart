import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../composents/ui/pressable.dart';

const Color pm = Color.fromRGBO(177, 229, 242, 1);
const Color sm = Color.fromRGBO(131, 85, 253, 1);
const Color sm1 = Color.fromRGBO(253, 194, 17, 1);

/// One challenge key: a gold key once unlocked, a faded violet key with a
/// padlock while locked. The newest challenge bounces with a "Nouveau !" tag.
class KeyTile extends StatefulWidget {
  const KeyTile({
    super.key,
    required this.number,
    required this.size,
    required this.locked,
    required this.isNew,
    required this.onTap,
    required this.onLockedTap,
  });

  final int number;
  final double size;
  final bool locked;
  final bool isNew;
  final VoidCallback onTap;
  final VoidCallback onLockedTap;

  @override
  State<KeyTile> createState() => _KeyTileState();
}

class _KeyTileState extends State<KeyTile> with TickerProviderStateMixin {
  late final _bounce = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
  late final _wobble = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));

  @override
  void initState() {
    super.initState();
    if (widget.isNew) _bounce.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(KeyTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isNew && !_bounce.isAnimating) {
      _bounce.repeat(reverse: true);
    } else if (!widget.isNew && _bounce.isAnimating) {
      _bounce
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _bounce.dispose();
    _wobble.dispose();
    super.dispose();
  }

  void _tap() {
    if (widget.locked) {
      HapticFeedback.heavyImpact();
      _wobble.forward(from: 0);
      widget.onLockedTap();
    } else {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final accent = widget.locked ? sm : sm1;
    return Pressable(
      onTap: _tap,
      semanticLabel: 'Défi ${widget.number}${widget.locked ? ', verrouillé' : ''}',
      child: AnimatedBuilder(
        animation: Listenable.merge([_bounce, _wobble]),
        builder: (context, child) {
          final hop = -6 * Curves.easeInOut.transform(_bounce.value);
          final wobble = math.sin(_wobble.value * math.pi * 5) * 0.12 * (1 - _wobble.value);
          return Transform.translate(
            offset: Offset(0, hop),
            child: Transform.rotate(angle: wobble, child: child),
          );
        },
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Tile with the key.
              Container(
                width: size,
                height: size * 0.82,
                decoration: BoxDecoration(
                  color: widget.locked ? pm.withValues(alpha: 0.75) : pm,
                  borderRadius: BorderRadius.circular(size * 0.18),
                  border: Border.all(width: 2, color: Colors.white),
                  boxShadow: [BoxShadow(color: accent, offset: const Offset(0, 6))],
                ),
                padding: EdgeInsets.fromLTRB(size * 0.18, size * 0.08, size * 0.18, size * 0.22),
                child: Opacity(
                  opacity: widget.locked ? 0.55 : 1,
                  child: Image.asset(
                    widget.locked ? 'assets/images/violet_key.png' : 'assets/images/gold_key.png',
                  ),
                ),
              ),
              // Number plaque.
              Positioned(
                top: size * 0.6,
                child: Container(
                  width: size * 0.66,
                  height: size * 0.3,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(size * 0.15),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '${widget.number}',
                      style: TextStyle(
                        fontFamily: 'Digital',
                        color: Colors.white,
                        fontSize: size * 0.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.locked)
                Positioned(
                  top: -6,
                  right: -6,
                  child: CircleAvatar(
                    radius: size * 0.14,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.lock_rounded, size: size * 0.18, color: sm),
                  ),
                ),
              if (widget.isNew)
                Positioned(
                  top: -14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Text(
                      'Nouveau !',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Digital',
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
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
