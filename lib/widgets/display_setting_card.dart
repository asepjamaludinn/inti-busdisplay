import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/display_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'modern_slider.dart';

class DisplaySettingCard extends StatelessWidget {
  const DisplaySettingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DisplayController>();

    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Display Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Animation Mode',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.background, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.animMode,
                isExpanded: true,
                items:
                    [
                          'Running',
                          'Static',
                          'Blink',
                          'Scroll Left',
                          'Scroll Right',
                          'Scroll Up',
                          'Scroll Down',
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => controller.setAnimMode(val!),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ModernSlider(
            label: 'Scroll Speed',
            value: controller.speed,
            onChanged: (val) => controller.setSpeed(val),
          ),
          const SizedBox(height: 12),
          ModernSlider(
            label: 'Brightness',
            value: controller.brightness,
            onChanged: (val) => controller.setBrightness(val),
          ),
          const SizedBox(height: 12),
          ModernSlider(
            label: 'Font Size',
            value: controller.fontSize,
            onChanged: (val) => controller.setFontSize(val),
          ),
        ],
      ),
    );
  }
}
