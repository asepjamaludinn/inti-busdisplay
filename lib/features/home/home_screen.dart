import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/app_header.dart';
import 'widgets/status_card.dart';
import 'widgets/route_card.dart';
import 'widgets/preview_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AppHeader(),
              SizedBox(height: 20),
              PreviewCard(),
              SizedBox(height: 16),
              StatusCard(),
              SizedBox(height: 16),
              RouteCard(),
            ],
          ),
        ),
      ),
    );
  }
}
