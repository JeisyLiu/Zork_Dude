import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zork_dude/l10n/game_messages.dart';
import 'package:zork_dude/l10n/locale_tag.dart';

/// Persisted in-app language preference (overrides OS locale for UI + world data).
class LocalePreferences extends ChangeNotifier {
  LocalePreferences._();

  static final LocalePreferences instance = LocalePreferences._();

  static const _keyLocaleTag = 'app.locale_tag';

  static const displayNames = <String, String>{
    LocaleTag.zhHans: '简体中文',
    LocaleTag.zhHant: '繁體中文',
    LocaleTag.enUs: 'English',
    LocaleTag.ja: '日本語',
    LocaleTag.ko: '한국어',
    LocaleTag.fr: 'Français',
    LocaleTag.de: 'Deutsch',
    LocaleTag.it: 'Italiano',
    LocaleTag.esEs: 'Español',
    LocaleTag.ptBr: 'Português (Brasil)',
  };

  String? _persistedTag;
  String? _sessionTag;
  bool _loaded = false;
  Key _appKey = UniqueKey();

  bool get loaded => _loaded;
  Key get appKey => _appKey;

  String get effectiveTag => _sessionTag ?? _persistedTag ?? LocaleTag.zhHans;

  Locale get effectiveLocale => _localeForTag(effectiveTag);

  static Locale _localeForTag(String tag) {
    for (final locale in LocaleTag.supportedMaterialLocales) {
      if (LocaleTag.fromLocale(locale) == tag) return locale;
    }
    return LocaleTag.supportedMaterialLocales.first;
  }

  Future<void> load({Iterable<Locale>? systemLocales}) async {
    if (_loaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_keyLocaleTag);
      if (stored != null && LocaleTag.all.contains(stored)) {
        _persistedTag = stored;
        _sessionTag = stored;
      } else {
        _sessionTag = LocaleTag.resolve(systemLocales);
      }
    } catch (_) {
      _sessionTag = LocaleTag.zhHans;
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> setTag(String tag) async {
    if (!LocaleTag.all.contains(tag)) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocaleTag, tag);
    _persistedTag = tag;
    _sessionTag = tag;
    notifyListeners();
  }

  /// Rebuild the app tree and clear narrative caches after a language change.
  void softRelaunch() {
    GameMessages.clearCache();
    _appKey = UniqueKey();
    notifyListeners();
  }

  @visibleForTesting
  void resetForTest({String tag = LocaleTag.zhHans}) {
    _persistedTag = null;
    _sessionTag = tag;
    _loaded = false;
    _appKey = UniqueKey();
  }
}
