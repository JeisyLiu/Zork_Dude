import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zork_dude/data/save_repository.dart';
import 'package:zork_dude/main.dart';
import 'package:zork_dude/services/audio/game_audio_service.dart';

import 'test_l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    GameAudioService.disableForTest = true;
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpUntilLoaded(WidgetTester tester) async {
    await tester.pump();
    for (var i = 0; i < 80; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.textContaining('进入迷雾').evaluate().isNotEmpty) return;
    }
  }

  testWidgets('fresh start keeps single enter button during transition', (
    tester,
  ) async {
    useTestLocaleZhHans(tester);
    await tester.binding.setSurfaceSize(const Size(1280, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MistTowerApp(),
      ),
    );
    await pumpUntilLoaded(tester);

    expect(find.text('继续旅程'), findsNothing);
    expect(find.text('进入迷雾'), findsOneWidget);

    await tester.tap(find.text('进入迷雾'));
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('继续旅程'), findsNothing);
    }
  });
}
