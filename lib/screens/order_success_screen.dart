import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';
import '../theme/app_theme.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettingsProvider>().strings;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ORDER'),
        automaticallyImplyLeading: false, // no back to checkout
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.offWhite,
                    border: Border.all(color: AppColors.pixelGreen, width: 3),
                  ),
                  child: const Center(
                    child: Text('✅', style: TextStyle(fontSize: 52)),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  s.orderSuccess,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        letterSpacing: 2,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.divider,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '> ${s.orderOnWay}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color:
                          isDark ? AppColors.darkTextGrey : AppColors.textGrey,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/order-history'),
                    child: Text(s.viewHistory),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go('/'),
                    child: Text(s.backHome),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => context.go('/catalog'),
                  child: Text(s.continueShopping),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
