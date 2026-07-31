import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Aksi Cepat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'Kirim ke Display',
            icon: Icons.send_rounded,
            gradient: AppColors.heroButtonGradient,
            onTap: () {
              context.read<HomeProvider>().sendPayloadToDevice(context);
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'Simpan Preset',
                  icon: Icons.save_rounded,
                  isOutline: true,
                  tintColor: AppColors.secondary,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: 'Muat Preset',
                  icon: Icons.folder_open_rounded,
                  isOutline: true,
                  tintColor: AppColors.amberDeep,
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Reset ke Default',
            icon: Icons.refresh_rounded,
            isOutline: true,
            tintColor: AppColors.danger,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
