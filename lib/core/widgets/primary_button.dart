import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isOutline;
  final List<Color>? gradient;
  final Color? tintColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isOutline = false,
    this.gradient,
    this.tintColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool useGradient = gradient != null;
    final Color base = tintColor ?? AppColors.primary;

    return Material(
      color: useGradient
          ? Colors.transparent
          : (isOutline ? base.withValues(alpha: 0.08) : base),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            gradient: useGradient
                ? LinearGradient(
                    colors: gradient!,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            border: isOutline
                ? Border.all(color: base.withValues(alpha: 0.25), width: 1.2)
                : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: useGradient
                ? [
                    BoxShadow(
                      color: gradient!.last.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: (isOutline && !useGradient) ? base : Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: (isOutline && !useGradient) ? base : Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
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
