import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../../models/mock_data.dart';
import '../../models/product.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String? productId;

  const ItemDetailsScreen({super.key, this.productId});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLiked = false;

  static const List<String> _fallbackImages = [
    'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&h=600&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=800&h=600&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800&h=600&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=800&h=600&fit=crop&crop=center',
  ];

  final List<Product> _suggestedItems = [
    const Product(
      id: 's1',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=200&fit=crop&crop=center',
      title: 'Nike Air Max 270',
      location: 'Libreville Centre',
      price: '45000 FCFA',
      likes: 8,
      views: 23,
      comments: 1,
      category: 'Fashion',
      condition: 'Neuf',
      seller: 'Marie Claire',
      postedDate: '1 jour',
      status: 'available',
    ),
    const Product(
      id: 's2',
      imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=200&fit=crop&crop=center',
      title: 'iPhone 12 Pro Max',
      location: 'Akebe',
      price: '280000 FCFA',
      likes: 25,
      views: 89,
      comments: 7,
      category: 'Electronics',
      condition: 'Bon état',
      seller: 'Paul Mba',
      postedDate: '3 jours',
      status: 'sold',
    ),
    const Product(
      id: 's3',
      imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=300&h=200&fit=crop&crop=center',
      title: 'Sac à dos Adidas',
      location: 'Nkembo',
      price: '25000 FCFA',
      likes: 6,
      views: 18,
      comments: 2,
      category: 'Fashion',
      condition: 'Bon état',
      seller: 'Sarah Nguema',
      postedDate: '5 jours',
      status: 'available',
    ),
    const Product(
      id: 's4',
      imageUrl: 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=300&h=200&fit=crop&crop=center',
      title: 'Macbook Air M1',
      location: 'Montagne Sainte',
      price: '450000 FCFA',
      likes: 32,
      views: 120,
      comments: 11,
      category: 'Electronics',
      condition: 'Très bon état',
      seller: 'Pierre Obiang',
      postedDate: '2 jours',
      status: 'available',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Product get _product {
    return mockProducts.firstWhere(
      (product) => product.id == widget.productId,
      orElse: () => mockProducts.first,
    );
  }

  List<String> get _images {
    final imageUrl = _product.imageUrl;
    if (imageUrl == null) return _fallbackImages;
    return [imageUrl, ..._fallbackImages.where((image) => image != imageUrl)];
  }

  void _openFullscreenImage(int initialPage) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return _FullscreenImageView(
            images: _images,
            initialPage: initialPage,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          _HeaderButton(
                            icon: Icons.arrow_back,
                            onTap: () => context.pop(),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          // Seller info
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.grayLight,
                            ),
                            child: const Icon(Icons.person, size: 24, color: AppColors.gray),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _product.seller,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                Text(
                                  "Publié il y'a ${_product.postedDate}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.gray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _HeaderButton(
                            icon: Icons.home_outlined,
                            onTap: () => context.go('/home'),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _HeaderButton(
                            icon: Icons.more_horiz,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.flag_outlined),
                                        title: const Text('Signaler'),
                                        onTap: () => Navigator.pop(ctx),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.block),
                                        title: const Text('Bloquer'),
                                        onTap: () => Navigator.pop(ctx),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.share_outlined),
                                        title: const Text('Partager'),
                                        onTap: () => Navigator.pop(ctx),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Image carousel
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 280,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _images.length,
                          onPageChanged: (index) {
                            setState(() => _currentPage = index);
                          },
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _openFullscreenImage(index),
                              child: CachedNetworkImage(
                                imageUrl: _images[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (_, _) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                                errorWidget: (_, _, _) => Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported, size: 48),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      // Pagination dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_images.length, (index) {
                          return Container(
                            width: _currentPage == index ? 24 : 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: _currentPage == index
                                  ? AppColors.primary
                                  : AppColors.grayLight,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // Product info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          _product.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Engagement stats
                        Row(
                          children: [
                            _StatItem(icon: Icons.favorite, count: _product.likes, color: AppColors.danger),
                            const SizedBox(width: AppSpacing.lg),
                            _StatItem(icon: Icons.visibility, count: _product.views, color: AppColors.gray),
                            const SizedBox(width: AppSpacing.lg),
                            _StatItem(icon: Icons.chat_bubble, count: _product.comments, color: AppColors.gray),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        const Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Location section
                        const Text(
                          'Localisation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.grayLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 36,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              const Text(
                                'Appuyez pour voir sur la carte',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              const Text(
                                '0.4162, 9.4673',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            const Icon(Icons.place, size: 16, color: AppColors.gray),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              _product.location,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Suggested items
                        const Text(
                          'Suggestions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ),
                  ),
                ),

                // Suggested items horizontal scroll
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      itemCount: _suggestedItems.length,
                      itemBuilder: (context, index) {
                        final item = _suggestedItems[index];
                        return _SuggestedItemCard(product: item);
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.lg),
                ),
              ],
            ),
          ),

          // Bottom bar
          _BottomBar(
            price: _product.price,
            isLiked: _isLiked,
            onLikeToggle: () {
              setState(() => _isLiked = !_isLiked);
            },
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF333333)),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}

class _SuggestedItemCard extends StatelessWidget {
  final Product product;

  const _SuggestedItemCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final statusConfig = product.status == 'sold'
        ? (text: 'Vendu', color: AppColors.danger)
        : (text: 'Disponible', color: AppColors.success);

    return GestureDetector(
      onTap: () => context.push('/item-details?id=${product.id}'),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with status badge
            Stack(
              children: [
                if (product.imageUrl != null)
                  CachedNetworkImage(
                    imageUrl: product.imageUrl!,
                    height: 110,
                    width: 160,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                      height: 110,
                      width: 160,
                      color: Colors.grey[200],
                    ),
                    errorWidget: (_, _, _) => Container(
                      height: 110,
                      width: 160,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusConfig.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusConfig.text,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                        height: 1.2,
                      ),
                    ),
                    Text(
                      product.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF999999),
                      ),
                    ),
                    Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String price;
  final bool isLiked;
  final VoidCallback onLikeToggle;

  const _BottomBar({
    required this.price,
    required this.isLiked,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Like button
          GestureDetector(
            onTap: onLikeToggle,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.grayLight, width: 1.5),
              ),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? AppColors.danger : AppColors.gray,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Share button
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.grayLight, width: 1.5),
              ),
              child: const Icon(
                Icons.share_outlined,
                color: AppColors.gray,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Price + Negotier
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Negotier',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Contacter button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm + 4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Contacter',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullscreenImageView extends StatefulWidget {
  final List<String> images;
  final int initialPage;

  const _FullscreenImageView({
    required this.images,
    required this.initialPage,
  });

  @override
  State<_FullscreenImageView> createState() => _FullscreenImageViewState();
}

class _FullscreenImageViewState extends State<_FullscreenImageView> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Images
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    placeholder: (_, _) => const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (_, _, _) => const Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: Colors.white54,
                    ),
                  ),
                ),
              );
            },
          ),

          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.md,
            right: AppSpacing.md,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 22),
              ),
            ),
          ),

          // Pagination dots
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + AppSpacing.xl,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                return Container(
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentPage == index
                        ? AppColors.white
                        : Colors.white54,
                  ),
                );
              }),
            ),
          ),

          // Page indicator
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.md,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentPage + 1}/${widget.images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
