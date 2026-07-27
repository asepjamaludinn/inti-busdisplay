import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'modern_slider.dart';

class DisplaySettingCard extends StatefulWidget {
  const DisplaySettingCard({Key? key}) : super(key: key);

  @override
  State<DisplaySettingCard> createState() => _DisplaySettingCardState();
}

class _DisplaySettingCardState extends State<DisplaySettingCard> {
  String _animMode = 'Scroll Left';
  double _speed = 50;
  double _brightness = 80;
  double _fontSize = 16;

  @override
  Widget build(BuildContext context) {
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
                value: _animMode,
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
                onChanged: (val) => setState(() => _animMode = val!),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ModernSlider(
            label: 'Scroll Speed',
            value: _speed,
            onChanged: (val) => setState(() => _speed = val),
          ),
          const SizedBox(height: 12),
          ModernSlider(
            label: 'Brightness',
            value: _brightness,
            onChanged: (val) => setState(() => _brightness = val),
          ),
          const SizedBox(height: 12),
          ModernSlider(
            label: 'Font Size',
            value: _fontSize,
            onChanged: (val) => setState(() => _fontSize = val),
          ),
        ],
      ),
    );
  }
}
