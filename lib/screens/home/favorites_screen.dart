import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/mock_data.dart';
import '../../models/product.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Product> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = List.from(mockProducts.take(3));
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _favorites = List.from(mockProducts.take(3));
      });
    }
  }

  void _confirmRemove(Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Retirer des favoris',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Voulez-vous retirer "${product.title}" de vos favoris ?',
          style: const TextStyle(fontSize: 14, color: AppColors.gray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppColors.gray, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _favorites.removeWhere((p) => p.id == product.id);
              });
            },
            child: const Text(
              'Retirer',
              style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600),
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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.sm, AppSpacing.sm),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Favoris',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/search'),
                    icon: const Icon(Icons.search, color: Color(0xFF333333), size: 26),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: _favorites.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: _refresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                        itemCount: _favorites.length,
                        itemBuilder: (context, index) {
                          final product = _favorites[index];
                          return Stack(
                            children: [
                              Column(
                                children: [
                                  ProductCard(
                                    product: product,
                                    onPress: () => context.push('/item-details?id=${product.id}'),
                                  ),
                                  const Divider(height: 1, indent: AppSpacing.lg, endIndent: AppSpacing.lg),
                                ],
                              ),
                              // Red heart remove button
                              Positioned(
                                top: AppSpacing.md,
                                right: AppSpacing.lg,
                                child: GestureDetector(
                                  onTap: () => _confirmRemove(product),
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.favorite, color: AppColors.danger, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.grayLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_outline, size: 40, color: AppColors.gray),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Aucun favori',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Les produits que vous ajoutez aux favoris apparaitront ici.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.gray, height: 1.4),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Parcourir les produits',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
