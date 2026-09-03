import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/sneaker_data.dart';
import '../models/sneaker.dart';
import '../providers/firebase_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_entry.dart';
import '../widgets/animated_press_button.dart';
import '../widgets/sneaker_card.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  final String? initialBrand;
  final String? initialSort;

  const CatalogScreen({
    super.key,
    this.initialBrand,
    this.initialSort,
  });

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  static final List<String> _history = [];
  bool _showHistory = false;
  String _selectedBrand = 'All';
  String _selectedSize = 'All';
  double _maxPrice = 200;
  double _minRating = 0;
  String _sortBy = 'Default';

  final List<String> _sortOptions = [
    'Default',
    'Price: Low to High',
    'Price: High to Low',
    'Rating',
  ];

  // Track how many filters are active (for badge on button)
  int get _activeFilterCount {
    int c = 0;
    if (_selectedBrand != 'All') c++;
    if (_selectedSize != 'All') c++;
    if (_maxPrice < 200) c++;
    if (_minRating > 0) c++;
    if (_sortBy != 'Default') c++;
    return c;
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialBrand != null) {
      _selectedBrand = widget.initialBrand!;
    }
    if (widget.initialSort != null &&
        _sortOptions.contains(widget.initialSort)) {
      _sortBy = widget.initialSort!;
    }

    _searchFocus.addListener(() {
      setState(() {
        _showHistory = _searchFocus.hasFocus && _searchQuery.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  bool _matchesSearch(Sneaker s, String query) {
    if (query.isEmpty) return true;
    final q = query.trim().toLowerCase();
    return s.name.trim().toLowerCase().startsWith(q);
  }

  List<Sneaker> _filtered(List<Sneaker> source) {
    List<Sneaker> result = [...source];

    if (_selectedBrand != 'All') {
      result = result.where((s) => s.brand == _selectedBrand).toList();
    }
    if (_selectedSize != 'All') {
      result = result.where((s) => s.sizes.contains(_selectedSize)).toList();
    }
    result = result.where((s) => s.price <= _maxPrice).toList();
    result = result.where((s) => s.rating >= _minRating).toList();

    if (_searchQuery.isNotEmpty) {
      result = result.where((s) => _matchesSearch(s, _searchQuery)).toList();
    }

    switch (_sortBy) {
      case 'Price: Low to High':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return result;
  }

  void _submitSearch(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    setState(() {
      _searchQuery = q;
      _showHistory = false;
      _history.remove(q);
      _history.insert(0, q);
      if (_history.length > 8) _history.removeLast();
    });
    _searchFocus.unfocus();
  }

  void _applyHistory(String query) {
    _searchController.text = query;
    _searchController.selection =
        TextSelection.fromPosition(TextPosition(offset: query.length));
    setState(() {
      _searchQuery = query;
      _showHistory = false;
    });
    _searchFocus.unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _showHistory = _searchFocus.hasFocus;
    });
  }

  void _showFilterSheet(List<Sneaker> source) {
    final brands = [
      'All',
      ...{for (final s in source) s.brand}.toList()..sort(),
    ];
    final sizeValues = {for (final s in source) ...s.sizes}.toList()
      ..sort((a, b) {
        final ai = int.tryParse(a);
        final bi = int.tryParse(b);
        if (ai != null && bi != null) return ai.compareTo(bi);
        return a.compareTo(b);
      });
    final allSizes = ['All', ...sizeValues];

    if (!brands.contains(_selectedBrand)) _selectedBrand = 'All';
    if (!allSizes.contains(_selectedSize)) _selectedSize = 'All';

    // local copies so changes only apply on "Apply"
    String tempBrand = _selectedBrand;
    String tempSize = _selectedSize;
    double tempPrice = _maxPrice;
    double tempRating = _minRating;
    String tempSort = _sortBy;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          final textColor = isDark ? AppColors.darkText : AppColors.textDark;

          Widget sectionLabel(String text) => Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 4),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 1.5,
                    color: AppColors.textGrey,
                  ),
                ),
              );

          Widget chipRow(
            List<String> options,
            String selected,
            void Function(String) onSelect,
          ) =>
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: options.map((o) {
                  final sel = selected == o;
                  return GestureDetector(
                    onTap: () => setSheet(() => onSelect(o)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.accent : Colors.transparent,
                        border: Border.all(
                          color: sel
                              ? AppColors.accent
                              : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.textDark),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        o,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: sel ? Colors.white : textColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.tune,
                            size: 18, color: AppColors.accent),
                        const SizedBox(width: 8),
                        const Text(
                          'FILTERS & SORT',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 2,
                          ),
                        ),
                        const Spacer(),
                        // Reset all
                        GestureDetector(
                          onTap: () => setSheet(() {
                            tempBrand = 'All';
                            tempSize = 'All';
                            tempPrice = 200;
                            tempRating = 0;
                            tempSort = 'Default';
                          }),
                          child: const Text(
                            '[ RESET ]',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 2, height: 20),
                    sectionLabel('BRAND'),
                    chipRow(brands, tempBrand, (v) => tempBrand = v),
                    const SizedBox(height: 16),
                    sectionLabel('SIZE'),
                    chipRow(allSizes, tempSize, (v) => tempSize = v),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'MAX PRICE',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 1.5,
                            color: AppColors.textGrey,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.accent, width: 1),
                          ),
                          child: Text(
                            '\$${tempPrice.toInt()}',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: tempPrice,
                      min: 50,
                      max: 200,
                      divisions: 15,
                      activeColor: AppColors.accent,
                      inactiveColor:
                          isDark ? AppColors.darkBorder : AppColors.divider,
                      onChanged: (v) => setSheet(() => tempPrice = v),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'MIN RATING',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 1.5,
                            color: AppColors.textGrey,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.pixelYellow, width: 1),
                          ),
                          child: Text(
                            tempRating == 0
                                ? 'Any'
                                : '★ ${tempRating.toStringAsFixed(1)}+',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.pixelYellow,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: tempRating,
                      min: 0,
                      max: 5,
                      divisions: 10,
                      activeColor: AppColors.pixelYellow,
                      inactiveColor:
                          isDark ? AppColors.darkBorder : AppColors.divider,
                      onChanged: (v) => setSheet(() => tempRating = v),
                    ),
                    const SizedBox(height: 8),
                    sectionLabel('SORT BY'),
                    chipRow(_sortOptions, tempSort, (v) => tempSort = v),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('APPLY'),
                        onPressed: () {
                          setState(() {
                            _selectedBrand = tempBrand;
                            _selectedSize = tempSize;
                            _maxPrice = tempPrice;
                            _minRating = tempRating;
                            _sortBy = tempSort;
                          });
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sourceSneakers = ref.watch(catalogSneakersProvider).asData?.value ?? sneakerData;
    final sneakers = _filtered(sourceSneakers);
    final bgColor = isDark ? AppColors.darkCard : AppColors.cardBg;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final hintColor = isDark ? AppColors.darkTextGrey : AppColors.textGrey;
    final accentColor = isDark ? AppColors.accent : AppColors.primary;
    final infoBgColor = isDark ? AppColors.darkCard : AppColors.primaryLighter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CATALOG'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _showFilterSheet(sourceSneakers),
              child: Badge(
                isLabelVisible: _activeFilterCount > 0,
                label: Text('$_activeFilterCount'),
                child: Icon(
                  Icons.tune,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.initialBrand != null && widget.initialBrand != 'All')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: infoBgColor,
              child: Row(
                children: [
                  Icon(Icons.link, size: 16, color: accentColor),
                  const SizedBox(width: 8),
                  Text(
                    'Filtered by deep link: brand=${widget.initialBrand}',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 13,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search, color: accentColor),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
              onChanged: (val) => setState(() {
                _searchQuery = val;
                _showHistory = val.isEmpty && _searchFocus.hasFocus;
              }),
              onSubmitted: _submitSearch,
            ),
          ),
          if (_showHistory && _history.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.textDark,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                    child: Row(
                      children: [
                        Icon(Icons.history, size: 14, color: hintColor),
                        const SizedBox(width: 6),
                        Text('RECENT',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: hintColor,
                            )),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setState(() => _history.clear()),
                          child: const Text('[ CLEAR ]',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              )),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  ..._history.map((q) => InkWell(
                        onTap: () => _applyHistory(q),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              const Icon(Icons.north_west,
                                  size: 14, color: AppColors.accent),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(q,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13,
                                      color: textColor,
                                    )),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _history.remove(q)),
                                child: Icon(Icons.close,
                                    size: 14, color: hintColor),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          if (_activeFilterCount > 0)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  if (_selectedBrand != 'All')
                    _ActiveChip(
                      label: _selectedBrand,
                      icon: Icons.category_outlined,
                      onRemove: () => setState(() => _selectedBrand = 'All'),
                    ),
                  if (_selectedSize != 'All')
                    _ActiveChip(
                      label: 'Size $_selectedSize',
                      icon: Icons.straighten,
                      onRemove: () => setState(() => _selectedSize = 'All'),
                    ),
                  if (_maxPrice < 200)
                    _ActiveChip(
                      label: 'Max \$${_maxPrice.toInt()}',
                      icon: Icons.attach_money,
                      onRemove: () => setState(() => _maxPrice = 200),
                    ),
                  if (_minRating > 0)
                    _ActiveChip(
                      label: '★ ${_minRating.toStringAsFixed(1)}+',
                      icon: Icons.star_outline,
                      onRemove: () => setState(() => _minRating = 0),
                    ),
                  if (_sortBy != 'Default')
                    _ActiveChip(
                      label: _sortBy,
                      icon: Icons.sort,
                      onRemove: () => setState(() => _sortBy = 'Default'),
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
            child: Text(
              '${sneakers.length} products found',
              style: TextStyle(
                color: hintColor,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            child: sneakers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 48, color: hintColor),
                        const SizedBox(height: 12),
                        Text(
                          'No sneakers found',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            color: hintColor,
                          ),
                        ),
                        if (_activeFilterCount > 0) ...[
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => setState(() {
                              _selectedBrand = 'All';
                              _selectedSize = 'All';
                              _maxPrice = 200;
                              _minRating = 0;
                              _sortBy = 'Default';
                            }),
                            child: const Text(
                              '[ RESET FILTERS ]',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: sneakers.length,
                    itemBuilder: (context, index) {
                      final sneaker = sneakers[index];
                      return AnimatedEntry(
                        index: index,
                        child: AnimatedPressButton(
                          onTap: () => context.pushNamed(
                            'detail',
                            pathParameters: {'id': '${sneaker.id}'},
                            queryParameters: {'ref': 'catalog'},
                          ),
                          child: SneakerCard(
                            sneaker: sneaker,
                            heroPrefix: 'catalog',
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

class _ActiveChip extends StatelessWidget {
  const _ActiveChip({
    required this.label,
    required this.icon,
    required this.onRemove,
  });
  final String label;
  final IconData icon;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        border: Border.all(color: AppColors.accent, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 12, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}
