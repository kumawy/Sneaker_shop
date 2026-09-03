import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stream_cart_provider.dart';
import '../providers/stream_bookmark_provider.dart';
import '../theme/app_theme.dart';

class StreamsDemoScreen extends StatefulWidget {
  const StreamsDemoScreen({super.key});

  @override
  State<StreamsDemoScreen> createState() => _StreamsDemoScreenState();
}

class _StreamsDemoScreenState extends State<StreamsDemoScreen> {
  final StreamController<int> _counterController =
      StreamController<int>.broadcast();

  int _counter = 0;
  final List<String> _eventLog = [];

  StreamSubscription<int>? _subscription;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _subscription = _counterController.stream.listen(
      (value) {
        setState(() {
          _eventLog.insert(0,
              '📥 Received: $value at ${DateTime.now().toIso8601String().substring(11, 19)}');
          if (_eventLog.length > 8) _eventLog.removeLast();
        });
      },
      onError: (error) => setState(() {
        _eventLog.insert(0, '❌ Error: $error');
      }),
      onDone: () => setState(() {
        _eventLog.insert(0, '✅ Stream closed');
      }),
    );
    setState(() => _isListening = true);
  }

  void _cancelSubscription() {
    _subscription?.cancel();
    setState(() {
      _isListening = false;
      _eventLog.insert(0, '🚫 Subscription cancelled');
    });
  }

  void _increment() {
    _counter++;
    _counterController.sink.add(_counter);
    setState(() {
      _eventLog.insert(0, '📤 Sent: $_counter');
      if (_eventLog.length > 8) _eventLog.removeLast();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _counterController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streamCart = context.watch<StreamCartProvider>();
    final streamBookmarks = context.watch<StreamBookmarkProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Streams Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              icon: Icons.stream,
              title: 'Stream Controller',
              subtitle: 'sink.add() sends data to stream listeners',
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<int>(
                      stream: _counterController.stream,
                      initialData: 0,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            Text(
                              '${snapshot.data ?? 0}',
                              style: const TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary),
                            ),
                            Text(
                              snapshot.connectionState == ConnectionState.active
                                  ? '🟢 Stream active'
                                  : '⚫ Waiting…',
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textGrey),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('sink.add() — send event'),
                          onPressed: _increment,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isListening
                              ? _cancelSubscription
                              : _startListening,
                          child: Text(_isListening
                              ? 'cancel() subscription'
                              : 'listen() again'),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    const Text('Event log:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: _eventLog.isEmpty
                          ? const Text('No events yet',
                              style: TextStyle(color: AppColors.textGrey))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _eventLog
                                  .map((e) => Text(e,
                                      style: const TextStyle(fontSize: 12)))
                                  .toList(),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _SectionHeader(
              icon: Icons.shopping_cart,
              title: 'Cart Stream',
              subtitle:
                  'StreamCartProvider broadcasts CartState on every mutation',
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder<CartState>(
                  stream: streamCart.cartStream,
                  initialData: CartState(items: streamCart.items),
                  builder: (context, snapshot) {
                    final state =
                        snapshot.data ?? CartState(items: streamCart.items);
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatChip(
                                label: 'Items',
                                value: '${state.itemCount}',
                                icon: Icons.shopping_bag),
                            _StatChip(
                                label: 'Total',
                                value: '\$${state.total.toStringAsFixed(2)}',
                                icon: Icons.attach_money),
                            _StatChip(
                                label: 'Products',
                                value: '${state.items.length}',
                                icon: Icons.inventory_2),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Connection: ${snapshot.connectionState.name}',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textGrey),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Cart badges update instantly via stream — no setState() required in the NavBar!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textGrey,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            _SectionHeader(
              icon: Icons.bookmark,
              title: 'Broadcast Stream — Bookmarks',
              subtitle:
                  'Multiple listeners (NavBar + this widget) on same stream',
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder<List<dynamic>>(
                  stream: streamBookmarks.bookmarkStream,
                  initialData: streamBookmarks.bookmarks,
                  builder: (context, snapshot) {
                    final count = snapshot.data?.length ?? 0;
                    return Column(children: [
                      Text(
                        '$count',
                        style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      const Text(
                        'bookmarks saved\n(NavBar badge reads the same broadcast stream)',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: AppColors.textGrey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      _CodeBox(
                        code:
                            'final broadcastStream =\n  singleStream.asBroadcastStream(\n    onListen: (sub) {\n      sink.add(currentState);\n    },\n  );',
                      ),
                    ]);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            _SectionHeader(
              icon: Icons.lightbulb_outline,
              title: ' Stream Concepts',
              subtitle: 'Summary of what was implemented',
            ),
            const _ConceptCard(
              icon: '🎮',
              title: 'StreamController',
              body:
                  'Owns the stream and the sink. Use sink.add(data) to push events.',
            ),
            const _ConceptCard(
              icon: '🔊',
              title: 'Broadcast Stream',
              body:
                  'asBroadcastStream() allows multiple listeners. Used for NavBar badge + Streams Demo simultaneously.',
            ),
            const _ConceptCard(
              icon: '🏗️',
              title: 'StreamBuilder',
              body:
                  'Wraps a stream and rebuilds the widget automatically when new data arrives. No manual setState().',
            ),
            const _ConceptCard(
              icon: '📋',
              title: 'StreamSubscription',
              body:
                  'Returned by stream.listen(). Call cancel() to stop receiving events and free resources.',
            ),
            const _ConceptCard(
              icon: '🗑️',
              title: 'Close in dispose()',
              body:
                  'Always call _controller.close() in dispose() to prevent memory leaks.',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _SectionHeader(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text(subtitle,
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textGrey)),
          ]),
        ),
      ]),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatChip(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(icon, color: AppColors.primary, size: 20),
      const SizedBox(height: 4),
      Text(value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      Text(label,
          style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
    ]);
  }
}

class _CodeBox extends StatelessWidget {
  final String code;
  const _CodeBox({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(code,
          style: const TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'monospace',
              fontSize: 11)),
    );
  }
}

class _ConceptCard extends StatelessWidget {
  final String icon;
  final String title;
  final String body;
  const _ConceptCard(
      {required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 24)),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(body,
            style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
      ),
    );
  }
}
