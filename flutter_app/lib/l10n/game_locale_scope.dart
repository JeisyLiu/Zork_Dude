import 'package:flutter/widgets.dart';
import 'package:zork_dude/l10n/locale_tag.dart';

/// Resolves and stores the active game locale for world data + [GameMessages].
abstract final class GameLocaleScope {
  static String _tag = LocaleTag.zhHans;

  static String get tag => _tag;

  static void setFromLocale(Locale locale) {
    _tag = LocaleTag.fromLocale(locale);
  }

  static void setTag(String tag) {
    if (LocaleTag.all.contains(tag)) {
      _tag = tag;
    }
  }
}
