import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../home_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class AnimationModeCard extends StatelessWidget {
  const AnimationModeCard({super.key});

  static const _modes = [
    'Running',
    'Static',
    'Blink',
    'Scroll Left',
    'Scroll Right',
    'Scroll Up',
    'Scroll Down',
  ];

  IconData _iconFor(String mode) {
    switch (mode) {
      case 'Blink':
        return Icons.flash_on_rounded;
      case 'Static':
        return Icons.crop_square_rounded;
      case 'Scroll Right':
        return Icons.arrow_forward_rounded;
      case 'Scroll Left':
        return Icons.arrow_back_rounded;
      case 'Scroll Up':
        return Icons.arrow_upward_rounded;
      case 'Scroll Down':
        return Icons.arrow_downward_rounded;
      default:
        return Icons.sync_alt_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeProvider>();

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
                      value: controller.animMode,
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
                      selectedItemBuilder: (context) => _modes
                          .map(
                            (mode) => Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                mode,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      items: _modes
                          .map(
                            (mode) => DropdownMenuItem(
                              value: mode,
                              child: Text(
                                mode,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => controller.setAnimMode(val!),
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
                child: Icon(
                  _iconFor(controller.animMode),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.animMode == 'Static'
                    ? 'Teks diam'
                    : controller.animMode == 'Blink'
                    ? 'Berkedip'
                    : 'Speed ${controller.speed.toInt()}%',
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
