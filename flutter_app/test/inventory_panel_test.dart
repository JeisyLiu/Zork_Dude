import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/exploration/inventory_panel.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GameController controller;

  setUp(() async {
    controller = GameController();
    await controller.init();
  });

  tearDown(() => controller.dispose());

  Future<void> openPanel(
    WidgetTester tester, {
    InventoryPanelMode mode = InventoryPanelMode.all,
  }) async {
    const size = Size(1280, 720);
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: GameUiTheme.appTheme(),
        home: MediaQuery(
          data: const MediaQueryData(size: size, disableAnimations: true),
          child: GameSkinScope(
            skin: GameUiSkin.fantasy,
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Center(
                    child: ElevatedButton(
                      key: const Key('open-inv'),
                      onPressed: () => InventoryPanel.show(
                        context: context,
                        controller: controller,
                        mode: mode,
                      ),
                      child: const Text('open'),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('open-inv')));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('Bag opens list then item detail with use/drop', (tester) async {
    expect(controller.session!.inventory, isNotEmpty);
    await openPanel(tester);

    expect(find.byKey(LandscapeOverlay.panelKey), findsOneWidget);
    expect(find.byKey(const Key('inventory-list')), findsOneWidget);

    final itemBtn = find.descendant(
      of: find.byKey(const Key('inventory-list')),
      matching: find.byType(GameButton),
    );
    expect(itemBtn, findsWidgets);
    await tester.tap(itemBtn.first);
    await tester.pump();
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.byKey(const Key('inventory-action-back')), findsOneWidget);
    expect(
      find.byKey(const Key('inventory-action-use')).evaluate().isNotEmpty ||
          find.byKey(const Key('inventory-action-drop')).evaluate().isNotEmpty,
      isTrue,
    );

    await tester.tap(find.byKey(const Key('inventory-action-back')));
    await tester.pump();
    expect(find.byKey(const Key('inventory-list')), findsOneWidget);
  });

  testWidgets('Use mode opens filtered inventory title', (tester) async {
    await openPanel(tester, mode: InventoryPanelMode.usable);
    expect(find.byKey(LandscapeOverlay.panelKey), findsOneWidget);
    expect(find.textContaining('使用道具'), findsWidgets);
  });
}
