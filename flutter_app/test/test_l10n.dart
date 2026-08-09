import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/l10n/app_localizations.dart';

const testZhHans = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');

/// Force BCP 47 zh-Hans for widget tests that assert Chinese copy.
void useTestLocaleZhHans(WidgetTester tester) {
  tester.platformDispatcher.localeTestValue = testZhHans;
  tester.platformDispatcher.localesTestValue = [testZhHans];
  addTearDown(() {
    tester.platformDispatcher.clearLocaleTestValue();
    tester.platformDispatcher.clearLocalesTestValue();
  });
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
    supportedLocales: const [
      testZhHans,
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
    ],
    home: home,
  );
}
