import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zork_dude/services/audio/audio_preferences.dart';
import 'package:zork_dude/services/audio/game_audio_service.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/settings/settings_overlay.dart';

import 'test_l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    GameAudioService.disableForTest = true;
    SharedPreferences.setMockInitialValues({});
    AudioPreferences.instance.resetForTest();
  });

  testWidgets('Settings gear opens overlay with audio toggles', (tester) async {
    useTestLocaleZhHans(tester);
    const size = Size(1280, 720);
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      materialAppWithL10n(
        theme: GameUiTheme.appTheme(),
        home: MediaQuery(
          data: const MediaQueryData(size: size, disableAnimations: true),
          child: const GameSkinScope(
            skin: GameUiSkin.fantasy,
            child: Scaffold(
              body: Center(child: SettingsGearButton()),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.bySemanticsLabel('设置'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(tester.takeException(), isNull);
    expect(find.byKey(LandscapeOverlay.panelKey), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
    expect(find.text('背景音乐'), findsOneWidget);
    expect(find.text('音效'), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(2));
    expect(find.byType(Slider), findsNothing);
  });

  testWidgets('SettingsEntry.open shows panel', (tester) async {
    useTestLocaleZhHans(tester);
    const size = Size(667, 375);
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      materialAppWithL10n(
        theme: GameUiTheme.appTheme(),
        home: MediaQuery(
          data: const MediaQueryData(size: size, disableAnimations: true),
          child: GameSkinScope(
            skin: GameUiSkin.fantasy,
            child: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => SettingsEntry.open(context),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('open'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(tester.takeException(), isNull);
    expect(find.byKey(LandscapeOverlay.panelKey), findsOneWidget);
    expect(find.textContaining('系统音量'), findsOneWidget);
  });
}
