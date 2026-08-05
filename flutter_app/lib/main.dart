import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/screens/home_screen.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

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
      home: const HomeScreen(),
    );
  }
}
