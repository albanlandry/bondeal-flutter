import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/verify_number_screen.dart';
import 'screens/auth/set_password_screen.dart';
import 'screens/auth/setup_profile_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/favorites_screen.dart';
import 'screens/home/item_details_screen.dart';
import 'screens/home/post_item_screen.dart';
import 'screens/home/notifications_screen.dart';
import 'screens/chat/chat_list_screen.dart';
import 'screens/chat/chatroom_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/search/search_results_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/settings/notification_settings_screen.dart';
import 'screens/settings/privacy_settings_screen.dart';
import 'screens/settings/help_support_screen.dart';
import 'screens/settings/terms_screen.dart';
import 'screens/home/dev_menu_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    // Auth routes
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),
    GoRoute(path: '/verify-number', builder: (_, __) => const VerifyNumberScreen()),
    GoRoute(path: '/set-password', builder: (_, __) => const SetPasswordScreen()),
    GoRoute(path: '/setup-profile', builder: (_, __) => const SetupProfileScreen()),

    // Main tab shell
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/menu', builder: (_, __) => const DevMenuScreen()),
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/favorites', builder: (_, __) => const FavoritesScreen()),
        GoRoute(path: '/chat', builder: (_, __) => const ChatListScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),

    // Stack routes
    GoRoute(
      path: '/item-details',
      builder: (context, state) {
        final productId = state.uri.queryParameters['id'];
        return ItemDetailsScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/product/:id',
      redirect: (context, state) {
        final productId = state.pathParameters['id'];
        return productId == null ? '/item-details' : '/item-details?id=$productId';
      },
    ),
    GoRoute(path: '/post-item', builder: (_, __) => const PostItemScreen()),
    GoRoute(path: '/chatroom', builder: (_, __) => const ChatroomScreen()),
    GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
    GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
    GoRoute(
      path: '/search-results',
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? '';
        return SearchResultsScreen(query: query);
      },
    ),
    GoRoute(path: '/edit-profile', builder: (_, __) => const EditProfileScreen()),
    GoRoute(path: '/my-listings', builder: (_, __) => const HomeScreen()), // reuse home for now
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    GoRoute(path: '/notification-settings', builder: (_, __) => const NotificationSettingsScreen()),
    GoRoute(path: '/privacy-settings', builder: (_, __) => const PrivacySettingsScreen()),
    GoRoute(path: '/help-support', builder: (_, __) => const HelpSupportScreen()),
    GoRoute(path: '/terms-and-conditions', builder: (_, __) => const TermsScreen()),
  ],
);

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = ['/menu', '/home', '/favorites', '/chat', '/profile'];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _tabs.indexWhere((t) => location.startsWith(t));
    return index >= 0 ? index : 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => context.go(_tabs[i]),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF007AFF),
          unselectedItemColor: const Color(0xFF6C757D),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.menu_outlined), activeIcon: Icon(Icons.menu), label: 'Menu'),
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: 'Favoris'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
