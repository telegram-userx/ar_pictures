import 'package:gozel_ay/generated/strings.g.dart';

extension AppLocaleX on AppLocale {
  getName() {
    switch (this) {
      case AppLocale.ru:
        return 'ru';
      case AppLocale.tk:
        return 'tm';
      case AppLocale.en:
        return 'en';
      default:
        return '';
    }
  }
}
