import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

enum PremiumButtonVariant { primary, secondary, success, danger, ghost }

class PremiumButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final PremiumButtonVariant variant;
  final bool isLoading;
  final bool isExpanded;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const PremiumButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.variant = PremiumButtonVariant.primary,
    this.isLoading = false,
    this.isExpanded = false,
    this.width,
    this.height = 52,
    this.borderRadius = 16,
    this.padding,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.92,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Color get _bgColor {
    switch (widget.variant) {
      case PremiumButtonVariant.primary:
        return AppColors.primary;
      case PremiumButtonVariant.secondary:
        return AppColors.secondary;
      case PremiumButtonVariant.success:
        return AppColors.success;
      case PremiumButtonVariant.danger:
        return AppColors.error;
      case PremiumButtonVariant.ghost:
        return Colors.white.withOpacity(0.12);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    final bool showShimmer =
        !isDisabled && widget.variant == PremiumButtonVariant.primary;

    final scaleButton = ScaleTransition(
      scale: _scaleController,
      child: Container(
        width: widget.isExpanded ? double.infinity : widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _bgColor,
              _bgColor.withBlue((_bgColor.blue - 20).clamp(0, 255)),
            ],
          ),
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: _bgColor.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
          border: Border.all(
            color: Colors.white.withOpacity(0.18),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onTap: isDisabled ? null : widget.onPressed,
            onTapDown: (_) {
              if (isDisabled) return;
              setState(() => _pressed = true);
              _scaleController.reverse();
            },
            onTapUp: (_) {
              if (isDisabled) return;
              setState(() => _pressed = false);
              _scaleController.forward();
            },
            onTapCancel: () {
              setState(() => _pressed = false);
              _scaleController.forward();
            },
            child: Padding(
              padding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              child: Row(
                mainAxisSize:
                    widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  else ...[
                    if (widget.icon != null) ...[
                      Icon(widget.icon,
                          size: 20,
                          color: widget.variant == PremiumButtonVariant.ghost
                              ? Colors.white
                              : Colors.white),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        widget.text,
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final button = showShimmer
        ? scaleButton.animate().shimmer(
              duration: 2200.ms,
              color: Colors.white.withOpacity(0.2),
            )
        : scaleButton;

    return Opacity(
      opacity: isDisabled ? 0.55 : 1.0,
      child: button,
    );
  }
}

class IconGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;

  const IconGlassButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (color ?? Colors.white).withOpacity(0.14),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(icon, color: Colors.white, size: size * 0.5),
        ),
      ),
    );
  }
}
