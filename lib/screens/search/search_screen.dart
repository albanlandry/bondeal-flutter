import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';

class _MockSuggestion {
  final String text;
  final String category;
  final String type;

  const _MockSuggestion({
    required this.text,
    required this.category,
    required this.type,
  });
}

const _allSuggestions = <_MockSuggestion>[
  _MockSuggestion(text: 'MacBook Pro 2020', category: 'Electronique', type: 'produit'),
  _MockSuggestion(text: 'iPhone 14 Pro Max', category: 'Electronique', type: 'produit'),
  _MockSuggestion(text: 'Samsung Galaxy S23', category: 'Electronique', type: 'produit'),
  _MockSuggestion(text: 'Nike Air Max 270', category: 'Chaussures', type: 'produit'),
  _MockSuggestion(text: 'Adidas Originals', category: 'Chaussures', type: 'marque'),
  _MockSuggestion(text: 'Appartement 3 chambres', category: 'Immobilier', type: 'annonce'),
  _MockSuggestion(text: 'Toyota Corolla 2019', category: 'Vehicules', type: 'produit'),
  _MockSuggestion(text: 'Canape cuir marron', category: 'Maison & Jardin', type: 'produit'),
  _MockSuggestion(text: 'Velo electrique', category: 'Sports & Loisirs', type: 'produit'),
  _MockSuggestion(text: 'Livre scolaire Terminale', category: 'Livres & Medias', type: 'produit'),
  _MockSuggestion(text: 'Refrigerateur Samsung', category: 'Electronique', type: 'produit'),
  _MockSuggestion(text: 'Montre Casio vintage', category: 'Accessoires', type: 'produit'),
  _MockSuggestion(text: 'Robe de soiree', category: 'Vetements', type: 'produit'),
  _MockSuggestion(text: 'PlayStation 5', category: 'Electronique', type: 'produit'),
  _MockSuggestion(text: 'Table bois massif', category: 'Maison & Jardin', type: 'produit'),
];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<String> _recentSearches = [
    'shoes',
    'cartables',
    'iphone xs',
    'montres',
    'chambre amis',
  ];

  List<_MockSuggestion> get _filteredSuggestions {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return [];
    return _allSuggestions
        .where((s) => s.text.toLowerCase().contains(query))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitSearch(String query) {
    if (query.trim().isEmpty) return;
    // Add to recent if not already there
    final trimmed = query.trim();
    setState(() {
      _recentSearches.remove(trimmed);
      _recentSearches.insert(0, trimmed);
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.sublist(0, 10);
      }
    });
    context.push('/search-results?q=${Uri.encodeComponent(trimmed)}');
  }

  void _clearRecentSearches() {
    setState(() => _recentSearches.clear());
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _searchController.text.trim().isNotEmpty;
    final suggestions = _filteredSuggestions;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar header
            Padding(
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
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.grayLight,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 14),
                            child: Icon(Icons.search, size: 20, color: AppColors.gray),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _focusNode,
                              onSubmitted: _submitSearch,
                              textInputAction: TextInputAction.search,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF333333),
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Rechercher...',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFAAAAAA),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          if (hasQuery)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                _focusNode.requestFocus();
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.close, size: 18, color: AppColors.gray),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.grayLight),

            // Content
            Expanded(
              child: hasQuery && suggestions.isNotEmpty
                  ? _buildSuggestionsDropdown(suggestions)
                  : _buildDefaultContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsDropdown(List<_MockSuggestion> suggestions) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return InkWell(
          onTap: () => _submitSearch(suggestion.text),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 18, color: AppColors.gray),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion.text,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${suggestion.category} - ${suggestion.type}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.north_west, size: 16, color: AppColors.gray),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recherches recentes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                GestureDetector(
                  onTap: _clearRecentSearches,
                  child: const Text(
                    'Tout supprimer',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.danger,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _recentSearches.map((search) {
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () {
                        _searchController.text = search;
                        _submitSearch(search);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.history, size: 14, color: AppColors.gray),
                            const SizedBox(width: 6),
                            Text(
                              search,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Suggestions
          const Text(
            'Suggestions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _allSuggestions.map((suggestion) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: () => _submitSearch(suggestion.text),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        suggestion.text,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
