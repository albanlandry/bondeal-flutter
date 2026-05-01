import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            _buildUserCard(),
            const SizedBox(height: AppSpacing.lg),
            _buildActivitiesSection(),
            const SizedBox(height: AppSpacing.lg),
            _buildSettingsSection(context),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'BonDeal v1.0.0',
              style: TextStyle(color: AppColors.gray, fontSize: 12),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                    color: AppColors.grayLight,
                  ),
                  child: const Icon(Icons.person, size: 40, color: AppColors.gray),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: const Icon(Icons.check, color: AppColors.white, size: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Jean Baptiste',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: AppColors.gray),
                SizedBox(width: 2),
                Text(
                  'Libreville, Gabon',
                  style: TextStyle(color: AppColors.gray, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Membre depuis Janvier 2024',
              style: TextStyle(color: AppColors.gray, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mes activit\u00e9s',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.6,
            children: [
              _buildActivityCard(
                Icons.list_alt,
                AppColors.primary,
                'Mes annonces',
                '12',
              ),
              _buildActivityCard(
                Icons.favorite,
                const Color(0xFFE91E63),
                'Favoris',
                '24',
              ),
              _buildActivityCard(
                Icons.shopping_cart,
                AppColors.success,
                'Vendus',
                '8',
              ),
              _buildActivityCard(
                Icons.star,
                const Color(0xFFFF9800),
                'Avis',
                '4.8',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    IconData icon,
    Color color,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: AppColors.gray, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Param\u00e8tres',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSettingsItem(
                  context,
                  Icons.person_outline,
                  'Modifier le profil',
                  onTap: () => context.push('/edit-profile'),
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingsItem(
                  context,
                  Icons.notifications_outlined,
                  'Notifications',
                  onTap: () => context.push('/notification-settings'),
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingsItem(
                  context,
                  Icons.lock_outline,
                  'Confidentialit\u00e9',
                  onTap: () => context.push('/privacy-settings'),
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingsItem(
                  context,
                  Icons.help_outline,
                  'Aide & Support',
                  onTap: () => context.push('/help-support'),
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingsItem(
                  context,
                  Icons.info_outline,
                  '\u00c0 propos',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingsItem(
                  context,
                  Icons.logout,
                  'Se d\u00e9connecter',
                  textColor: AppColors.danger,
                  iconColor: AppColors.danger,
                  showArrow: false,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title, {
    Color? textColor,
    Color? iconColor,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
