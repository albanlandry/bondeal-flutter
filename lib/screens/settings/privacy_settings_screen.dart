import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _profileVisible = true;
  bool _showLocation = true;
  bool _phoneVisible = false;
  bool _allowMessages = true;

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Param\u00e8tres de confidentialit\u00e9 sauvegard\u00e9s'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

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
          'Confidentialit\u00e9',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                const SizedBox(height: AppSpacing.sm),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildToggle(
                        'Profil visible',
                        'Les autres utilisateurs peuvent voir votre profil',
                        _profileVisible,
                        (val) => setState(() => _profileVisible = val),
                      ),
                      const Divider(height: 1, indent: AppSpacing.md),
                      _buildToggle(
                        'Afficher la localisation',
                        'Montrer votre ville sur vos annonces',
                        _showLocation,
                        (val) => setState(() => _showLocation = val),
                      ),
                      const Divider(height: 1, indent: AppSpacing.md),
                      _buildToggle(
                        'Num\u00e9ro de t\u00e9l\u00e9phone visible',
                        'Les acheteurs peuvent voir votre num\u00e9ro',
                        _phoneVisible,
                        (val) => setState(() => _phoneVisible = val),
                      ),
                      const Divider(height: 1, indent: AppSpacing.md),
                      _buildToggle(
                        'Autoriser les messages',
                        'Recevoir des messages des autres utilisateurs',
                        _allowMessages,
                        (val) => setState(() => _allowMessages = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Protection des donn\u00e9es',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Vos donn\u00e9es personnelles sont prot\u00e9g\u00e9es conform\u00e9ment '
                              '\u00e0 notre politique de confidentialit\u00e9. Nous ne partageons '
                              'jamais vos informations avec des tiers sans votre consentement.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black.withValues(alpha: 0.7),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Sauvegarder',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.gray),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
            activeThumbColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}
