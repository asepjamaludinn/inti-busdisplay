import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isOutline;

  const PrimaryButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isOutline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isOutline ? Colors.transparent : AppColors.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            border: isOutline
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isOutline ? AppColors.primary : Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isOutline ? AppColors.primary : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
