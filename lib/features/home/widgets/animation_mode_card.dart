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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_motion_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'Animasi',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                itemHeight: 48,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.white,
                ),
                selectedItemBuilder: (context) => _modes
                    .map(
                      (mode) => Row(
                        children: [
                          Icon(_iconFor(mode), color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                mode,
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
                items: _modes
                    .map(
                      (mode) => DropdownMenuItem(
                        value: mode,
                        child: Row(
                          children: [
                            Icon(_iconFor(mode), color: Colors.white, size: 16),
                            const SizedBox(width: 10),
                            Text(
                              mode,
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => controller.setAnimMode(val!),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconFor(controller.animMode),
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          Text(
            controller.animMode == 'Static'
                ? 'Teks diam'
                : controller.animMode == 'Blink'
                ? 'Teks berkedip'
                : 'Bergerak ${controller.speed.toInt()}%',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
