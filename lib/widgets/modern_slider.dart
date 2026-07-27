import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ModernSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const ModernSlider({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.background,
            thumbColor: AppColors.secondary,
            trackHeight: 6.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
          ),
          child: Slider(value: value, min: 0, max: 100, onChanged: onChanged),
        ),
      ],
    );
  }
}
