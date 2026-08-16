import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/display_settings_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/modern_slider.dart';

class DisplaySettingCard extends StatelessWidget {
  const DisplaySettingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<DisplaySettingsProvider>();

    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaturan Tampilan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 18),
          ModernSlider(
            label: 'Kecepatan Scroll',
            icon: Icons.speed_rounded,
            color: AppColors.secondary,
            value: settingsProvider.speed,
            onChanged: (val) => settingsProvider.setSpeed(val),
          ),
          const SizedBox(height: 16),
          ModernSlider(
            label: 'Kecerahan',
            icon: Icons.brightness_6_rounded,
            color: AppColors.amberDeep,
            value: settingsProvider.brightness,
            onChanged: (val) => settingsProvider.setBrightness(val),
          ),
          const SizedBox(height: 16),
          ModernSlider(
            label: 'Ukuran Font',
            icon: Icons.format_size_rounded,
            color: AppColors.primary,
            value: settingsProvider.fontSize,
            onChanged: (val) => settingsProvider.setFontSize(val),
          ),
        ],
      ),
    );
  }
}
