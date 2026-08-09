import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/l10n/app_localizations.dart';
import 'package:zork_dude/l10n/locale_tag.dart';
import 'package:zork_dude/services/audio/game_audio_service.dart';
import 'package:zork_dude/services/locale_preferences.dart';
import 'package:zork_dude/services/offpack_ads.dart';
import 'package:zork_dude/services/play_games/play_games_service.dart';
import 'package:zork_dude/screens/home_screen.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GameAudioService.disableForTest = false;
  await GameAudioService.instance.initialize();
  await LocalePreferences.instance.load(
    systemLocales: WidgetsBinding.instance.platformDispatcher.locales,
  );

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

class MistTowerApp extends StatefulWidget {
  const MistTowerApp({super.key});

  @override
  State<MistTowerApp> createState() => _MistTowerAppState();
}

class _MistTowerAppState extends State<MistTowerApp> {
  final _localePrefs = LocalePreferences.instance;

  @override
  void initState() {
    super.initState();
    _localePrefs.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    _localePrefs.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final locale = _localePrefs.effectiveLocale;
    return MaterialApp(
      key: _localePrefs.appKey,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: GameUiTheme.appTheme(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: LocaleTag.supportedMaterialLocales,
      localeListResolutionCallback: (locales, supported) => locale,
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
