import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class PreviewCard extends StatelessWidget {
  const PreviewCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.monitor_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Live Preview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.ledBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Center(
              child: Text(
                'B2 | BANDUNG → JAKARTA',
                style: TextStyle(
                  fontFamily: 'Courier', // Monospace feel
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ledText,
                  shadows: [
                    Shadow(
                      color: AppColors.ledText,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                    Shadow(
                      color: AppColors.ledText,
                      blurRadius: 20,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
