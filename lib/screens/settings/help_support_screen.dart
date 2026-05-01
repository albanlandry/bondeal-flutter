import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
          'Aide & Support',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),
            _buildHelpActions(context),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Questions fr\u00e9quentes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildFaqSection(),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Nous contacter',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildContactInfo(),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildActionTile(
            Icons.quiz_outlined,
            'FAQ',
            'Trouvez des r\u00e9ponses rapidement',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          _buildActionTile(
            Icons.headset_mic_outlined,
            'Contacter le support',
            '\u00c9crivez-nous pour toute question',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          _buildActionTile(
            Icons.description_outlined,
            'Conditions d\'utilisation',
            'Lire nos conditions g\u00e9n\u00e9rales',
            onTap: () => context.push('/terms'),
          ),
          const Divider(height: 1, indent: 56),
          _buildActionTile(
            Icons.privacy_tip_outlined,
            'Politique de confidentialit\u00e9',
            'Comment nous prot\u00e9geons vos donn\u00e9es',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
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
            const Icon(Icons.chevron_right, color: AppColors.gray, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    final faqItems = [
      {
        'question': 'Comment publier une annonce ?',
        'answer':
            'Pour publier une annonce, appuyez sur le bouton "+" en bas de l\'\u00e9cran, '
                'remplissez les informations du produit (titre, description, prix, photos) '
                'et appuyez sur "Publier".',
      },
      {
        'question': 'Comment contacter un vendeur ?',
        'answer':
            'Sur la page d\'un produit, appuyez sur le bouton "Envoyer un message" '
                'pour d\u00e9marrer une conversation avec le vendeur directement dans l\'application.',
      },
      {
        'question': 'Comment modifier ou supprimer mon annonce ?',
        'answer':
            'Allez dans votre profil, puis "Mes annonces". S\u00e9lectionnez l\'annonce '
                'que vous souhaitez modifier et appuyez sur l\'ic\u00f4ne de modification ou de suppression.',
      },
      {
        'question': 'Les paiements sont-ils s\u00e9curis\u00e9s ?',
        'answer':
            'BonDeal ne g\u00e8re pas directement les paiements. Les transactions se font '
                'entre acheteurs et vendeurs. Nous recommandons de se rencontrer dans un lieu '
                'public et de v\u00e9rifier le produit avant tout paiement.',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionPanelList.radio(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        children: faqItems.asMap().entries.map((entry) {
          return ExpansionPanelRadio(
            value: entry.key,
            headerBuilder: (context, isExpanded) {
              return ListTile(
                title: Text(
                  entry.value['question']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Text(
                entry.value['answer']!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.gray,
                  height: 1.5,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Row(
            children: [
              Icon(Icons.email_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: AppSpacing.sm),
              Text(
                'support@bondeal.ga',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm + 4),
          Row(
            children: [
              Icon(Icons.phone_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: AppSpacing.sm),
              Text(
                '+241 74 00 00 00',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
