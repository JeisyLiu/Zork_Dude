import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/data/save_repository.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/components/save_slot_picker.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

import 'test_l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('read mode disables empty slots and shows emoji stats', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 720));
    final slots = List<SaveSlotInfo?>.filled(8, null);
    slots[1] = SaveSlotInfo(
      slotIndex: 1,
      score: 88,
      playerHp: 30,
      playerMaxHp: 50,
      layersVisited: const ['surface', 'cave'],
      savedAt: DateTime.now().toUtc(),
    );

    await tester.pumpWidget(
      materialAppWithL10n(
        theme: GameUiTheme.appTheme(),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: GameButton(
                label: 'open',
                onPressed: () {
                  SaveSlotPicker.show(
                    context: context,
                    mode: SaveSlotPickerMode.read,
                    slots: slots,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byKey(LandscapeOverlay.panelKey), findsOneWidget);
    expect(find.textContaining('⭐88'), findsOneWidget);
    expect(find.textContaining('❤️30/50'), findsOneWidget);
    expect(find.textContaining('🌲'), findsOneWidget);
    expect(find.text('➕'), findsNWidgets(7));
  });
}
