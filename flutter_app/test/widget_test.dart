import 'package:flutter_test/flutter_test.dart';
import 'package:zork_dude/main.dart';

void main() {
  testWidgets('Home screen shows Mist Tower title', (tester) async {
    await tester.pumpWidget(const MistTowerApp());
    expect(find.text('迷雾之塔'), findsOneWidget);

    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.textContaining('进入迷雾').evaluate().isNotEmpty) break;
    }
    expect(find.textContaining('进入迷雾'), findsOneWidget);
  });
}
