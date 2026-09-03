import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({
    super.key,
    this.attemptedPath = '',
    this.error,
  });

  final String attemptedPath;
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = context.canPop();

    return Scaffold(
      appBar: AppBar(
        title: const Text('404'),
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.accent,
                    width: 3,
                  ),
                  color: isDark ? AppColors.darkCard : AppColors.offWhite,
                ),
                child: const Text(
                  '404',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'PAGE NOT FOUND',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              if (attemptedPath.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.divider,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '> $attemptedPath',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color:
                          isDark ? AppColors.darkTextGrey : AppColors.textGrey,
                    ),
                  ),
                ),
              ],
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              if (canPop)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('[ GO BACK ]'),
                  ),
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('[ GO TO HOME ]'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
