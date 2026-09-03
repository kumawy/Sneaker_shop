
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/database/sneaker_db.dart';
import '../providers/db_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/sneaker_image.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'delivered':
        return Icons.check_circle_outline;
      case 'shipped':
        return Icons.local_shipping_outlined;
      default:
        return Icons.pending_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(sneakerDatabaseProvider);
    final currFmt = NumberFormat.currency(symbol: '\$');
    final dateFmt = DateFormat('MMM d, y');

    return Scaffold(
      appBar: AppBar(title: const Text('Order History (SQLite)')),
      body: StreamBuilder<List<DbOrderData>>(
        stream: db.orderDao.watchAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📦', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text('No orders yet',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Complete a checkout to see orders here.\nAll orders are persisted locally in SQLite.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: Icon(
                    _statusIcon(order.status),
                    color: _statusColor(order.status),
                  ),
                  title: Text(
                    'Order #${order.orderNumber}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${order.itemCount} item${order.itemCount != 1 ? 's' : ''} · ${dateFmt.format(order.placedAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currFmt.format(order.totalAmount),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _statusColor(order.status)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order.status,
                          style: TextStyle(
                            fontSize: 11,
                            color: _statusColor(order.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    FutureBuilder<List<DbOrderItemData>>(
                      future: db.orderDao.itemsForOrder(order.id),
                      builder: (context, itemSnap) {
                        if (!itemSnap.hasData) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          );
                        }
                        final items = itemSnap.data!;
                        return Column(
                          children: items
                              .map(
                                (item) => ListTile(
                                  dense: true,
                                  leading: SneakerImage.fromSneakerId(
                                    item.sneakerId,
                                    emoji: item.emoji,
                                    width: 36,
                                    height: 36,
                                    borderRadius: 8,
                                    fallbackFontSize: 20,
                                  ),
                                  title: Text(item.name),
                                  subtitle:
                                      Text('${item.brand} · Size ${item.size}'),
                                  trailing: Text(
                                      'x${item.quantity}  ${currFmt.format(item.price * item.quantity)}'),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
