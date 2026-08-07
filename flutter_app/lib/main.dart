import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/services/offpack_ads.dart';
import 'package:zork_dude/screens/home_screen.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  unawaited(OffpackAds.instance.initialize());

  runApp(const MistTowerApp());
}

class MistTowerApp extends StatelessWidget {
  const MistTowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '迷雾之塔',
      debugShowCheckedModeBanner: false,
      theme: GameUiTheme.appTheme(),
      // Phones often enable OS "remove animations" / animator scale 0x, which
      // sets MediaQuery.disableAnimations and skips all game cinematics.
      // Force motion on so mobile matches the Windows play feel.
      builder: (context, child) {
        final page = child ?? const SizedBox.shrink();
        final mq = MediaQuery.of(context);
        if (!mq.disableAnimations) return page;
        return MediaQuery(
          data: mq.copyWith(disableAnimations: false),
          child: page,
        );
      },
      home: const HomeScreen(),
    );
  }
}
