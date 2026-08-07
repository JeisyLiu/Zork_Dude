import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_confirm_dialog.dart';
import 'package:zork_dude/ui/components/landscape_overlay.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('GameConfirmDialog uses game panel not AlertDialog', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 720));
    await tester.pumpWidget(
      MaterialApp(
        theme: GameUiTheme.appTheme(),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: GameButton(
                label: 'open',
                onPressed: () {
                  GameConfirmDialog.show(
                    context: context,
                    title: '开始新旅程？',
                    message: '已有存档进度。开始新游戏将覆盖当前存档，是否继续？',
                    confirmLabel: '覆盖并开始',
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

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byKey(LandscapeOverlay.panelKey), findsOneWidget);
    expect(find.textContaining('覆盖当前存档'), findsOneWidget);
    expect(find.text('覆盖并开始'), findsOneWidget);

    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(find.byKey(LandscapeOverlay.panelKey), findsNothing);
  });
}
