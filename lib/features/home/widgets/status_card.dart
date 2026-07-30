import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeProvider>();
    final isConnected = controller.isConnected;

    final dotColor = isConnected ? AppColors.success : AppColors.danger;
    final statusText = isConnected ? 'Terhubung' : 'Terputus';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),

      decoration: AppTheme.gradientCardDecoration(
        isConnected
            ? AppColors.statusGradient
            : [AppColors.dusk, AppColors.textPrimary],
        radius: 22,
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withValues(alpha: 0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Running Text Bus 01',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$statusText • ${controller.serverIp}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          _CircleIconButton(
            icon: Icons.refresh_rounded,
            onTap: () => context.read<HomeProvider>().refreshConnectionStatus(),
          ),
          const SizedBox(width: 8),
          _CircleIconButton(
            icon: Icons.power_settings_new_rounded,
            onTap: () {},
            filled: true,
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? Colors.white : Colors.white.withValues(alpha: 0.14),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 15,
            color: filled ? AppColors.primary : Colors.white,
          ),
        ),
      ),
    );
  }
}
