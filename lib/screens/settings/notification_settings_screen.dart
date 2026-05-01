import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _newMessages = true;
  bool _likesOnListings = true;
  bool _viewsOnListings = false;
  bool _newOffers = true;
  bool _confirmedSales = true;

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pr\u00e9f\u00e9rences de notifications sauvegard\u00e9es'),
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
          'Notifications',
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
                        'Notifications push',
                        'Activer les notifications push',
                        _pushNotifications,
                        (val) => setState(() => _pushNotifications = val),
                      ),
                      const Divider(height: 1, indent: AppSpacing.md),
                      _buildToggle(
                        'Nouveaux messages',
                        'Recevoir une notification pour chaque nouveau message',
                        _newMessages,
                        (val) => setState(() => _newMessages = val),
                      ),
                      const Divider(height: 1, indent: AppSpacing.md),
                      _buildToggle(
                        'Likes sur vos annonces',
                        'Quand quelqu\'un aime votre annonce',
                        _likesOnListings,
                        (val) => setState(() => _likesOnListings = val),
                      ),
                      const Divider(height: 1, indent: AppSpacing.md),
                      _buildToggle(
                        'Vues sur vos annonces',
                        'Quand quelqu\'un consulte votre annonce',
                        _viewsOnListings,
                        (val) => setState(() => _viewsOnListings = val),
                      ),
                      const Divider(height: 1, indent: AppSpacing.md),
                      _buildToggle(
                        'Nouvelles offres',
                        'Quand vous recevez une offre de prix',
                        _newOffers,
                        (val) => setState(() => _newOffers = val),
                      ),
                      const Divider(height: 1, indent: AppSpacing.md),
                      _buildToggle(
                        'Ventes confirm\u00e9es',
                        'Confirmation de vente r\u00e9ussie',
                        _confirmedSales,
                        (val) => setState(() => _confirmedSales = val),
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
