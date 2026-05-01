import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/mock_data.dart';
import '../../models/product.dart';
import '../../theme/app_theme.dart';
import '../../widgets/product_card.dart';
import '../../widgets/skeleton_loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  bool _isGridView = false;
  int _selectedCategoryIndex = 0;
  bool _showProfileModal = false;

  static const String _avatarUrl =
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face';

  static const List<_CategoryItem> _categories = [
    _CategoryItem(label: 'Tout', icon: Icons.grid_view_outlined, key: null),
    _CategoryItem(label: 'Electronique', icon: Icons.phone_iphone, key: 'Electronics'),
    _CategoryItem(label: 'Mode', icon: Icons.checkroom, key: 'Fashion'),
    _CategoryItem(label: 'Maison', icon: Icons.home_outlined, key: 'Home'),
    _CategoryItem(label: 'Transport', icon: Icons.directions_car_outlined, key: 'Transport'),
    _CategoryItem(label: 'Education', icon: Icons.menu_book_outlined, key: 'Education'),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() => _isLoading = false);
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour';
    if (hour < 18) return 'Bon apres-midi';
    return 'Bonsoir';
  }

  List<Product> get _filteredProducts {
    final categoryKey = _categories[_selectedCategoryIndex].key;
    if (categoryKey == null) return mockProducts;
    return mockProducts.where((p) => p.category == categoryKey).toList();
  }

  void _toggleProfileModal() {
    setState(() => _showProfileModal = !_showProfileModal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _loadData,
              child: CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(child: _buildHeader()),
                  // Location bar + view toggle
                  SliverToBoxAdapter(child: _buildLocationBar()),
                  // Category chips
                  SliverToBoxAdapter(child: _buildCategoryChips()),
                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
                  // Content
                  if (_isLoading)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, _) => const ListSkeletonItem(),
                        childCount: 5,
                      ),
                    )
                  else if (_isGridView)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: AppSpacing.sm,
                          mainAxisSpacing: AppSpacing.sm,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = _filteredProducts[index];
                            return GridProductCard(
                              product: product,
                              onPress: () => context.push('/item-details?id=${product.id}'),
                            );
                          },
                          childCount: _filteredProducts.length,
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = _filteredProducts[index];
                          return Column(
                            children: [
                              ProductCard(
                                product: product,
                                onPress: () => context.push('/item-details?id=${product.id}'),
                              ),
                              const Divider(height: 1, indent: AppSpacing.lg, endIndent: AppSpacing.lg),
                            ],
                          );
                        },
                        childCount: _filteredProducts.length,
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
          ),
          // Profile modal overlay
          if (_showProfileModal) _buildProfileModal(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/post-item'),
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.white, size: 28),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
      child: Row(
        children: [
          // Avatar with online indicator
          GestureDetector(
            onTap: _toggleProfileModal,
            child: Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: _avatarUrl,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        color: AppColors.grayLight,
                        child: const Icon(Icons.person, color: AppColors.gray),
                      ),
                      errorWidget: (_, _, _) => Container(
                        color: AppColors.grayLight,
                        child: const Icon(Icons.person, color: AppColors.gray),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: const TextStyle(fontSize: 13, color: AppColors.gray),
                ),
                const Text(
                  'Jean Baptiste',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                ),
              ],
            ),
          ),
          // Search icon
          IconButton(
            onPressed: () => context.push('/search'),
            icon: const Icon(Icons.search, color: Color(0xFF333333), size: 26),
          ),
          // Notification bell with badge
          Stack(
            children: [
              IconButton(
                onPressed: () => context.push('/notifications'),
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF333333), size: 26),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: const Text(
                    '3',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      child: Row(
        children: [
          // Location chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.grayLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: AppColors.gray),
                SizedBox(width: 4),
                Text(
                  'Akebe, Libreville',
                  style: TextStyle(fontSize: 13, color: Color(0xFF333333), fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 2),
                Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.gray),
              ],
            ),
          ),
          const Spacer(),
          // View toggle buttons
          Container(
            decoration: BoxDecoration(
              color: AppColors.grayLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _isGridView = false),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: !_isGridView ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.view_list_rounded,
                      size: 20,
                      color: !_isGridView ? AppColors.white : AppColors.gray,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isGridView = true),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: _isGridView ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.grid_view_rounded,
                      size: 20,
                      color: _isGridView ? AppColors.white : AppColors.gray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isActive = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.grayLight,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(cat.icon, size: 18, color: isActive ? AppColors.white : AppColors.gray),
                  const SizedBox(width: 6),
                  Text(
                    cat.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isActive ? AppColors.white : const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileModal() {
    return GestureDetector(
      onTap: _toggleProfileModal,
      child: Container(
        color: Colors.black54,
        child: SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {}, // prevent close on modal tap
              child: Container(
                margin: const EdgeInsets.only(left: AppSpacing.md, top: 70),
                width: 280,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // User info
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: _avatarUrl,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                placeholder: (_, _) => Container(color: AppColors.grayLight),
                                errorWidget: (_, _, _) => Container(
                                  color: AppColors.grayLight,
                                  child: const Icon(Icons.person),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jean Baptiste',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Akebe, Libreville',
                                  style: TextStyle(fontSize: 12, color: AppColors.gray),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Stats row
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat('12', 'Annonces'),
                          Container(width: 1, height: 30, color: AppColors.grayLight),
                          _buildStat('8', 'Vendus'),
                          Container(width: 1, height: 30, color: AppColors.grayLight),
                          _buildStat('24', 'Favoris'),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Quick actions
                    _buildModalAction(Icons.person_outline, 'Mon Profil', onTap: () {
                      _toggleProfileModal();
                      context.push('/profile');
                    }),
                    _buildModalAction(Icons.settings_outlined, 'Parametres', onTap: () {
                      _toggleProfileModal();
                      context.push('/settings');
                    }),
                    _buildModalAction(Icons.help_outline, 'Aide & Support', onTap: () {
                      _toggleProfileModal();
                    }),
                    const Divider(height: 1),
                    _buildModalAction(Icons.logout, 'Se deconnecter', isDestructive: true, onTap: () {
                      _toggleProfileModal();
                    }),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
      ],
    );
  }

  Widget _buildModalAction(IconData icon, String label, {bool isDestructive = false, VoidCallback? onTap}) {
    final color = isDestructive ? AppColors.danger : const Color(0xFF333333);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: AppSpacing.sm),
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem {
  final String label;
  final IconData icon;
  final String? key;

  const _CategoryItem({required this.label, required this.icon, this.key});
}
