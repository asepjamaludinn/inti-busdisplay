import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../home/widgets/animation_mode_card.dart';
import '../home/widgets/display_setting_card.dart';
import '../home/widgets/quick_action_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengaturan Display',
              style: GoogleFonts.dmSans(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 20),
            const AnimationModeCard(),
            const SizedBox(height: 16),
            const DisplaySettingCard(),
            const SizedBox(height: 16),
            const QuickActionCard(),
          ],
        ),
      ),
    );
  }
}
