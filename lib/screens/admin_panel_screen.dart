import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/sneaker.dart';
import '../providers/firebase_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/app_loading.dart';

class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _sort = 'Name';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Sneaker> _filterAndSort(List<Sneaker> items) {
    final q = _query.trim().toLowerCase();
    var result = q.isEmpty
        ? [...items]
        : items.where((s) {
            return s.name.toLowerCase().contains(q) ||
                s.brand.toLowerCase().contains(q) ||
                s.id.toString() == q;
          }).toList();

    switch (_sort) {
      case 'Price low':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price high':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Brand':
        result.sort((a, b) => a.brand.compareTo(b.brand));
        break;
      default:
        result.sort((a, b) => a.name.compareTo(b.name));
    }
    return result;
  }

  Future<void> _openEditor({Sneaker? sneaker, required List<Sneaker> all}) async {
    final dao = ref.read(adminProductDaoProvider);
    final isNew = sneaker == null;
    final item = sneaker ??
        Sneaker(
          id: dao.nextId(all),
          name: '',
          brand: '',
          price: 99,
          description: '',
          sizes: const ['39', '40', '41', '42', '43'],
          colors: const ['White', 'Black'],
          emoji: '👟',
          imageUrl: null,
          rating: 0,
          reviews: 0,
        );

    final saved = await showModalBottomSheet<Sneaker>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ProductEditor(initial: item, isNew: isNew),
    );

    if (saved == null) return;
    try {
      await dao.saveProduct(saved);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isNew ? 'Sneaker added' : 'Sneaker updated')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _delete(Sneaker sneaker) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete ${sneaker.name}?'),
        content: const Text(
          'This hides the sneaker from the app. You can add it again later from Firestore.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await ref.read(adminProductDaoProvider).deleteProduct(sneaker.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sneaker deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
    final email = auth.asData?.value?.email ?? ref.watch(userDaoProvider).email();
    final isAdmin = email != null && (email == 'admin@test.com' || email == 'aslanmuratov09@gmail.com');
    final productsAsync = ref.watch(catalogSneakersProvider);

    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.canPop() ? context.pop() : context.go('/profile'),
          ),
          title: const Text('Admin Panel'),
        ),
        body: const Center(child: Text('Admin access required.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/profile'),
        ),
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            tooltip: 'Add sneaker',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              final all = productsAsync.asData?.value ?? const <Sneaker>[];
              _openEditor(all: all);
            },
          ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const AppLoading(label: 'Loading products'),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (items) {
          final filtered = _filterAndSort(items);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Search by name, brand, or id',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() => _query = '');
                                },
                              ),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Text('${filtered.length} products')),
                        DropdownButton<String>(
                          value: _sort,
                          items: const [
                            DropdownMenuItem(value: 'Name', child: Text('Name')),
                            DropdownMenuItem(value: 'Brand', child: Text('Brand')),
                            DropdownMenuItem(value: 'Price low', child: Text('Price low')),
                            DropdownMenuItem(value: 'Price high', child: Text('Price high')),
                          ],
                          onChanged: (v) => setState(() => _sort = v ?? 'Name'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final s = filtered[index];
                    return Dismissible(
                      key: ValueKey('admin-product-${s.id}'),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        await _delete(s);
                        return false;
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${s.id}')),
                        title: Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('${s.brand} • ${s.sizes.join(', ')}'),
                        trailing: Text(
                          '\$${s.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () => _openEditor(sneaker: s, all: items),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final all = productsAsync.asData?.value ?? const <Sneaker>[];
          _openEditor(all: all);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }
}

class _ProductEditor extends StatefulWidget {
  const _ProductEditor({required this.initial, required this.isNew});

  final Sneaker initial;
  final bool isNew;

  @override
  State<_ProductEditor> createState() => _ProductEditorState();
}

class _ProductEditorState extends State<_ProductEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _brand;
  late final TextEditingController _price;
  late final TextEditingController _description;
  late final TextEditingController _sizes;
  late final TextEditingController _colors;
  late final TextEditingController _emoji;
  late final TextEditingController _imageUrl;

  @override
  void initState() {
    super.initState();
    final s = widget.initial;
    _name = TextEditingController(text: s.name);
    _brand = TextEditingController(text: s.brand);
    _price = TextEditingController(text: s.price.toStringAsFixed(2));
    _description = TextEditingController(text: s.description);
    _sizes = TextEditingController(text: s.sizes.join(', '));
    _colors = TextEditingController(text: s.colors.join(', '));
    _emoji = TextEditingController(text: s.emoji);
    _imageUrl = TextEditingController(text: s.imageUrl ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _brand.dispose();
    _price.dispose();
    _description.dispose();
    _sizes.dispose();
    _colors.dispose();
    _emoji.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  List<String> _csv(String value) => value
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final price = double.parse(_price.text.trim().replaceAll(',', '.'));
    final saved = widget.initial.copyWith(
      name: _name.text.trim(),
      brand: _brand.text.trim(),
      price: price,
      description: _description.text.trim(),
      sizes: _csv(_sizes.text),
      colors: _csv(_colors.text),
      emoji: _emoji.text.trim().isEmpty ? '👟' : _emoji.text.trim(),
      imageUrl: _imageUrl.text.trim().isEmpty ? null : _imageUrl.text.trim(),
    );
    Navigator.pop(context, saved);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      widget.isNew ? 'Add Sneaker' : 'Edit Sneaker #${widget.initial.id}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 12),
                _field(_name, 'Name'),
                _field(_brand, 'Brand'),
                _field(_price, 'Price', keyboardType: TextInputType.number, validator: (v) {
                  final n = double.tryParse((v ?? '').replaceAll(',', '.'));
                  if (n == null || n <= 0) return 'Enter valid price';
                  return null;
                }),
                _field(_description, 'Description', maxLines: 3),
                _field(_sizes, 'Sizes, comma separated'),
                _field(_colors, 'Colors, comma separated'),
                _field(_emoji, 'Emoji'),
                _field(_imageUrl, 'Image URL (optional)'),
                const SizedBox(height: 8),
                const Text(
                  'Photo options: paste a direct image URL now, or later add Firebase Storage upload and save the download URL here.',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: validator ?? (v) => v == null || v.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
}
