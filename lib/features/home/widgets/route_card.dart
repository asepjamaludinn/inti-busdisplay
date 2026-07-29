import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../home_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class RouteCard extends StatelessWidget {
  const RouteCard({super.key});

  static const _routes = [
    'B1 • Bandung - Garut',
    'B2 • Bandung - Jakarta',
    'B3 • Bandung - Bekasi',
    'B4 • Bandung - Bogor',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeProvider>();
    final code = controller.selectedRoute.split(' • ').first;

    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.route_rounded,
                color: AppColors.secondary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'Rute',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            code,
            style: GoogleFonts.dmSans(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedRoute,
                isExpanded: true,
                borderRadius: BorderRadius.circular(18),
                elevation: 6,
                itemHeight: 48,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
                selectedItemBuilder: (context) => _routes
                    .map(
                      (e) => Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e.split(' • ').last,
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                items: _routes
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.directions_bus_filled_rounded,
                              color: AppColors.secondary,
                              size: 16,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  e,
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => controller.setRoute(val!),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _DirectionTab(
                    label: 'Pergi',
                    active: controller.isPergi,
                    onTap: () => controller.setDirection(true),
                  ),
                ),
                Expanded(
                  child: _DirectionTab(
                    label: 'Pulang',
                    active: !controller.isPergi,
                    onTap: () => controller.setDirection(false),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _DirectionTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            color: active ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
