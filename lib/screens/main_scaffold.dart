import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/app_settings_provider.dart';
import '../providers/favourite_providers.dart';
import '../providers/firebase_providers.dart';
import '../providers/firebase_status_provider.dart';
import '../providers/stream_cart_provider.dart';
import '../theme/app_theme.dart';

class _NavIcon extends StatelessWidget {
  const _NavIcon(this.icon, {this.badge = 0});
  final IconData icon;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final widget = Icon(icon);
    if (badge > 0) {
      return Badge(label: Text('$badge'), child: widget);
    }
    return widget;
  }
}

class MainScaffold extends ConsumerWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/catalog')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/favourites')) return 3;
    if (location.startsWith('/profile') ||
        location.startsWith('/orders') ||
        location.startsWith('/order-history') ||
        location.startsWith('/wishlist') ||
        location.startsWith('/compare') ||
        location.startsWith('/network') ||
        location.startsWith('/streams')) {
      return 4;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final cartCount = context.watch<StreamCartProvider>().itemCount;
    final s = context.watch<AppSettingsProvider>().strings;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final idx = _locationToIndex(location);

    final firebaseStatus = context.watch<FirebaseStatusProvider>();
    final userDao = ref.watch(userDaoProvider);
    int favCount = 0;
    if (firebaseStatus.ready && userDao.isLoggedIn()) {
      final favAsync = ref.watch(favouritesStreamProvider);
      favCount = favAsync.asData?.value.length ?? 0;
    }
    const icons = [
      Icons.home_outlined,
      Icons.grid_view_outlined,
      Icons.shopping_bag_outlined,
      Icons.favorite_border,
      Icons.person_outline,
    ];
    const selectedIcons = [
      Icons.home,
      Icons.grid_view_rounded,
      Icons.shopping_bag,
      Icons.favorite,
      Icons.person,
    ];
    final labels = [s.home, s.catalog, s.cart, s.favourites, s.profile];
    final badges = [0, 0, cartCount, favCount, 0];
    final routes = ['/', '/catalog', '/cart', '/favourites', '/profile'];

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.divider,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: idx,
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.cardBg,
          indicatorColor: AppColors.accent,
          elevation: 0,
          onDestinationSelected: (i) => context.go(routes[i]),
          destinations: List.generate(5, (i) {
            return NavigationDestination(
              icon: _NavIcon(icons[i], badge: badges[i]),
              selectedIcon: _NavIcon(selectedIcons[i], badge: badges[i]),
              label: labels[i],
            );
          }),
        ),
      ),
    );
  }
}
