import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/display_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class RouteCard extends StatelessWidget {
  const RouteCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DisplayController>();

    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bus Route',
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.background, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedRoute,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary,
                ),
                items:
                    [
                          'B1 • Bandung - Garut',
                          'B2 • Bandung - Jakarta',
                          'B3 • Bandung - Bekasi',
                          'B4 • Bandung - Bogor',
                        ]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (val) => controller.setRoute(val!),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.setDirection(true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: controller.isPergi
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: controller.isPergi
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Pergi',
                        style: GoogleFonts.dmSans(
                          color: controller.isPergi
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.setDirection(false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: !controller.isPergi
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: !controller.isPergi
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Pulang',
                        style: GoogleFonts.dmSans(
                          color: !controller.isPergi
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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
