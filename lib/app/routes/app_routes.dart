part of 'app_pages.dart';

abstract class Routes {
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot_password';
  static const PHONE_VERIFICATION = '/phone_verification';

  static const ROOT = '/root';
  static const RATING = '/rating';
  static const CHAT = '/chat';

  static const SETTINGS = '/settings';
  static const SETTINGS_THEME_MODE = '/settings/theme_mode';
  static const SETTINGS_LANGUAGE = '/settings/language';
  static const SETTINGS_ADDRESSES = '/settings/addresses';

  static const PROFILE = '/profile';
  static const CATEGORY = '/category';
  static const CATEGORIES = '/categories';
  static const E_SERVICE = '/e-service';
  static const BOOK_E_SERVICE = '/book-e-service';
  static const CHECKOUT = '/checkout';
  static const CONFIRMATION = '/confirmation';
  static const SEARCH = '/search';
  static const NOTIFICATIONS = '/notifications';
  static const FAVORITES = '/favorites';
  static const HELP = '/help';
  static const PRIVACY = '/privacy';
  static const E_PROVIDER = '/e-provider';
  static const E_PROVIDER_E_SERVICES = '/e-provider/e-services';
  static const BOOKING = '/booking';
  static const PAYPAL = '/paypal';
  static const CASH = '/cash';
  static const CUSTOM_PAGES = '/custom-pages';
  static const GALLERY = '/gallery';
}
