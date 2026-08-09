import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zork_dude/l10n/locale_tag.dart';
import 'package:zork_dude/services/locale_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    LocalePreferences.instance.resetForTest();
  });

  test('load uses system locale when no preference stored', () async {
    await LocalePreferences.instance.load(
      systemLocales: const [Locale('en', 'US')],
    );
    expect(LocalePreferences.instance.effectiveTag, LocaleTag.enUs);
  });

  test('setTag persists and updates effective tag', () async {
    await LocalePreferences.instance.load();
    await LocalePreferences.instance.setTag(LocaleTag.ja);
    expect(LocalePreferences.instance.effectiveTag, LocaleTag.ja);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('app.locale_tag'), LocaleTag.ja);
  });

  test('softRelaunch rotates app key', () async {
    await LocalePreferences.instance.load();
    final before = LocalePreferences.instance.appKey;
    LocalePreferences.instance.softRelaunch();
    expect(LocalePreferences.instance.appKey, isNot(equals(before)));
  });
}
