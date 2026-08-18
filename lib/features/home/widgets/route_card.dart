import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/models/route_model.dart';
import '../../../core/providers/route_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/feedback_extension.dart';

class RouteCard extends StatelessWidget {
  const RouteCard({super.key});

  void _showAddRouteDialog(BuildContext context) {
    final codeController = TextEditingController();
    final originController = TextEditingController();
    final destinationController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        alignment: Alignment.topCenter,
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        titlePadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
        title: Text(
          'Tambah Rute Baru',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RouteFormField(
              controller: codeController,
              hint: 'Kode Rute (Cth: B5)',
            ),
            const SizedBox(height: 10),
            _RouteFormField(
              controller: originController,
              hint: 'Kota Asal (Cth: Bandung)',
            ),
            const SizedBox(height: 10),
            _RouteFormField(
              controller: destinationController,
              hint: 'Kota Tujuan (Cth: Lembang)',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              final result = await context.read<RouteProvider>().addRoute(
                code: codeController.text,
                origin: originController.text,
                destination: destinationController.text,
              );

              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                context.showResult(
                  result,
                  fallbackSuccessMessage: 'Rute berhasil ditambahkan.',
                );
              }
            },
            child: const Text(
              'Simpan',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteRouteDialog(
    BuildContext context,
    RouteModel currentRoute,
    RouteProvider provider,
  ) {
    if (provider.routes.length <= 1) {
      context.showFeedback(
        message: 'Minimal harus ada 1 rute tersisa!',
        color: AppColors.warning,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Hapus Rute',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: Text(
          'Hapus "${currentRoute.fullDisplayName}"? Tindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              final result = await provider.deleteRoute(currentRoute);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) context.showResult(result);
            },
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeProvider = context.watch<RouteProvider>();

    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.route_rounded,
                  color: AppColors.secondary,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Pengaturan Rute',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),

              if (routeProvider.isLoadingRoutes) ...[
                const SizedBox(width: 8),
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.6,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            routeProvider.selectedRoute.code,
            style: GoogleFonts.dmSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<RouteModel>(
                      value: routeProvider.selectedRoute,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(20),
                      elevation: 4,
                      icon: const Icon(
                        Icons.unfold_more_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      selectedItemBuilder: (context) => routeProvider.routes
                          .map(
                            (e) => Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                e.apiRouteName,
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      items: routeProvider.routes
                          .map(
                            (e) => DropdownMenuItem<RouteModel>(
                              value: e,
                              child: Text(
                                e.fullDisplayName,
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => routeProvider.setRoute(val!),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _ActionButton(
                icon: Icons.add_rounded,
                color: AppColors.primary,
                onTap: () => _showAddRouteDialog(context),
              ),
              const SizedBox(width: 10),
              _ActionButton(
                icon: Icons.delete_outline_rounded,
                color: AppColors.danger,
                onTap: () => _showDeleteRouteDialog(
                  context,
                  routeProvider.selectedRoute,
                  routeProvider,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _DirectionTab(
                    label: 'Pergi Ke Tujuan',
                    active: routeProvider.isPergi,
                    onTap: () => routeProvider.setDirection(true),
                  ),
                ),
                Expanded(
                  child: _DirectionTab(
                    label: 'Kembali/Pulang',
                    active: !routeProvider.isPergi,
                    onTap: () => routeProvider.setDirection(false),
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

class _RouteFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _RouteFormField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: color, size: 22),
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
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: active ? AppColors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            color: active ? AppColors.primary : AppColors.textSecondary,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
