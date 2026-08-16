import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/enums/character_type.dart';

/// Premium bird preview - fixed for light themes, no washed-out white blob.

class AnimatedBirdPreview extends StatefulWidget {
  final CharacterData character;
  final double size;
  const AnimatedBirdPreview(
      {super.key, required this.character, this.size = 100});

  @override
  State<AnimatedBirdPreview> createState() => _AnimatedBirdPreviewState();
}

class _AnimatedBirdPreviewState extends State<AnimatedBirdPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final y = math.sin(_ctrl.value * math.pi * 2) * 7;
        final tilt = math.sin(_ctrl.value * math.pi * 2) * 0.08;
        return Transform.translate(
          offset: Offset(0, y),
          child: Transform.rotate(angle: tilt, child: child),
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.character.primaryColor,
              widget.character.secondaryColor
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: widget.character.primaryColor.withOpacity(0.5),
              blurRadius: 28,
              spreadRadius: 2,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.85), width: 2.5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Inner shine circle for depth
            Positioned(
              top: widget.size * 0.12,
              left: widget.size * 0.18,
              child: Container(
                width: widget.size * 0.28,
                height: widget.size * 0.28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.22),
                ),
              ),
            ),

            // Icon - NOT white, dark outline + white for AAA contrast
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                widget.character.icon,
                size: widget.size * 0.52,
                color: Colors.white,
                shadows: [
                  Shadow(
                      color: Colors.black.withOpacity(0.35),
                      offset: const Offset(0, 2),
                      blurRadius: 6),
                ],
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.08, 1.08),
                    duration: 650.ms,
                    curve: Curves.easeInOut)
                .then()
                .scale(
                    begin: const Offset(1.08, 1.08),
                    end: const Offset(1, 1),
                    duration: 650.ms),

            // Eye highlight - subtle, not dominating
            Positioned(
              top: widget.size * 0.26,
              right: widget.size * 0.24,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.black.withOpacity(0.1), width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.15), blurRadius: 3)
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                        color: Color(0xFF1A1A2E), shape: BoxShape.circle),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
