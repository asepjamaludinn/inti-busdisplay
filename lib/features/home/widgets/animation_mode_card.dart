import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/models/animation_mode.dart';
import '../../../core/providers/display_settings_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class AnimationModeCard extends StatelessWidget {
  const AnimationModeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<DisplaySettingsProvider>();
    final currentMode = AnimationMode.fromLabel(settingsProvider.animMode);

    return Container(
      decoration: AppTheme.coloredCardDecoration(AppColors.amber),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_motion_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Mode Animasi',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: settingsProvider.animMode,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(18),
                      dropdownColor: AppColors.amberDeep,
                      elevation: 6,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      selectedItemBuilder: (context) => AnimationMode.allLabels
                          .map(
                            (label) => Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      items: AnimationMode.allLabels
                          .map(
                            (label) => DropdownMenuItem(
                              value: label,
                              child: Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => settingsProvider.setAnimMode(val!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(currentMode.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                currentMode.isStatic
                    ? 'Teks diam'
                    : currentMode.isBlink
                    ? 'Berkedip'
                    : 'Speed ${settingsProvider.speed.toInt()}%',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
