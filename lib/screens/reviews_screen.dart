import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/sneaker_review.dart';
import '../models/admin_product_dao.dart';
import '../providers/firebase_providers.dart';
import '../providers/firebase_status_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_loading.dart';
import '../widgets/shimmer_box.dart';

class ReviewsScreen extends ConsumerWidget {
  const ReviewsScreen({
    super.key,
    required this.sneakerId,
    required this.sneakerName,
  });

  final int sneakerId;
  final String sneakerName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseStatus = context.watch<FirebaseStatusProvider>();

    Widget backButton() {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/catalog');
          }
        },
      );
    }

    if (!firebaseStatus.ready) {
      return Scaffold(
        appBar: AppBar(
          leading: backButton(),
          title: Text('$sneakerName Reviews'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_off,
                  size: 56,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Firebase is not configured yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cloud reviews are unavailable right now.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.go('/profile'),
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Open Profile'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final userDao = ref.watch(userDaoProvider);
    final authState = ref.watch(authStateProvider);
    final isLoggedIn = authState.maybeWhen(
      data: (user) => user != null,
      orElse: () => userDao.isLoggedIn(),
    );

    return Scaffold(
      appBar: AppBar(
        leading: backButton(),
        title: Text('$sneakerName Reviews'),
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Log out',
              onPressed: () => userDao.logout(),
            ),
        ],
      ),
      body:
          isLoggedIn ? _ReviewsList(sneakerId: sneakerId) : const _LoginForm(),
    );
  }
}

class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(bool isLogin) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final userDao = ref.read(userDaoProvider);

    final error = isLogin
        ? await userDao.login(
            _emailCtrl.text.trim(),
            _passwordCtrl.text,
          )
        : await userDao.signup(
            _emailCtrl.text.trim(),
            _passwordCtrl.text,
          );

    if (mounted) {
      setState(() => _loading = false);
    }

    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔐', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              'Sign in to post reviews',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outlined),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Min 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            if (_loading)
              const AppLoading(label: 'Loading')
            else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submit(true),
                  child: const Text('Log In'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _submit(false),
                  child: const Text('Sign Up'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReviewsList extends ConsumerStatefulWidget {
  const _ReviewsList({required this.sneakerId});

  final int sneakerId;

  @override
  ConsumerState<_ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends ConsumerState<_ReviewsList> {
  final _textCtrl = TextEditingController();

  double _selectedRating = 5;
  bool _posting = false;

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    final text = _textCtrl.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write a review first.')),
      );
      return;
    }

    setState(() => _posting = true);

    try {
      final dao = ref.read(reviewDaoProvider);

      await dao.postReview(
        sneakerId: widget.sneakerId,
        text: text,
        rating: _selectedRating,
      );

      _textCtrl.clear();

      if (mounted) {
        setState(() {
          _selectedRating = 5;
          _posting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review added')),
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() => _posting = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add review: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteReview(SneakerReview review) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete review?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await ref.read(reviewDaoProvider).deleteReview(review);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review deleted')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Delete failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(reviewsProvider(widget.sneakerId));
    final avgAsync = ref.watch(avgRatingProvider(widget.sneakerId));
    final userDao = ref.watch(userDaoProvider);
    final currentUserId = userDao.userId();
    final isAdmin = isAdminEmail(userDao.email());

    final dateFmt = DateFormat('MMM d, y · HH:mm');

    return Column(
      children: [
        avgAsync.when(
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
          data: (avg) {
            return Container(
              color: AppColors.primaryLighter,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 6),
                  Text(
                    avg == 0
                        ? 'No ratings yet'
                        : '${avg.toStringAsFixed(1)} community average',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your rating:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) {
                    return IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        index < _selectedRating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedRating = (index + 1).toDouble();
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Write your review…',
                      ),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _posting ? null : _post,
                    icon: _posting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: reviewsAsync.when(
            loading: () {
              return const _ReviewsSkeleton();
            },
            error: (error, _) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Error: $error',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
            data: (List<SneakerReview> reviews) {
              if (reviews.isEmpty) {
                return const Center(
                  child: Text(
                    'No reviews yet.\nBe the first to review this sneaker!',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: reviews.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  final canDelete =
                      isAdmin || (currentUserId != null && currentUserId == review.userId);

                  final reviewTile = Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (starIndex) {
                                return Icon(
                                  starIndex < review.rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 16,
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                review.email,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (canDelete)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                tooltip: 'Delete review',
                                onPressed: () => _deleteReview(review),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(review.text),
                        const SizedBox(height: 4),
                        Text(
                          dateFmt.format(review.date),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );

                  return reviewTile;
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ReviewsSkeleton extends StatelessWidget {
  const _ReviewsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const Divider(height: 24),
      itemBuilder: (context, index) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShimmerBox(width: 92, height: 16, borderRadius: 8),
                SizedBox(width: 10),
                Expanded(child: ShimmerBox(height: 14, borderRadius: 7)),
              ],
            ),
            SizedBox(height: 10),
            ShimmerBox(height: 14, borderRadius: 7),
            SizedBox(height: 8),
            ShimmerBox(width: 210, height: 14, borderRadius: 7),
            SizedBox(height: 10),
            ShimmerBox(width: 130, height: 11, borderRadius: 6),
          ],
        );
      },
    );
  }
}
