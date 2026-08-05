import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/navigation/landscape_page_route.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Command throttle', () {
    test('rapid executeCommand calls are throttled', () async {
      final controller = GameController();
      await controller.init();

      await controller.executeCommand('look');
      await controller.executeCommand('look');
      await controller.executeCommand('look');

      final lookCommands = controller.log
          .where((e) => e.isCommand && e.text.toLowerCase().contains('look'))
          .length;
      expect(lookCommands, 1);
      controller.dispose();
    });

    test('toggleMap ignores rapid repeats', () async {
      final controller = GameController();
      await controller.init();
      final initial = controller.mapVisible;

      controller.toggleMap();
      controller.toggleMap();
      controller.toggleMap();

      expect(controller.mapVisible, !initial);
      controller.dispose();
    });

    test('sequential different commands after throttle window', () async {
      final controller = GameController();
      await controller.init();

      await controller.executeCommand('look');
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await controller.executeCommand('help');

      expect(
        controller.log.any((e) => e.isCommand && e.text.toLowerCase().contains('help')),
        isTrue,
      );
      controller.dispose();
    });
  });

  group('LandscapePageRoute', () {
    testWidgets('disableAnimations yields zero transition duration', (tester) async {
      late PageRoute<void> route;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Builder(
              builder: (context) {
                route = LandscapePageRoute.of<void>(
                  context,
                  const SizedBox.shrink(),
                ) as PageRoute<void>;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(route.transitionDuration, Duration.zero);
      expect(route.reverseTransitionDuration, Duration.zero);
    });

    testWidgets('animated route uses 250ms transition', (tester) async {
      late PageRoute<void> route;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              route = LandscapePageRoute.of<void>(
                context,
                const SizedBox.shrink(),
              ) as PageRoute<void>;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(route.transitionDuration, const Duration(milliseconds: 250));
    });
  });
}
