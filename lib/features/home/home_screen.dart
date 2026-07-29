import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/app_header.dart';
import 'widgets/status_card.dart';
import 'widgets/search_box.dart';
import 'widgets/route_card.dart';
import 'widgets/animation_mode_card.dart';
import 'widgets/preview_card.dart';
import 'widgets/display_setting_card.dart';
import 'widgets/quick_action_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),
              const SizedBox(height: 16),
              const SearchBox(),
              const SizedBox(height: 18),
              const PreviewCard(),
              const SizedBox(height: 16),
              const StatusCard(),
              const SizedBox(height: 16),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Expanded(child: RouteCard()),
                    SizedBox(width: 16),
                    Expanded(child: AnimationModeCard()),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const DisplaySettingCard(),
              const SizedBox(height: 20),
              const QuickActionCard(),
            ],
          ),
        ),
      ),
    );
  }
}
