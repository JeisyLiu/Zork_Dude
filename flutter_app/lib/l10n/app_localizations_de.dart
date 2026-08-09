// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Turm der Nebel';

  @override
  String get appTitleEn => 'NEBELTURM';

  @override
  String get taglineShort =>
      'Erforsche, sammle, rede, kämpfe – finde die verlorene Wahrheit zurück.';

  @override
  String get taglineFull =>
      'Du erwachst aus einem nebligen Wald ohne Erinnerung.\nErforsche, sammle, rede, kämpfe – finde die verlorene Wahrheit zurück.';

  @override
  String get homeHint =>
      'Befehlige Erkundung · Nebelkarte · Begegne einem Feind und begib dich in eine Kampfrunde';

  @override
  String get loading => 'Laden…';

  @override
  String get continueJourney => 'Setzen Sie die Reise fort';

  @override
  String get enterMist => 'Betreten Sie den Nebel';

  @override
  String get achievements => 'Leistung';

  @override
  String get leaderboard => 'Rangliste';

  @override
  String get close => 'Schließung';

  @override
  String get cancel => 'Stornieren';

  @override
  String get confirm => 'bestätigen';

  @override
  String get skip => 'über etwas springen';

  @override
  String get continueAction => 'weitermachen';

  @override
  String get back => 'zurückkehren';

  @override
  String get menu => 'Speisekarte';

  @override
  String get startNewJourneyTitle => 'Eine neue Reise beginnen?';

  @override
  String get overwriteSaveMessage =>
      'In diesem Slot gibt es bereits Fortschritte. Wenn Sie ein neues Spiel starten, wird dieser Speicherstand überschrieben. Möchten Sie fortfahren?';

  @override
  String get overwriteAndStart => 'Abdecken und starten';

  @override
  String get connectPlayGamesTitle => 'Play-Spiele verbinden';

  @override
  String get connectPlayGamesMessage =>
      'Stellen Sie eine Verbindung zu Google Play Games her, um Erfolge und Bestenlisten anzuzeigen. Sie können normal spielen, ohne eine Verbindung herzustellen.';

  @override
  String get connectLater => 'Wir sprechen später';

  @override
  String get connectNow => 'Jetzt verbinden';

  @override
  String get returnToTitleTitle => 'Titel zurückgeben?';

  @override
  String get returnToTitleMessage =>
      'Der aktuelle Fortschritt wurde automatisch gespeichert und kann über die Titelseite „Reise fortsetzen“ wiederhergestellt werden.';

  @override
  String get returnToTitle => 'Titel zurückgeben';

  @override
  String get quitAppTitle => 'Das Spiel beenden?';

  @override
  String get quitAppMessage => 'Der Nebelturm bleibt geschlossen.';

  @override
  String get quit => 'aufhören';

  @override
  String get combatPauseTitle => 'Kampfmenü · Pause';

  @override
  String get resumeCombat => 'Kämpfe weiter';

  @override
  String get backToTitle => 'Zurück zum Titel';

  @override
  String get privacySettings => 'Datenschutzeinstellungen';

  @override
  String get privacySettingsHint => 'Datenschutzeinstellungen · Datenschutz';

  @override
  String get rewardOfferTitle => 'Geschenk des Nebels';

  @override
  String rewardOfferGold(int base, int doubled) {
    return 'Goldmünzen in diesem Spiel +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable =>
      'Geschenke sind vorübergehend nicht verfügbar, Sie können das Abenteuer direkt fortsetzen';

  @override
  String get rewardOfferWatch => 'Anzeigen ansehen · Doppelte Goldmünzen';

  @override
  String get rewardOfferLoading => 'Geschenke beschwören...';

  @override
  String get continueAdventure => 'Setzen Sie das Abenteuer fort';

  @override
  String get watchAd => 'Schauen Sie sich Werbung an';

  @override
  String get watchAdRecoverLoss => 'Anzeigen ansehen · Verluste ausgleichen';

  @override
  String refundScorePoints(int points) {
    return 'Gibt $points Punkte zurück';
  }

  @override
  String get summoningGlimmer => 'Beschwörung in der Dämmerung ...';

  @override
  String get glimmerNoResponse =>
      'Shimmer hat noch nicht geantwortet, bitte versuchen Sie es später noch einmal.';

  @override
  String get endingDragonTitle => 'Der junge Drache ist gefallen';

  @override
  String get endingDragonSubtitle =>
      'Der magische Edelstein fällt in deine Hände.\nEs kann nicht nur die Steintür vom Friedhof zum Unterschlupf öffnen, sondern auch verlorene Erinnerungen auf der Turmspitze wachrufen.';

  @override
  String get endingDragonPrimary => 'Setzen Sie das Abenteuer fort';

  @override
  String get endingDragonSecondary =>
      'Kehren Sie zurück, um die Reise abzuschließen';

  @override
  String get endingMainTitle => 'Der Nebel löst sich auf';

  @override
  String get endingMainSubtitle =>
      'Erinnerungen kamen ihm wieder in den Sinn und die Barriere des Turms stürzte ein.\nDu bist frei – aber tief in der Anstalt gibt es immer noch unerledigte Angelegenheiten.';

  @override
  String get endingMainPrimary => 'Entdecken Sie weiter';

  @override
  String get endingSiteTitle => 'Website-Aktion abgeschlossen';

  @override
  String get endingSiteSubtitle =>
      'Der endgültige Prototyp wurde unterdrückt und im Sicherheitsgewölbe herrschte Stille.\nEine lange Reise geht zu Ende.';

  @override
  String get endingSitePrimary => 'Mitarbeiterliste anzeigen';

  @override
  String get endingGameOverTitle => 'Du bist gefallen';

  @override
  String get endingGameOverSubtitle =>
      'Der Nebel verschluckt deine Figur.\nSie wachen an dem Ort auf, den Sie zuletzt erkundet haben, mit einer Punktzahl von -100 (nicht weniger als 0).';

  @override
  String get endingGameOverPrimary => 'wach am letzten Ort auf';

  @override
  String get inventoryTitle => 'Rucksack · Inventar';

  @override
  String get inventoryUseTitle => 'Benutze Requisiten · Benutze';

  @override
  String get inventoryDropTitle => 'Requisiten fallen lassen · Drop';

  @override
  String get teleportTitle => 'Senden an · Teleport';

  @override
  String get notLoaded => 'Noch nicht geladen';

  @override
  String get noUsableItems => 'Es sind keine Requisiten vorhanden.';

  @override
  String get noDroppableItems =>
      'Es gibt keine Requisiten, die man wegwerfen kann.';

  @override
  String get inventoryEmpty => 'Der Rucksack ist leer.';

  @override
  String get noMoreDescription => 'Keine weitere Beschreibung.';

  @override
  String itemType(String type) {
    return 'Typ $type';
  }

  @override
  String itemWeight(int weight) {
    return 'Gewicht $weight';
  }

  @override
  String itemValue(int value) {
    return 'Wert $value';
  }

  @override
  String itemHeal(int heal) {
    return 'Behandlung +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return 'Angriff +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return 'Verteidigung +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return 'Kapazität $capacity';
  }

  @override
  String itemCount(int count) {
    return 'Menge x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return 'Nutzungseffekt: $msg';
  }

  @override
  String statAtkShort(int bonus) {
    return 'Angriff+$bonus';
  }

  @override
  String statDefShort(int bonus) {
    return 'Anti+$bonus';
  }

  @override
  String get equip => 'Ausrüstung';

  @override
  String get use => 'verwenden';

  @override
  String get drop => 'wegwerfen';

  @override
  String get combatAttack => 'Angriff';

  @override
  String get combatSkill => 'Fähigkeit';

  @override
  String get combatItem => 'Requisiten';

  @override
  String get combatDefend => 'Verteidigung';

  @override
  String get combatMelee => 'Nahkampf';

  @override
  String get combatFlee => 'weglaufen';

  @override
  String get combatAttackShort => 'Angriff';

  @override
  String get combatSkillShort => 'Technologie';

  @override
  String get combatItemShort => 'Straße';

  @override
  String get combatDefendShort => 'Verteidigen';

  @override
  String get combatFleeShort => 'Flucht';

  @override
  String get combatCommandsTitle => 'Befehle';

  @override
  String get combatExecute => 'implementieren';

  @override
  String get combatVictory => 'Kampfsieg';

  @override
  String get combatVictoryTap => 'Klicken Sie, um fortzufahren';

  @override
  String get combatDefeated => 'schlagen';

  @override
  String get combatLoot => 'Beute';

  @override
  String get combatHarvest => 'Ernte';

  @override
  String combatGoldGain(int gold) {
    return '💰 Goldmünze +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ Erleben Sie +$exp';
  }

  @override
  String get combatNoItems =>
      'Im Rucksack sind keine Kampfgegenstände verfügbar';

  @override
  String get combatPickItem => 'Wählen Sie Requisitenelemente aus';

  @override
  String get combatInitiative => 'Action-Sequenz-Initiative';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return 'Bit $index $name Geschwindigkeit $speed';
  }

  @override
  String get combatLogTitle => 'Kampfberichtsprotokoll';

  @override
  String combatRound(int round) {
    return 'Rund $round';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return 'Befehl auswählen: $name';
  }

  @override
  String get combatPhasePickCommand => 'Befehl auswählen';

  @override
  String get combatPhasePickTarget => 'Ziel auswählen';

  @override
  String get combatPhasePickItem => 'Wählen Sie Requisiten und Ziele';

  @override
  String get combatPhaseReady => 'Bereit zur Ausführung der Runde';

  @override
  String get combatPhaseAnimating => 'Runde läuft…';

  @override
  String get combatQueueTitle => 'Befehle in der Befehlswarteschlange';

  @override
  String get combatQueuePending => 'Zur Auswahl…';

  @override
  String get combatEnemies => 'Feinde Feinde';

  @override
  String get combatParty => 'Teamparty';

  @override
  String get combatTitle => 'Rundenbasierter Kampf';

  @override
  String get combatMenuSemantics => 'Kampfmenü';

  @override
  String get combatEnded => 'Der Kampf ist vorbei';

  @override
  String get meleeEnded => 'Der Nahkampf endet.';

  @override
  String get meleeCancelled => 'Nahkampf wurde abgesagt.';

  @override
  String get enemyGeneric => 'Feind';

  @override
  String get cmdLook => 'Überprüfen';

  @override
  String get cmdBag => 'Rucksack';

  @override
  String get cmdTalk => 'Dialog';

  @override
  String get cmdHeal => 'behandeln';

  @override
  String get cmdRecruit => 'rekrutieren';

  @override
  String get cmdParty => 'Team';

  @override
  String get cmdScore => 'Punktzahl';

  @override
  String get cmdHelp => 'helfen';

  @override
  String get cmdNgPlus => 'Zweite Woche';

  @override
  String get cmdMore => 'Mehr';

  @override
  String get cmdTake => 'abholen';

  @override
  String get cmdBuy => 'Kaufen';

  @override
  String get cmdSell => 'verkaufen';

  @override
  String get cmdShop => 'Ware';

  @override
  String get cmdMoreTitle => 'Weitere Befehle · Mehr';

  @override
  String get cmdMoreSemantics => 'Weitere Befehle';

  @override
  String get cmdTakeTitle => 'abholen nehmen';

  @override
  String get cmdBuyTitle => 'kaufen kaufen';

  @override
  String get cmdSellTitle => 'verkaufen, verkaufen';

  @override
  String get cmdTakeAll => 'alle alle';

  @override
  String get cmdMapOn => 'Karte';

  @override
  String get cmdMapOff => 'Karte·Guan';

  @override
  String get cmdToggleMap => 'Karte wechseln';

  @override
  String get cmdDevMapOn => 'Öffnen Sie das gesamte Bild';

  @override
  String get cmdDevMapOff => 'Vollständige Kartenebene';

  @override
  String get cmdSend => 'Befehl senden';

  @override
  String get cmdHint => 'Befehl cmd: schau / nimm 1 / n …';

  @override
  String get dirNorth => 'Norden N';

  @override
  String get dirWest => 'West W';

  @override
  String get dirEast => 'Osten E';

  @override
  String get dirSouth => 'Süd S';

  @override
  String get dirUp => 'Up U';

  @override
  String get dirDown => 'Weiter D';

  @override
  String get mapHint =>
      'Ziehen und schwenken · Scrollrad/Zoom durch Auf- und Zuziehen · Klicken Sie auf benachbarte Knoten, um sie zu verschieben';

  @override
  String mapFullCount(int count) {
    return 'Vollständiges Bild $count';
  }

  @override
  String mapExploredCount(int count) {
    return 'Erkundet $count';
  }

  @override
  String get mapCannotMoveInCombat =>
      'Kann sich während des Kampfes nicht bewegen.';

  @override
  String mapGoing(String dir) {
    return 'Gehe zu $dir…';
  }

  @override
  String get mapDevFullMap => 'ENTWICKLER·Vollbild';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name – nicht angrenzend, nicht direkt zugänglich';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name (hier)';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · Gewicht $weight/$capacity · $count Stück · 💰$gold';
  }

  @override
  String combatUnitSemantics(
    String name,
    int hp,
    int maxHp,
    int atk,
    int def,
    int spd,
  ) {
    return '$name HP $hp/$maxHp Angriff $atk Verteidigung $def Geschwindigkeit $spd';
  }

  @override
  String get creditQa => 'Qualitätssicherung';

  @override
  String get creditPresentedBy => 'Produziert/präsentiert von';

  @override
  String get creditDirectedBy => 'Regisseur / Regie';

  @override
  String get creditWrittenBy => 'Drehbuchautor/Autor';

  @override
  String get creditGameDesign => 'Spieldesign / Spieldesign';

  @override
  String get creditNarrativeDesign =>
      'Narrative Gestaltung / Narrative Gestaltung';

  @override
  String get creditArtDirection => 'Art Direction / Art Direction';

  @override
  String get creditLevelDesign => 'Leveldesign / Leveldesign';

  @override
  String get creditSystemsDesign => 'Systemdesign / Systemdesign';

  @override
  String get creditCombatDesign => 'Kampfdesign / Kampfdesign';

  @override
  String get creditSoundConcept => 'Soundkonzept / Soundkonzept';

  @override
  String get creditProducedBy => 'Produzent / Produziert von';

  @override
  String get creditEngineering => 'Programm / Ingenieurwesen';

  @override
  String get creditSpecialThanks => 'Besonderer Dank / Besonderer Dank';

  @override
  String get creditTechSupport => 'Technischer Support / Technologie-Support';
}
