import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class _DeepLinkEntry {
  final String icon;
  final String title;
  final String url;
  final String description;
  final String category;

  const _DeepLinkEntry({
    required this.icon,
    required this.title,
    required this.url,
    required this.description,
    required this.category,
  });
}

const _links = [
  _DeepLinkEntry(
    icon: '🏠',
    title: 'Home',
    url: '/',
    description: 'Root route — initial location',
    category: 'Basic Routes',
  ),
  _DeepLinkEntry(
    icon: '👟',
    title: 'Catalog',
    url: '/catalog',
    description: 'Catalog without filters',
    category: 'Basic Routes',
  ),
  _DeepLinkEntry(
    icon: '🔎',
    title: 'Catalog – Nike filter',
    url: '/catalog?brand=Nike',
    description: 'Query param: brand=Nike',
    category: 'Query Parameters',
  ),
  _DeepLinkEntry(
    icon: '📊',
    title: 'Catalog – sorted by rating',
    url: '/catalog?brand=Adidas&sort=Rating',
    description: 'Multiple query params',
    category: 'Query Parameters',
  ),
  _DeepLinkEntry(
    icon: '👁️',
    title: 'Product detail #1',
    url: '/detail/1',
    description: 'Path parameter: id=1',
    category: 'Path Parameters',
  ),
  _DeepLinkEntry(
    icon: '👁️',
    title: 'Product detail #3',
    url: '/detail/3',
    description: 'Path parameter: id=3',
    category: 'Path Parameters',
  ),
  _DeepLinkEntry(
    icon: '🎯',
    title: 'Detail via promo link',
    url: '/detail/2?ref=promo&code=SAVE20',
    description: 'Path + query params combined',
    category: 'Combined Parameters',
  ),
  _DeepLinkEntry(
    icon: '🎁',
    title: 'Promo – SUMMER25',
    url: '/promo/SUMMER25',
    description: 'Promo deep link: /promo/:code',
    category: 'Promo Deep Links',
  ),
  _DeepLinkEntry(
    icon: '🎁',
    title: 'Promo – SAVE20',
    url: '/promo/SAVE20',
    description: 'Different promo code path',
    category: 'Promo Deep Links',
  ),
  _DeepLinkEntry(
    icon: '↩️',
    title: 'Legacy URL redirect',
    url: '/sneakers/3',
    description: '/sneakers/:id → /detail/:id (GoRouter redirect)',
    category: 'Redirects',
  ),
  _DeepLinkEntry(
    icon: '❌',
    title: '404 – Not Found',
    url: '/this-does-not-exist',
    description: 'GoRouter errorBuilder handles unknown routes',
    category: 'Error Handling',
  ),
];

class DeepLinkDemoScreen extends StatefulWidget {
  const DeepLinkDemoScreen({super.key});

  @override
  State<DeepLinkDemoScreen> createState() => _DeepLinkDemoScreenState();
}

class _DeepLinkDemoScreenState extends State<DeepLinkDemoScreen> {
  String _selectedCategory = 'All';

  List<String> get _categories {
    final cats = _links.map((l) => l.category).toSet().toList();
    return ['All', ...cats];
  }

  List<_DeepLinkEntry> get _filtered {
    if (_selectedCategory == 'All') return _links;
    return _links.where((l) => l.category == _selectedCategory).toList();
  }

  Color _categoryColor(String category) {
    const map = {
      'Basic Routes': Color(0xFF1565C0),
      'Query Parameters': Color(0xFF2E7D32),
      'Path Parameters': Color(0xFF6A1B9A),
      'Combined Parameters': Color(0xFFE65100),
      'Promo Deep Links': Color(0xFF00695C),
      'Redirects': Color(0xFFC62828),
      'Error Handling': Color(0xFF37474F),
    };
    return map[category] ?? AppColors.primary;
  }

  void _navigate(String url) {
    context.go(url);
  }

  void _copyUrl(String url) {
    final full = 'https://sneakerstore.app$url';
    Clipboard.setData(ClipboardData(text: full));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $full'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Link Playground'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryLighter,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deep Links & URLs',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tap any card to navigate • Long-press to copy the shareable URL',
                  style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final selected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.divider,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? AppColors.white : AppColors.textGrey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final entry = _filtered[i];
                final catColor = _categoryColor(entry.category);

                return GestureDetector(
                  onTap: () => _navigate(entry.url),
                  onLongPress: () => _copyUrl(entry.url),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLighter,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(entry.icon,
                                  style: const TextStyle(fontSize: 22)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  entry.url,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  entry.description,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: catColor.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  entry.category.split(' ').last,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: catColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: AppColors.textGrey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
