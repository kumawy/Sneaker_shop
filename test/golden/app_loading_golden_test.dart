import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sneaker_store/theme/app_theme.dart';
import 'package:sneaker_store/widgets/app_loading.dart';

void main() {
  testWidgets('AppLoading light golden', (tester) async {
    await tester.pumpWidget(
      _GoldenApp(
        theme: AppTheme.lightTheme,
        child: const AppLoading(label: 'Loading sneakers'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 120));

    await expectLater(
      find.byType(_GoldenApp),
      matchesGoldenFile('goldens/app_loading_light.png'),
    );
  });

  testWidgets('AppLoading dark golden', (tester) async {
    await tester.pumpWidget(
      _GoldenApp(
        theme: AppTheme.darkTheme,
        child: const AppLoading(label: 'Loading sneakers'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 120));

    await expectLater(
      find.byType(_GoldenApp),
      matchesGoldenFile('goldens/app_loading_dark.png'),
    );
  });
}

class _GoldenApp extends StatelessWidget {
  const _GoldenApp({
    required this.theme,
    required this.child,
  });

  final ThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        body: SizedBox(
          width: 360,
          height: 240,
          child: Center(child: child),
        ),
      ),
    );
  }
}
