import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/catalog_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/order_success_screen.dart';
import '../screens/main_scaffold.dart';
import '../screens/not_found_screen.dart';
import '../screens/compare_screen.dart';
import '../screens/network_screen.dart';
import '../screens/streams_demo_screen.dart';
import '../screens/wishlist_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/reviews_screen.dart';
import '../screens/favourites_screen.dart';
import '../screens/admin_panel_screen.dart';

bool _isKnownPath(String path) {
  if (path == '/') return true;
  if (path == '/catalog') return true;
  if (path == '/cart') return true;
  if (path == '/compare') return true;
  if (path == '/network') return true;
  if (path == '/streams-demo') return true;
  if (path == '/profile') return true;
  if (path == '/checkout') return true;
  if (path == '/order-success') return true;
  if (path == '/404') return true;
  if (path == '/wishlist') return true;
  if (path == '/order-history') return true;
  if (path.startsWith('/reviews/')) return true;
  if (path.startsWith('/detail/')) return true;
  if (path.startsWith('/sneakers/')) return true;
  if (path == '/favourites') return true;
  if (path == '/admin') return true;
  return false;
}

CustomTransitionPage<void> _fadeSlidePage(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 210),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.04, 0.02),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  redirect: (context, state) {
    final path = state.uri.path;
    final sneakersMatch = RegExp(r'^/sneakers/(\d+)$').firstMatch(path);
    if (sneakersMatch != null) {
      return '/detail/${sneakersMatch.group(1)}';
    }
    if (!_isKnownPath(path)) {
      return '/404?from=${Uri.encodeComponent(path)}';
    }
    return null;
  },
  errorBuilder: (context, state) => NotFoundScreen(
    attemptedPath: state.uri.toString(),
    error: state.error is Exception
        ? state.error as Exception
        : Exception(state.error.toString()),
  ),
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) =>
              _fadeSlidePage(state, const HomeScreen()),
        ),
        GoRoute(
          path: '/catalog',
          name: 'catalog',
          pageBuilder: (context, state) {
            final brand = state.uri.queryParameters['brand'];
            final sort = state.uri.queryParameters['sort'];
            return _fadeSlidePage(
              state,
              CatalogScreen(initialBrand: brand, initialSort: sort),
            );
          },
        ),
        GoRoute(
          path: '/cart',
          name: 'cart',
          pageBuilder: (context, state) =>
              _fadeSlidePage(state, const CartScreen()),
        ),
        GoRoute(
          path: '/compare',
          name: 'compare',
          pageBuilder: (context, state) =>
              _fadeSlidePage(state, const CompareScreen()),
        ),
        GoRoute(
          path: '/network',
          name: 'network',
          pageBuilder: (context, state) =>
              _fadeSlidePage(state, const NetworkScreen()),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) =>
              _fadeSlidePage(state, const ProfileScreen()),
        ),
        GoRoute(
          path: '/wishlist',
          name: 'wishlist',
          pageBuilder: (context, state) =>
              _fadeSlidePage(state, const WishlistScreen()),
        ),
        GoRoute(
          path: '/order-history',
          name: 'order-history',
          pageBuilder: (context, state) =>
              _fadeSlidePage(state, const OrderHistoryScreen()),
        ),
        GoRoute(
          path: '/favourites',
          name: 'favourites',
          pageBuilder: (context, state) =>
              _fadeSlidePage(state, const FavouritesScreen()),
        ),
        GoRoute(
          path: '/admin',
          name: 'admin',
          pageBuilder: (context, state) =>
              _fadeSlidePage(state, const AdminPanelScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/detail/:id',
      name: 'detail',
      pageBuilder: (context, state) {
        final rawId = state.pathParameters['id'];
        final id = int.tryParse(rawId ?? '');
        if (id == null) {
          return _fadeSlidePage(
            state,
            NotFoundScreen(
              attemptedPath: state.uri.toString(),
              error: Exception('Invalid product id'),
            ),
          );
        }
        return _fadeSlidePage(
          state,
          DetailScreen(
            sneakerId: id,
            refSource: state.uri.queryParameters['ref'],
            promoCode: state.uri.queryParameters['code'],
          ),
        );
      },
    ),
    GoRoute(
      path: '/reviews/:id',
      name: 'reviews',
      pageBuilder: (context, state) {
        final rawId = state.pathParameters['id'];
        final id = int.tryParse(rawId ?? '');
        if (id == null) {
          return _fadeSlidePage(
            state,
            NotFoundScreen(
              attemptedPath: state.uri.toString(),
              error: Exception('Product not found'),
            ),
          );
        }
        final name = state.uri.queryParameters['name'] ?? 'Sneaker';
        return _fadeSlidePage(
          state,
          ReviewsScreen(sneakerId: id, sneakerName: name),
        );
      },
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      pageBuilder: (context, state) =>
          _fadeSlidePage(state, const CheckoutScreen()),
    ),
    GoRoute(
      path: '/streams-demo',
      name: 'streams-demo',
      pageBuilder: (context, state) =>
          _fadeSlidePage(state, const StreamsDemoScreen()),
    ),
    GoRoute(
      path: '/order-success',
      name: 'order-success',
      pageBuilder: (context, state) =>
          _fadeSlidePage(state, const OrderSuccessScreen()),
    ),
    GoRoute(
      path: '/404',
      name: 'not-found',
      pageBuilder: (context, state) => _fadeSlidePage(
        state,
        NotFoundScreen(
          attemptedPath: state.uri.queryParameters['from'] ?? '',
        ),
      ),
    ),
  ],
);
