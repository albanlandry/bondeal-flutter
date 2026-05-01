import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onPress;

  const ProductCard({super.key, required this.product, this.onPress});

  @override
  Widget build(BuildContext context) {
    final statusConfig = product.status == 'sold'
        ? (text: 'Vendu', color: AppColors.danger, icon: Icons.check_circle)
        : (text: 'Disponible', color: AppColors.success, icon: Icons.circle);

    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.md),
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.imageUrl != null)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrl!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            width: 120, height: 120,
                            color: Colors.grey[200],
                            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            width: 120, height: 120,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusConfig.color,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2))],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusConfig.icon, size: 12, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(statusConfig.text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF333333), height: 1.2)),
                      const SizedBox(height: 2),
                      Text(product.location, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
                      const SizedBox(height: 4),
                      Text(product.price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.success)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _ActionIcon(icon: Icons.favorite_border, count: product.likes),
                const SizedBox(width: 10),
                _ActionIcon(icon: Icons.visibility_outlined, count: product.views),
                const SizedBox(width: 10),
                _ActionIcon(icon: Icons.chat_bubble_outline, count: product.comments),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  const _ActionIcon({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF666666)),
        const SizedBox(width: 4),
        Text('$count', style: const TextStyle(fontSize: 11, color: Color(0xFF666666))),
      ],
    );
  }
}

class GridProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onPress;

  const GridProductCard({super.key, required this.product, this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imageUrl != null)
              CachedNetworkImage(
                imageUrl: product.imageUrl!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(height: 160, color: Colors.grey[200]),
                errorWidget: (_, __, ___) => Container(height: 160, color: Colors.grey[200], child: const Icon(Icons.image_not_supported)),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333), height: 1.3)),
                    Text(product.location, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF666666))),
                    Text(product.price, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.success)),
                    Row(
                      children: [
                        const Icon(Icons.favorite_border, size: 12, color: Color(0xFF666666)),
                        const SizedBox(width: 4),
                        Text('${product.likes}', style: const TextStyle(fontSize: 10, color: Color(0xFF666666))),
                        const Spacer(),
                        const Icon(Icons.visibility_outlined, size: 12, color: Color(0xFF666666)),
                        const SizedBox(width: 4),
                        Text('${product.views}', style: const TextStyle(fontSize: 10, color: Color(0xFF666666))),
                      ],
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
