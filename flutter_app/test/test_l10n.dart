import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/l10n/locale_tag.dart';

const testZhHans = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
const testZhHant = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
const testEnUs = Locale.fromSubtags(languageCode: 'en', countryCode: 'US');
const testJa = const Locale('ja');
const testKo = const Locale('ko');
const testFr = const Locale('fr');
const testDe = const Locale('de');
const testIt = const Locale('it');
const testEsEs = Locale.fromSubtags(languageCode: 'es', countryCode: 'ES');
const testPtBr = Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR');

/// All supported locales for widget tests.
const testSupportedLocales = LocaleTag.supportedMaterialLocales;

/// Force a specific locale for widget tests.
void useTestLocale(WidgetTester tester, Locale locale) {
  tester.platformDispatcher.localeTestValue = locale;
  tester.platformDispatcher.localesTestValue = [locale];
  addTearDown(() {
    tester.platformDispatcher.clearLocaleTestValue();
    tester.platformDispatcher.clearLocalesTestValue();
  });
}

/// Force BCP 47 zh-Hans for widget tests that assert Chinese copy.
void useTestLocaleZhHans(WidgetTester tester) {
  useTestLocale(tester, testZhHans);
}

/// MaterialApp wrapper with gen-l10n delegates (for overlays / panels).
Widget materialAppWithL10n({
  required Widget home,
  ThemeData? theme,
  Locale locale = testZhHans,
}) {
  return MaterialApp(
    theme: theme,
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: testSupportedLocales,
    home: home,
  );
}
