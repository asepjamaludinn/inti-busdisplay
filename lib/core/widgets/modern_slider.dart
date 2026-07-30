import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ModernSlider extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final double value;
  final ValueChanged<double> onChanged;

  const ModernSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon = Icons.tune_rounded,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                value.toInt().toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: AppColors.background,
            thumbColor: Colors.white,
            trackHeight: 6.0,
            overlayColor: color.withValues(alpha: 0.2),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10.0,
              elevation: 4,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
          ),
          child: Slider(value: value, min: 0, max: 100, onChanged: onChanged),
        ),
      ],
    );
  }
}
