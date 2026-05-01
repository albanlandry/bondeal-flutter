import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../../models/product.dart';
import '../../models/mock_data.dart';
import '../../widgets/product_card.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  String _sortBy = 'pertinence';
  String? _filterCategory;

  final List<String> _sortOptions = [
    'pertinence',
    'prix_asc',
    'prix_desc',
    'recent',
  ];

  final Map<String, String> _sortLabels = {
    'pertinence': 'Pertinence',
    'prix_asc': 'Prix croissant',
    'prix_desc': 'Prix decroissant',
    'recent': 'Plus recent',
  };

  final List<String> _filterCategories = [
    'Tous',
    'Electronique',
    'Vetements',
    'Maison & Jardin',
    'Vehicules',
    'Sports & Loisirs',
  ];

  List<Product> get _filteredProducts {
    final query = widget.query.toLowerCase();
    var results = mockProducts.where((p) {
      return p.title.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query) ||
          p.location.toLowerCase().contains(query);
    }).toList();

    if (_filterCategory != null && _filterCategory != 'Tous') {
      results = results.where((p) {
        return p.category.toLowerCase() == _filterCategory!.toLowerCase();
      }).toList();
    }

    switch (_sortBy) {
      case 'prix_asc':
        results.sort((a, b) => _extractPrice(a.price).compareTo(_extractPrice(b.price)));
        break;
      case 'prix_desc':
        results.sort((a, b) => _extractPrice(b.price).compareTo(_extractPrice(a.price)));
        break;
      case 'recent':
        // Keep original order (mock data is already roughly by date)
        break;
      default:
        // pertinence - keep original order
        break;
    }

    return results;
  }

  int _extractPrice(String price) {
    final digits = price.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'Trier par',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const Divider(height: 1),
              ..._sortOptions.map((option) {
                final isSelected = _sortBy == option;
                return ListTile(
                  title: Text(
                    _sortLabels[option] ?? option,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppColors.primary : const Color(0xFF333333),
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _sortBy = option);
                    Navigator.pop(ctx);
                  },
                );
              }),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back, size: 24, color: Color(0xFF333333)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, size: 18, color: AppColors.gray),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                widget.query,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF333333),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter/Sort controls
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  const Divider(height: 1, color: AppColors.grayLight),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${results.length} resultat${results.length > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _showSortSheet,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grayLight),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.sort, size: 16, color: AppColors.gray),
                                const SizedBox(width: 6),
                                Text(
                                  _sortLabels[_sortBy] ?? 'Trier',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF555555),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Category filter chips
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      itemCount: _filterCategories.length,
                      itemBuilder: (context, index) {
                        final cat = _filterCategories[index];
                        final isSelected =
                            (cat == 'Tous' && _filterCategory == null) ||
                                _filterCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _filterCategory = cat == 'Tous' ? null : cat;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.grayLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                cat,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.white
                                      : const Color(0xFF555555),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),

            // Results list or empty state
            Expanded(
              child: results.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      itemCount: results.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        indent: AppSpacing.lg,
                        endIndent: AppSpacing.lg,
                        color: AppColors.grayLight,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: results[index],
                          onPress: () {
                            context.push('/item-details');
                          },
                        );
                      },
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
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.gray.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Aucun resultat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Aucun article ne correspond a "${widget.query}".\nEssayez avec d\'autres mots-cles.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.gray,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Nouvelle recherche',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
