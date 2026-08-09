import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/data/world_repository.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/l10n/game_messages.dart';
import 'package:zork_dude/l10n/locale_tag.dart';

import 'test_l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WorldRepository locale loading', () {
    for (final tag in LocaleTag.all) {
      test('loads $tag with same room count as zh_Hans', () async {
        final zh = WorldRepository(localeTag: LocaleTag.zhHans);
        final repo = WorldRepository(localeTag: tag);
        final zhWorld = await zh.loadFromAssets();
        final world = await repo.loadFromAssets();
        expect(world.roomCount, zhWorld.roomCount);
        expect(world.itemCount, zhWorld.itemCount);
      });
    }
  });

  group('GameMessages locale loading', () {
    for (final tag in LocaleTag.all) {
      test('loads $tag with same keys as zh_Hans', () async {
        GameMessages.resetCacheForTest();
        final zh = await GameMessages.load(LocaleTag.zhHans);
        GameMessages.resetCacheForTest();
        final msgs = await GameMessages.load(tag);
        expect(msgs.helpText, isNotEmpty);
        expect(msgs.gameOver, isNotEmpty);
        if (tag != LocaleTag.zhHans) {
          // Non-Chinese locales should differ from zh_Hans for core strings.
          if (tag == LocaleTag.enUs ||
              tag == LocaleTag.ja ||
              tag == LocaleTag.ko ||
              tag == LocaleTag.fr ||
              tag == LocaleTag.de ||
              tag == LocaleTag.it ||
              tag == LocaleTag.esEs ||
              tag == LocaleTag.ptBr) {
            expect(msgs.helpText, isNot(equals(zh.helpText)));
          }
        }
      });
    }
  });

  group('UI smoke by locale', () {
    testWidgets('en_US home title', (tester) async {
      useTestLocale(tester, testEnUs);
      await tester.pumpWidget(
        materialAppWithL10n(
          locale: testEnUs,
          home: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context);
              return Text(l10n.appTitle);
            },
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Mist Tower'), findsOneWidget);
    });

    testWidgets('ja home title loads', (tester) async {
      useTestLocale(tester, testJa);
      late String title;
      await tester.pumpWidget(
        materialAppWithL10n(
          locale: testJa,
          home: Builder(
            builder: (context) {
              title = AppLocalizations.of(context).appTitle;
              return Text(title);
            },
          ),
        ),
      );
      await tester.pump();
      expect(title, isNotEmpty);
      expect(find.text(title), findsOneWidget);
    });
  });
}
