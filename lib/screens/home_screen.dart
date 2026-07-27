import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/status_card.dart';
import '../widgets/search_box.dart';
import '../widgets/route_card.dart';
import '../widgets/preview_card.dart';
import '../widgets/display_setting_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/info_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          children: [
            const AppHeader(),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const StatusCard(),
                    const SizedBox(height: 24),
                    const SearchBox(),
                    const SizedBox(height: 24),
                    const RouteCard(),
                    const SizedBox(height: 24),
                    const PreviewCard(),
                    const SizedBox(height: 24),
                    const DisplaySettingCard(),
                    const SizedBox(height: 24),
                    const QuickActionCard(),
                    const SizedBox(height: 24),
                    const InfoCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
