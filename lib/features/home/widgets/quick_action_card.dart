import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key});

  void _showSavePresetDialog(BuildContext context) {
    final provider = context.read<HomeProvider>();
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        scrollable: true,
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),

        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 16),

        title: const Text(
          'Simpan Preset',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'Nama Preset (Cth: Pagi Hari)',
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;
              final success = await provider.saveCurrentPreset(
                nameController.text.trim(),
              );
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: success
                        ? AppColors.success
                        : AppColors.danger,
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      success
                          ? 'Preset berhasil disimpan!'
                          : 'Gagal menyimpan preset.',
                    ),
                  ),
                );
              }
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLoadPresetSheet(BuildContext context) {
    final provider = context.read<HomeProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Muat Preset Tersimpan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<dynamic>>(
              future: provider.getSavedPresets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text('Belum ada preset tersimpan.')),
                  );
                }

                final presets = snapshot.data!;
                return Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: presets.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final preset = presets[index];
                      final payload = preset['payload'];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.display_settings_rounded,
                          color: AppColors.secondary,
                        ),
                        title: Text(
                          preset['name'] ?? 'Preset',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${payload['route']} • ${payload['animation']}',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.amberDeep,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            provider.applyPreset(payload);
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'Pilih',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

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
                  onTap: () => _showSavePresetDialog(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: 'Muat Preset',
                  icon: Icons.folder_open_rounded,
                  isOutline: true,
                  tintColor: AppColors.amberDeep,
                  onTap: () => _showLoadPresetSheet(context),
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
            onTap: () => context.read<HomeProvider>().resetToDefault(),
          ),
        ],
      ),
    );
  }
}
