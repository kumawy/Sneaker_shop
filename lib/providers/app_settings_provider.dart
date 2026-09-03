import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
enum AppLocale { en, ru, kz }

extension AppLocaleExt on AppLocale {
  String get label {
    switch (this) {
      case AppLocale.en:
        return 'English';
      case AppLocale.ru:
        return 'Русский';
      case AppLocale.kz:
        return 'Қазақша';
    }
  }

  String get flag {
    switch (this) {
      case AppLocale.en:
        return '🇬🇧';
      case AppLocale.ru:
        return '🇷🇺';
      case AppLocale.kz:
        return '🇰🇿';
    }
  }

  String get code {
    switch (this) {
      case AppLocale.en:
        return 'en';
      case AppLocale.ru:
        return 'ru';
      case AppLocale.kz:
        return 'kz';
    }
  }
}
class AppStrings {
  final AppLocale locale;
  const AppStrings(this.locale);

  // Nav
  String get home => _s('Home', 'Главная', 'Басты');
  String get catalog => _s('Catalog', 'Каталог', 'Каталог');
  String get cart => _s('Cart', 'Корзина', 'Себет');
  String get favourites => _s('Favourites', 'Избранное', 'Таңдаулы');
  String get profile => _s('Profile', 'Профиль', 'Профиль');

  // Home
  String get heroTitle =>
      _s('Step into\nStyle 👟', 'Войди в\nСтиль 👟', 'Стилге\nқадам 👟');
  String get heroSubtitle => _s('Find your perfect pair today',
      'Найди свою пару сегодня', 'Бүгін өз жұбыңды тап');
  String get shopNow => _s('Shop Now', 'В магазин', 'Сатып алу');
  String get featured => _s('Featured', 'Рекомендуем', 'Ұсынылады');
  String get seeAll => _s('See all', 'Все', 'Барлығы');
  String get brands => _s('Brands', 'Бренды', 'Брендтер');
  String get allSneakers =>
      _s('All Sneakers', 'Все кроссовки', 'Барлық кроссовкалар');

  // Catalog
  String get search => _s('Search', 'Поиск', 'Іздеу');
  String get allBrands => _s('All', 'Все', 'Барлығы');
  String get sortBy => _s('Sort', 'Сортировка', 'Сұрыптау');
  String get noResults =>
      _s('No sneakers found', 'Кроссовки не найдены', 'Кроссовка табылмады');

  // Detail
  String get addToCart => _s('Add to Cart', 'В корзину', 'Себетке');
  String get localWishlist => _s('Wishlist', 'Закладки', 'Тізім');
  String get cloudFav => _s('Save to Cloud', 'В облако', 'Бұлутқа');
  String get removeFav =>
      _s('Remove from Cloud', 'Убрать из облака', 'Бұлуттан алу');
  String get viewReviews => _s('Reviews', 'Отзывы', 'Пікірлер');
  String get selectSizeColor => _s('Please select size and color',
      'Выберите размер и цвет', 'Өлшем мен түсін таңдаңыз');
  String get youMightAlsoLike =>
      _s('You might also like', 'Вам может понравиться', 'Сізге ұнауы мүмкін');
  String get size => _s('Size', 'Размер', 'Өлшем');
  String get color => _s('Color', 'Цвет', 'Түс');

  // Cart
  String get myCart => _s('My Cart', 'Корзина', 'Себет');
  String get clearCart => _s('Clear', 'Очистить', 'Тазалау');
  String get cartEmpty =>
      _s('Your cart is empty', 'Корзина пуста', 'Себет бос');
  String get checkout => _s('Checkout', 'Оформить заказ', 'Тапсырыс беру');
  String get total => _s('Total', 'Итого', 'Жиыны');

  // Profile
  String get profileTitle => _s('Profile', 'Профиль', 'Профиль');
  String get account => _s('Account', 'Аккаунт', 'Аккаунт');
  String get settings => _s('Settings', 'Настройки', 'Баптаулар');
  String get notifications =>
      _s('Notifications', 'Уведомления', 'Хабарламалар');
  String get currency => _s('Currency', 'Валюта', 'Валюта');
  String get language => _s('Language', 'Язык', 'Тіл');
  String get themeMode => _s('Theme', 'Тема', 'Тақырып');
  String get darkMode => _s('Dark mode', 'Тёмная тема', 'Қараңғы тақырып');
  String get lightMode => _s('Light mode', 'Светлая тема', 'Жарық тақырып');
  String get logout => _s('Logout', 'Выход', 'Шығу');
  String get login => _s('Log In', 'Войти', 'Кіру');
  String get signup => _s('Sign Up', 'Регистрация', 'Тіркелу');
  String get email => _s('Email', 'Email', 'Email');
  String get password => _s('Password', 'Пароль', 'Құпия сөз');

  // Feature grid labels
  String get wishlistLabel => _s('Wishlist', 'Закладки', 'Тізім');
  String get ordersLabel => _s('Orders', 'Заказы', 'Тапсырыстар');
  String get compareLabel => _s('Compare', 'Сравнение', 'Салыстыру');
  String get bookmarksLabel =>
      _s('Bookmarks', 'Закладки\n(stream)', 'Бетбелгілер');
  String get networkLabel => _s('Network', 'Сеть', 'Желі');
  String get streamsLabel => _s('Streams', 'Потоки', 'Ағындар');
  String get deepLinkLabel => _s('Deep Links', 'Диплинки', 'Терең сілтемелер');
  String get cloudfavLabel => _s('Cloud Favs', 'Облако', 'Бұлут');
  String get reviewsLabel => _s('Reviews', 'Отзывы', 'Пікірлер');

  // Order
  String get orderSuccess =>
      _s('Order Placed! 🎉', 'Заказ оформлен! 🎉', 'Тапсырыс берілді! 🎉');
  String get orderOnWay => _s('Your sneakers are on the way.',
      'Ваши кроссовки уже в пути.', 'Кроссовкаларыңыз жолда.');
  String get viewHistory =>
      _s('View Order History', 'История заказов', 'Тапсырыстар тарихы');
  String get backHome => _s('Back to Home', 'На главную', 'Басты бетке');
  String get continueShopping =>
      _s('Continue Shopping', 'Продолжить покупки', 'Сатып алуды жалғастыру');

  // Wishlist
  String get wishlistTitle => _s(
      'Wishlist (SQLite)', 'Список желаний (SQLite)', 'Тілек тізімі (SQLite)');
  String get emptyWishlist =>
      _s('Wishlist is empty', 'Список желаний пуст', 'Тілек тізімі бос');

  // Reviews
  String get writeReview =>
      _s('Write a Review', 'Написать отзыв', 'Пікір жазу');
  String get noReviews => _s('No reviews yet', 'Нет отзывов', 'Пікірлер жоқ');

  // 404
  String get notFound =>
      _s('Page Not Found', 'Страница не найдена', 'Бет табылмады');
  String get goHome => _s('Go to Home', 'На главную', 'Басты бетке');
  String get goBack => _s('Go back', 'Назад', 'Артқа');

  // Firebase
  String get firebaseNotReady => _s('Firebase not configured',
      'Firebase не настроен', 'Firebase бапталмаған');
  String get signInRequired => _s('Sign in to save cloud favourites',
      'Войдите для сохранения в облако', 'Бұлутқа сақтау үшін кіріңіз');

  String _s(String en, String ru, String kz) {
    switch (locale) {
      case AppLocale.en:
        return en;
      case AppLocale.ru:
        return ru;
      case AppLocale.kz:
        return kz;
    }
  }
}
class AppSettingsProvider extends ChangeNotifier {
  AppLocale _locale = AppLocale.en;
  ThemeMode _themeMode = ThemeMode.system;

  AppLocale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  AppStrings get strings => AppStrings(_locale);

  bool get isDark {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    // system — fallback light
    return false;
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final locCode = prefs.getString('app_locale') ?? 'en';
    final themeCode = prefs.getString('app_theme') ?? 'system';
    _locale = AppLocale.values.firstWhere(
      (l) => l.code == locCode,
      orElse: () => AppLocale.en,
    );
    _themeMode = themeCode == 'dark'
        ? ThemeMode.dark
        : themeCode == 'light'
            ? ThemeMode.light
            : ThemeMode.system;
    notifyListeners();
  }

  Future<void> setLocale(AppLocale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', locale.code);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    final code = mode == ThemeMode.dark
        ? 'dark'
        : mode == ThemeMode.light
            ? 'light'
            : 'system';
    await prefs.setString('app_theme', code);
    notifyListeners();
  }
}
