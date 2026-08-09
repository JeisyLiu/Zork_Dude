import 'package:flutter/widgets.dart';

/// BCP 47 locale tags used for world data and [GameMessages].
abstract final class LocaleTag {
  static const zhHans = 'zh_Hans';
  static const zhHant = 'zh_Hant';
  static const enUs = 'en_US';
  static const ja = 'ja';
  static const ko = 'ko';
  static const fr = 'fr';
  static const de = 'de';
  static const it = 'it';
  static const esEs = 'es_ES';
  static const ptBr = 'pt_BR';

  static const all = [
    zhHans,
    zhHant,
    enUs,
    ja,
    ko,
    fr,
    de,
    it,
    esEs,
    ptBr,
  ];

  static const supportedMaterialLocales = [
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
    Locale('ja'),
    Locale('ko'),
    Locale('fr'),
    Locale('de'),
    Locale('it'),
    Locale.fromSubtags(languageCode: 'es', countryCode: 'ES'),
    Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
  ];

  /// Resolve a [Locale] to our asset/message tag.
  static String fromLocale(Locale? locale) {
    if (locale == null) return zhHans;
    final lang = locale.languageCode.toLowerCase();
    if (lang == 'zh') {
      final script = locale.scriptCode?.toLowerCase();
      final country = locale.countryCode?.toUpperCase();
      if (script == 'hant' ||
          country == 'TW' ||
          country == 'HK' ||
          country == 'MO') {
        return zhHant;
      }
      return zhHans;
    }
    if (lang == 'en') return enUs;
    if (lang == 'ja') return ja;
    if (lang == 'ko') return ko;
    if (lang == 'fr') return fr;
    if (lang == 'de') return de;
    if (lang == 'it') return it;
    if (lang == 'es') return esEs;
    if (lang == 'pt') return ptBr;
    return zhHans;
  }

  /// Pick the best tag from the OS locale list.
  static String resolve(Iterable<Locale>? locales) {
    for (final locale in locales ?? const <Locale>[]) {
      final tag = fromLocale(locale);
      if (all.contains(tag)) return tag;
    }
    return zhHans;
  }
}
