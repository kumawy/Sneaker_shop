import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/app_settings_provider.dart';
import '../providers/firebase_providers.dart';
import '../providers/firebase_status_provider.dart';
import '../models/admin_product_dao.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notifications = true;
  String _currency = 'USD';
  bool _loadingSettings = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifications = prefs.getBool('profile_notifications') ?? true;
      _currency = prefs.getString('profile_currency') ?? 'USD';
      _loadingSettings = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('profile_notifications', _notifications);
    await prefs.setString('profile_currency', _currency);
  }

  @override
  Widget build(BuildContext context) {
    final firebaseStatus = context.watch<FirebaseStatusProvider>();
    final s = context.watch<AppSettingsProvider>().strings;
    final email = ref.watch(authStateProvider).asData?.value?.email ?? ref.watch(userDaoProvider).email();
    final isAdmin = isAdminEmail(email);

    return Scaffold(
      appBar: AppBar(title: Text(s.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          firebaseStatus.ready
              ? _FirebaseAccountCard(strings: s)
              : _FirebaseSetupCard(strings: s, error: firebaseStatus.error),
          if (isAdmin) ...[
            const SizedBox(height: 12),
            _AdminPanelCard(email: email ?? 'admin'),
          ],
          const SizedBox(height: 12),
          _FeatureGrid(strings: s),
          const SizedBox(height: 12),
          _SettingsCard(
            strings: s,
            loading: _loadingSettings,
            notifications: _notifications,
            currency: _currency,
            onNotificationsChanged: (v) async {
              setState(() => _notifications = v);
              await _saveSettings();
            },
            onCurrencyChanged: (v) async {
              if (v == null) return;
              setState(() => _currency = v);
              await _saveSettings();
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}


class _AdminPanelCard extends StatelessWidget {
  const _AdminPanelCard({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.push('/admin'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.accent, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.admin_panel_settings_outlined,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Admin Panel',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Manage sneakers, prices, search and delete products • $email',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _GridItem {
  final IconData icon;
  final String label;
  final String? route;
  final Color color;
  final String? badge;
  final void Function(BuildContext)? onTap;

  const _GridItem({
    required this.icon,
    required this.label,
    this.route,
    required this.color,
    this.badge,
    this.onTap,
  });
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.strings});
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.divider;

    final items = [
      _GridItem(
        icon: Icons.favorite_border,
        label: strings.wishlistLabel,
        route: '/wishlist',
        color: AppColors.accent,
        badge: 'Local',
      ),
      _GridItem(
        icon: Icons.local_shipping_outlined,
        label: strings.ordersLabel,
        route: '/order-history',
        color: AppColors.pixelOrange,
        badge: 'History',
      ),
      _GridItem(
        icon: Icons.compare_arrows,
        label: strings.compareLabel,
        route: '/compare',
        color: AppColors.pixelPurple,
      ),
      _GridItem(
        icon: Icons.wifi,
        label: strings.networkLabel,
        route: '/network',
        color: AppColors.pixelCyan,
        badge: 'Status',
      ),
      _GridItem(
        icon: Icons.stream,
        label: strings.streamsLabel,
        route: '/streams-demo',
        color: AppColors.pixelYellow,
      ),
      _GridItem(
        icon: Icons.cloud_outlined,
        label: strings.cloudfavLabel,
        route: '/favourites',
        color: AppColors.pixelCyan,
        badge: 'Cloud',
      ),
      _GridItem(
        icon: Icons.chat_bubble_outline,
        label: strings.reviewsLabel,
        route: null,
        onTap: (ctx) => ctx.go('/catalog'),
        color: AppColors.accent,
        badge: 'Catalog',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        color: isDark ? AppColors.darkCard : AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
            child: Text(
              'Account',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  _FeatureRow(item: items[i]),
                  if (i != items.length - 1)
                    Divider(height: 1, color: borderColor),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.item});
  final _GridItem item;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (item.onTap != null) {
          item.onTap!(context);
        } else if (item.route != null) {
          context.push(item.route!);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.color, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.textDark,
                ),
              ),
            ),
            if (item.badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.badge!,
                  style: TextStyle(
                    color: item.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.darkTextGrey : AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}

class _FirebaseSetupCard extends StatelessWidget {
  const _FirebaseSetupCard({required this.strings, this.error});
  final AppStrings strings;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.textDark,
        ),
        borderRadius: BorderRadius.circular(18),
        color: isDark ? AppColors.darkCard : AppColors.cardBg,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.cloud_off, color: Colors.red, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              strings.firebaseNotReady,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FirebaseAccountCard extends ConsumerStatefulWidget {
  const _FirebaseAccountCard({required this.strings});
  final AppStrings strings;

  @override
  ConsumerState<_FirebaseAccountCard> createState() =>
      _FirebaseAccountCardState();
}

enum _AuthView { login, register }

class _FirebaseAccountCardState extends ConsumerState<_FirebaseAccountCard> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  _AuthView _view = _AuthView.login;
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    final userDao = ref.read(userDaoProvider);
    final isLogin = _view == _AuthView.login;
    final error = isLogin
        ? await userDao.login(_emailCtrl.text.trim(), _passwordCtrl.text)
        : await userDao.signup(_emailCtrl.text.trim(), _passwordCtrl.text);
    if (mounted) setState(() => _loading = false);
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  void _back() {
    _emailCtrl.clear();
    _passwordCtrl.clear();
    setState(() => _view = _AuthView.login);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final userDao = ref.watch(userDaoProvider);
    final authState = ref.watch(authStateProvider);
    final isLoggedIn = authState.maybeWhen(
      data: (user) => user != null,
      orElse: () => userDao.isLoggedIn(),
    );
    final email = authState.maybeWhen(
      data: (user) => user?.email,
      orElse: () => userDao.email(),
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.divider;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(18),
        color: isDark ? AppColors.darkCard : AppColors.cardBg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
              children: [
                if (!isLoggedIn && _view == _AuthView.register) ...[
                  GestureDetector(
                    onTap: _back,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: AppColors.accent, size: 16),
                    ),
                  ),
                ],
                Expanded(
                  child: Text(
                    isLoggedIn
                        ? s.account
                        : _view == _AuthView.login
                            ? s.login
                            : s.signup,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: isLoggedIn
                ? Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          email ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => userDao.logout(),
                        child: Text(s.logout),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _emailCtrl,
                        decoration: InputDecoration(
                          labelText: s.email,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePass,
                        decoration: InputDecoration(
                          labelText: s.password,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePass
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () =>
                                setState(() => _obscurePass = !_obscurePass),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (_loading)
                        const Center(child: CircularProgressIndicator())
                      else ...[
                        ElevatedButton.icon(
                          onPressed: _submit,
                          icon: Icon(_view == _AuthView.login
                              ? Icons.login
                              : Icons.person_add_outlined),
                          label: Text(
                              _view == _AuthView.login ? s.login : s.signup),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _view == _AuthView.login
                                  ? 'Нет аккаунта? '
                                  : 'Уже есть аккаунт? ',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.darkTextGrey
                                    : AppColors.textGrey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() {
                                _view = _view == _AuthView.login
                                    ? _AuthView.register
                                    : _AuthView.login;
                              }),
                              child: Text(
                                _view == _AuthView.login ? s.signup : s.login,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.strings,
    required this.loading,
    required this.notifications,
    required this.currency,
    required this.onNotificationsChanged,
    required this.onCurrencyChanged,
  });

  final AppStrings strings;
  final bool loading;
  final bool notifications;
  final String currency;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<String?> onCurrencyChanged;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.divider;
    final s = strings;

    return Material(
      color: isDark ? AppColors.darkCard : AppColors.cardBg,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Text(
              s.settings,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _SettingRow(
                        label: s.themeMode,
                        child: Row(
                          children: [
                            _ThemeChip(
                              icon: Icons.light_mode_outlined,
                              selected: settings.themeMode == ThemeMode.light,
                              onTap: () =>
                                  settings.setThemeMode(ThemeMode.light),
                            ),
                            const SizedBox(width: 6),
                            _ThemeChip(
                              icon: Icons.dark_mode_outlined,
                              selected: settings.themeMode == ThemeMode.dark,
                              onTap: () =>
                                  settings.setThemeMode(ThemeMode.dark),
                            ),
                            const SizedBox(width: 6),
                            _ThemeChip(
                              icon: Icons.settings_suggest_outlined,
                              selected: settings.themeMode == ThemeMode.system,
                              onTap: () =>
                                  settings.setThemeMode(ThemeMode.system),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SettingRow(
                        label: s.language,
                        child: Row(
                          children: AppLocale.values.map((locale) {
                            final selected = settings.locale == locale;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: GestureDetector(
                                onTap: () => settings.setLocale(locale),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.accent
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.accent
                                          : borderColor,
                                    ),
                                  ),
                                  child: Text(
                                    '${locale.flag} ${locale.code.toUpperCase()}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: selected
                                          ? Colors.white
                                          : (isDark
                                              ? AppColors.darkText
                                              : AppColors.textDark),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SettingRow(
                        label: s.currency,
                        child: DropdownButton<String>(
                          value: currency,
                          isDense: true,
                          underline: const SizedBox(),
                          items: const ['USD', 'EUR', 'KZT']
                              .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ))
                              .toList(),
                          onChanged: onCurrencyChanged,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        secondary: Icon(Icons.notifications_none,
                            color: isDark
                                ? AppColors.darkTextGrey
                                : AppColors.textGrey),
                        title: Text(
                          s.notifications,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: notifications,
                        onChanged: onNotificationsChanged,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textGrey,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 36,
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : Colors.transparent,
          border: Border.all(
            color: selected
                ? AppColors.accent
                : (isDark ? AppColors.darkBorder : AppColors.textDark),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: selected
              ? Colors.white
              : (isDark ? AppColors.darkTextGrey : AppColors.textGrey),
        ),
      ),
    );
  }
}
