import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sneaker_store/models/sneaker.dart';
import 'package:sneaker_store/theme/app_theme.dart';
import 'package:sneaker_store/widgets/sneaker_card.dart';

void main() {
  testWidgets('SneakerCard light golden', (tester) async {
    await tester.pumpWidget(
      _GoldenApp(
        theme: AppTheme.lightTheme,
        child: const SizedBox(
          width: 190,
          height: 250,
          child: SneakerCard(
            sneaker: _goldenSneaker,
            heroPrefix: 'golden-light',
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(_GoldenApp),
      matchesGoldenFile('goldens/sneaker_card_light.png'),
    );
  });

  testWidgets('SneakerCard dark golden', (tester) async {
    await tester.pumpWidget(
      _GoldenApp(
        theme: AppTheme.darkTheme,
        child: const SizedBox(
          width: 190,
          height: 250,
          child: SneakerCard(
            sneaker: _goldenSneaker,
            heroPrefix: 'golden-dark',
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(_GoldenApp),
      matchesGoldenFile('goldens/sneaker_card_dark.png'),
    );
  });
}

const _goldenSneaker = Sneaker(
  id: 999,
  name: 'Golden Runner Pro',
  brand: 'Test Brand',
  price: 149.99,
  description: 'Golden test sneaker',
  sizes: ['40', '41', '42'],
  colors: ['Black', 'White'],
  emoji: '👟',
  imageUrl: null,
  rating: 4.8,
  reviews: 120,
);

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
        body: Center(child: child),
      ),
    );
  }
}
