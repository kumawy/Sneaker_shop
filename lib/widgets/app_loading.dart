import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLoading extends StatefulWidget {
  const AppLoading({super.key, this.label = 'Loading'});

  final String label;

  @override
  State<AppLoading> createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: Tween<double>(begin: 0.86, end: 1.08).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            ),
            child: RotationTransition(
              turns: Tween<double>(begin: -0.02, end: 0.02).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
              ),
              child: Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.accent, width: 2),
                ),
                child: const Center(
                  child: Text('👟', style: TextStyle(fontSize: 36)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.accent,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
