import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import 'data/database/sneaker_db.dart';
import 'firebase_options.dart';
import 'providers/app_settings_provider.dart';
import 'providers/bookmark_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/compare_provider.dart';
import 'providers/db_providers.dart';
import 'providers/firebase_status_provider.dart';
import 'providers/stream_bookmark_provider.dart';
import 'providers/stream_cart_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  final firebaseStatus = FirebaseStatusProvider();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseStatus.markReady();
  } catch (error) {
    debugPrint('Firebase initialization skipped: $error');
    firebaseStatus.markError(error);
  }

  final bookmarkProvider = BookmarkProvider();
  await bookmarkProvider.loadBookmarks();

  final cartProvider = CartProvider();
  final sneakerDb = SneakerDatabase();
  final appSettings = AppSettingsProvider();
  await appSettings.load();

  runApp(
    ProviderScope(
      overrides: [
        sneakerDatabaseProvider.overrideWithValue(sneakerDb),
      ],
      child: SneakerStoreApp(
        bookmarkProvider: bookmarkProvider,
        cartProvider: cartProvider,
        firebaseStatus: firebaseStatus,
        appSettings: appSettings,
      ),
    ),
  );
}

class SneakerStoreApp extends StatelessWidget {
  final BookmarkProvider bookmarkProvider;
  final CartProvider cartProvider;
  final FirebaseStatusProvider firebaseStatus;
  final AppSettingsProvider appSettings;

  const SneakerStoreApp({
    super.key,
    required this.bookmarkProvider,
    required this.cartProvider,
    required this.firebaseStatus,
    required this.appSettings,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppSettingsProvider>.value(value: appSettings),
        ChangeNotifierProvider<FirebaseStatusProvider>.value(
            value: firebaseStatus),
        ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
        ChangeNotifierProvider<StreamCartProvider>.value(value: cartProvider),
        ChangeNotifierProvider(create: (_) => CompareProvider()),
        ChangeNotifierProvider<BookmarkProvider>.value(value: bookmarkProvider),
        ChangeNotifierProvider<StreamBookmarkProvider>.value(
            value: bookmarkProvider),
      ],
      child: Consumer<AppSettingsProvider>(
        builder: (_, settings, __) => MaterialApp.router(
          title: 'SneakerStore',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
