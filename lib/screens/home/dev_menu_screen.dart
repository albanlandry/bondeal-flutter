import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class DevMenuScreen extends StatelessWidget {
  const DevMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuSections = [
      _MenuSection(title: 'Authentication', items: [
        _MenuItem(title: 'Login Screen', subtitle: 'User login page', icon: Icons.login, route: '/login'),
        _MenuItem(title: 'Signup Screen', subtitle: 'User registration page', icon: Icons.person_add, route: '/signup'),
        _MenuItem(title: 'Verify Number', subtitle: 'OTP verification', icon: Icons.confirmation_number, route: '/verify-number'),
        _MenuItem(title: 'Setup Profile', subtitle: 'Set profile image and nickname', icon: Icons.account_circle, route: '/setup-profile'),
        _MenuItem(title: 'Set Password', subtitle: 'Set password after verification', icon: Icons.lock, route: '/set-password'),
        _MenuItem(title: 'Terms & Conditions', subtitle: 'User consent screen', icon: Icons.description, route: '/terms-and-conditions'),
      ]),
      _MenuSection(title: 'Main Screens', items: [
        _MenuItem(title: 'Home', subtitle: 'Product listing', icon: Icons.home, route: '/home'),
        _MenuItem(title: 'Item Details', subtitle: 'Product details page', icon: Icons.info, route: '/item-details'),
        _MenuItem(title: 'Post Item', subtitle: 'Create new product listing', icon: Icons.add_circle, route: '/post-item'),
        _MenuItem(title: 'Search', subtitle: 'Search products', icon: Icons.search, route: '/search'),
        _MenuItem(title: 'Search Results', subtitle: 'Filtered search results', icon: Icons.filter_list, route: '/search-results'),
        _MenuItem(title: 'Chat', subtitle: 'Messaging list', icon: Icons.chat, route: '/chat'),
        _MenuItem(title: 'Chatroom', subtitle: 'Individual chat conversation', icon: Icons.forum, route: '/chatroom'),
        _MenuItem(title: 'Notifications', subtitle: 'User notifications', icon: Icons.notifications, route: '/notifications'),
        _MenuItem(title: 'Profile', subtitle: 'User profile', icon: Icons.person, route: '/profile'),
      ]),
      _MenuSection(title: 'User Management', items: [
        _MenuItem(title: 'Edit Profile', subtitle: 'Edit user profile information', icon: Icons.edit, route: '/edit-profile'),
        _MenuItem(title: 'My Listings', subtitle: 'Manage your product listings', icon: Icons.list, route: '/my-listings'),
        _MenuItem(title: 'Favorites', subtitle: 'View favorited products', icon: Icons.favorite, route: '/favorites'),
      ]),
      _MenuSection(title: 'Settings', items: [
        _MenuItem(title: 'Settings', subtitle: 'Main settings screen', icon: Icons.settings, route: '/settings'),
        _MenuItem(title: 'Notification Settings', subtitle: 'Configure notification preferences', icon: Icons.notifications_active, route: '/notification-settings'),
        _MenuItem(title: 'Privacy Settings', subtitle: 'Manage privacy preferences', icon: Icons.privacy_tip, route: '/privacy-settings'),
        _MenuItem(title: 'Help & Support', subtitle: 'Get help and contact support', icon: Icons.help_outline, route: '/help-support'),
      ]),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(bottom: BorderSide(color: AppColors.grayLight)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Development Menu', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFFF6B6B), borderRadius: BorderRadius.circular(12)),
                    child: const Text('DEV', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                children: [
                  // Description
                  Container(
                    margin: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9E6),
                      borderRadius: BorderRadius.circular(8),
                      border: const Border(left: BorderSide(color: Color(0xFFFFD700), width: 3)),
                    ),
                    child: const Text(
                      'Quick navigation to all screens in the app. This menu will be removed in production.',
                      style: TextStyle(fontSize: 14, color: AppColors.gray),
                    ),
                  ),

                  // Sections
                  ...menuSections.map((section) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
                        child: Text(
                          section.title.toUpperCase(),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.gray, letterSpacing: 0.5),
                        ),
                      ),
                      ...section.items.map((item) => _MenuItemTile(item: item)),
                    ],
                  )),

                  // Footer
                  Container(
                    margin: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                      border: const Border(left: BorderSide(color: AppColors.success, width: 3)),
                    ),
                    child: const Text(
                      'Tip: Use this menu to test all screens during development',
                      style: TextStyle(fontSize: 13, color: Color(0xFF2E7D32)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuSection {
  final String title;
  final List<_MenuItem> items;
  const _MenuSection({required this.title, required this.items});
}

class _MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  const _MenuItem({required this.title, required this.subtitle, required this.icon, required this.route});
}

class _MenuItemTile extends StatelessWidget {
  final _MenuItem item;
  const _MenuItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: InkWell(
        onTap: () => context.push(item.route),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.grayLight)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(item.icon, size: 24, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                    const SizedBox(height: 2),
                    Text(item.subtitle, style: const TextStyle(fontSize: 13, color: AppColors.gray)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 24, color: AppColors.gray),
            ],
          ),
        ),
      ),
    );
  }
}
