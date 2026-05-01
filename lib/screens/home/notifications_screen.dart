import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/product.dart';
import '../../models/mock_data.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<AppNotification> _notifications;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _notifications = List<AppNotification>.from(
      mockNotifications.map((n) => AppNotification(
            id: n.id,
            type: n.type,
            title: n.title,
            message: n.message,
            timestamp: n.timestamp,
            isRead: n.isRead,
            avatar: n.avatar,
            productImage: n.productImage,
          )),
    );
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  bool get _hasUnread => _notifications.any((n) => !n.isRead);

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _markRead(AppNotification notification) {
    setState(() {
      notification.isRead = true;
    });
  }

  void _deleteNotification(AppNotification notification) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous supprimer cette notification ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _notifications.remove(notification);
              });
            },
            child: const Text('Supprimer', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'message':
        return Icons.chat_bubble;
      case 'like':
        return Icons.favorite;
      case 'view':
        return Icons.visibility;
      case 'sale':
        return Icons.shopping_cart;
      case 'offer':
        return Icons.local_offer;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'message':
        return AppColors.primary;
      case 'like':
        return const Color(0xFFE91E63);
      case 'view':
        return const Color(0xFFFF9800);
      case 'sale':
        return AppColors.success;
      case 'offer':
        return const Color(0xFF9C27B0);
      case 'system':
        return AppColors.gray;
      default:
        return AppColors.gray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
        actions: [
          if (_hasUnread && !_isLoading)
            TextButton(
              onPressed: _markAllRead,
              child: const Text(
                'Tout marquer',
                style: TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ),
        ],
      ),
      body: _isLoading ? _buildSkeleton() : _buildContent(),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.grayLight,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: 120,
                      decoration: BoxDecoration(
                        color: AppColors.grayLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.grayLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      height: 10,
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppColors.grayLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.gray),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Aucune notification',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Vous n\'avez pas encore de notifications.\nElles apparaîtront ici.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _notifications.length,
      separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.grayLight),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationTile(notification);
      },
    );
  }

  Widget _buildNotificationTile(AppNotification notification) {
    final typeColor = _colorForType(notification.type);
    final typeIcon = _iconForType(notification.type);

    return Container(
      color: notification.isRead ? AppColors.white : AppColors.background,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blue dot for unread
          if (!notification.isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 18, right: AppSpacing.xs),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(width: 12),
          // Type icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(typeIcon, color: typeColor, size: 22),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  notification.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  notification.timestamp,
                  style: const TextStyle(fontSize: 11, color: AppColors.gray),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Product image
          if (notification.productImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                notification.productImage!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.grayLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image, color: AppColors.gray, size: 24),
                ),
              ),
            ),
          // Action buttons
          Column(
            children: [
              if (!notification.isRead)
                InkWell(
                  onTap: () => _markRead(notification),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.check, size: 18, color: AppColors.success),
                  ),
                ),
              InkWell(
                onTap: () => _deleteNotification(notification),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
