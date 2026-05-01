import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _consentPhone = false;
  bool _consentPersonalData = false;
  bool _consentAnalytics = false;
  bool _consentMarketing = false;

  bool get _allRequiredConsented =>
      _consentPhone && _consentPersonalData && _consentAnalytics;

  void _accept() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Conditions accept\u00e9es'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  void _decline() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Refuser les conditions'),
        content: const Text(
          'En refusant les conditions d\'utilisation, vous ne pourrez pas '
          'utiliser certaines fonctionnalit\u00e9s de l\'application.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: const Text(
              'Refuser',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
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
          'Conditions d\'utilisation',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(),
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    'Consentements',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildConsentsSection(),
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    'Nos garanties',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildGuaranteesSection(),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.description_outlined,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Bienvenue sur BonDeal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Avant de continuer, veuillez lire et accepter nos conditions '
            'd\'utilisation. Votre consentement est n\u00e9cessaire pour '
            'utiliser notre plateforme de mani\u00e8re optimale.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.gray,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildConsentItem(
            'Utilisation du num\u00e9ro de t\u00e9l\u00e9phone',
            'J\'autorise BonDeal \u00e0 utiliser mon num\u00e9ro pour la v\u00e9rification et la communication.',
            _consentPhone,
            (val) => setState(() => _consentPhone = val ?? false),
            required: true,
          ),
          const Divider(height: 1, indent: AppSpacing.md),
          _buildConsentItem(
            'Donn\u00e9es personnelles',
            'J\'autorise le traitement de mes donn\u00e9es personnelles conform\u00e9ment \u00e0 la politique de confidentialit\u00e9.',
            _consentPersonalData,
            (val) => setState(() => _consentPersonalData = val ?? false),
            required: true,
          ),
          const Divider(height: 1, indent: AppSpacing.md),
          _buildConsentItem(
            'Donn\u00e9es analytiques',
            'J\'autorise la collecte de donn\u00e9es d\'utilisation pour am\u00e9liorer l\'application.',
            _consentAnalytics,
            (val) => setState(() => _consentAnalytics = val ?? false),
            required: true,
          ),
          const Divider(height: 1, indent: AppSpacing.md),
          _buildConsentItem(
            'Communications marketing',
            'J\'accepte de recevoir des offres promotionnelles et des nouveaut\u00e9s par email.',
            _consentMarketing,
            (val) => setState(() => _consentMarketing = val ?? false),
            required: false,
          ),
        ],
      ),
    );
  }

  Widget _buildConsentItem(
    String title,
    String description,
    bool value,
    ValueChanged<bool?> onChanged, {
    required bool required,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (required)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Requis',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.danger,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteesSection() {
    final guarantees = [
      'Vos donn\u00e9es ne seront jamais vendues \u00e0 des tiers',
      'Vous pouvez supprimer votre compte \u00e0 tout moment',
      'Chiffrement de bout en bout pour les messages',
      'Respect des r\u00e9glementations locales de protection des donn\u00e9es',
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: guarantees.map((text) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(right: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.success,
                    size: 14,
                  ),
                ),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: _decline,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Refuser',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _allRequiredConsented ? _accept : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor: AppColors.grayLight,
                  disabledForegroundColor: AppColors.gray,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Accepter',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
