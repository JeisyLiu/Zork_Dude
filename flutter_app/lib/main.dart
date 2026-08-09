import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/services/offpack_ads.dart';
import 'package:zork_dude/services/play_games/play_games_service.dart';
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
  unawaited(PlayGamesService.instance.initialize());

  runApp(const MistTowerApp());
}

class MistTowerApp extends StatelessWidget {
  const MistTowerApp({super.key});

  static const _zhHans = Locale.fromSubtags(
    languageCode: 'zh',
    scriptCode: 'Hans',
  );
  static const _zhHant = Locale.fromSubtags(
    languageCode: 'zh',
    scriptCode: 'Hant',
  );
  static const _enUs = Locale.fromSubtags(
    languageCode: 'en',
    countryCode: 'US',
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: GameUiTheme.appTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [_zhHans, _zhHant, _enUs],
      localeListResolutionCallback: (locales, supported) {
        for (final locale in locales ?? const <Locale>[]) {
          if (locale.languageCode == 'zh') {
            final script = locale.scriptCode?.toLowerCase();
            final country = locale.countryCode?.toUpperCase();
            if (script == 'hant' ||
                country == 'TW' ||
                country == 'HK' ||
                country == 'MO') {
              return _zhHant;
            }
            return _zhHans;
          }
          if (locale.languageCode == 'en') {
            return _enUs;
          }
        }
        return _zhHans;
      },
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
