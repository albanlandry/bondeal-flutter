import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        shadowColor: Colors.black26,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Param\u00e8tres',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            _buildSectionLabel('Pr\u00e9f\u00e9rences'),
            _buildSection([
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () => context.push('/notification-settings'),
              ),
              _SettingsTile(
                icon: Icons.lock_outline,
                title: 'Confidentialit\u00e9',
                onTap: () => context.push('/privacy-settings'),
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionLabel('Support'),
            _buildSection([
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Aide & Support',
                onTap: () => context.push('/help-support'),
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                title: '\u00c0 propos',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionLabel('Compte'),
            _buildSection([
              _SettingsTile(
                icon: Icons.logout,
                title: 'Se d\u00e9connecter',
                textColor: AppColors.danger,
                iconColor: AppColors.danger,
                showArrow: false,
                onTap: () => _showLogoutDialog(context),
              ),
            ]),
            const SizedBox(height: AppSpacing.xxl),
            const Center(
              child: Text(
                'BonDeal v1.0.0',
                style: TextStyle(color: AppColors.gray, fontSize: 12),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.gray,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSection(List<_SettingsTile> tiles) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(tiles.length * 2 - 1, (index) {
          if (index.isOdd) {
            return const Divider(height: 1, indent: 56);
          }
          return tiles[index ~/ 2];
        }),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se d\u00e9connecter'),
        content: const Text('\u00cates-vous s\u00fbr de vouloir vous d\u00e9connecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/login');
            },
            child: const Text(
              'Se d\u00e9connecter',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? textColor;
  final Color? iconColor;
  final bool showArrow;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.textColor,
    this.iconColor,
    this.showArrow = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.gray, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: textColor ?? Colors.black,
                ),
              ),
            ),
            if (showArrow)
              const Icon(Icons.chevron_right, color: AppColors.gray, size: 20),
          ],
        ),
      ),
    );
  }
}
