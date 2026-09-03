import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/database/sneaker_db.dart';
import '../providers/cart_provider.dart';
import '../providers/db_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/sneaker_image.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String _paymentMethod = 'Card';
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cart = context.read<CartProvider>();
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty')),
      );
      return;
    }

    setState(() => _saving = true);
    final db = ref.read(sneakerDatabaseProvider);
    final now = DateTime.now();
    final orderNumber = DateFormat('MMddHHmmssSSS').format(now);

    try {
      final orderId = await db.orderDao.insertOrder(
        DbOrderCompanion.insert(
          orderNumber: orderNumber,
          totalAmount: cart.total,
          itemCount: cart.itemCount,
          placedAt: now,
          status: 'processing',
        ),
      );

      await db.orderDao.insertItems(
        cart.items
            .map(
              (item) => DbOrderItemCompanion.insert(
                orderId: orderId,
                sneakerId: item.sneaker.id,
                name: item.sneaker.name,
                brand: item.sneaker.brand,
                price: item.sneaker.price,
                emoji: item.sneaker.emoji,
                size: item.selectedSize,
                quantity: item.quantity,
              ),
            )
            .toList(),
      );

      cart.clearCart();
      if (mounted) context.go('/order-success');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order save error: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Contact information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (!v.contains('@')) return 'Invalid email';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressCtrl,
              decoration: const InputDecoration(
                labelText: 'Delivery address',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'Card',
                  icon: Icon(Icons.credit_card),
                  label: Text('Card'),
                ),
                ButtonSegment(
                  value: 'Cash on Delivery',
                  icon: Icon(Icons.payments_outlined),
                  label: Text('Cash'),
                ),
              ],
              selected: {_paymentMethod},
              onSelectionChanged: (selection) {
                setState(() => _paymentMethod = selection.first);
              },
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order summary',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...cart.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            SneakerImage.fromSneaker(
                              item.sneaker,
                              width: 28,
                              height: 28,
                              borderRadius: 6,
                              padding: const EdgeInsets.all(2),
                              fallbackFontSize: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                    '${item.sneaker.name} · Size ${item.selectedSize}')),
                            Text('x${item.quantity}'),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${cart.itemCount} item(s)'),
                        Text(
                          '\$${cart.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _placeOrder,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(_saving ? 'Saving...' : 'Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
