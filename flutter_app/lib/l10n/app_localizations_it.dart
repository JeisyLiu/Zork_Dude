// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Torre delle Nebbie';

  @override
  String get appTitleEn => 'TORRE DELLA NEBBIA';

  @override
  String get taglineShort =>
      'Esplora, raccogli, parla, combatti: recupera la verità perduta.';

  @override
  String get taglineFull =>
      'Ti svegli da una foresta nebbiosa senza memoria.\nEsplora, raccogli, parla, combatti: recupera la verità perduta.';

  @override
  String get homeHint =>
      'Esplorazione dei comandi · Mappa della nebbia · Incontra un nemico ed entra in un round di battaglia';

  @override
  String get loading => 'caricamento…';

  @override
  String get continueJourney => 'Continua il viaggio';

  @override
  String get enterMist => 'Entra nella nebbia';

  @override
  String get achievements => 'Risultato';

  @override
  String get leaderboard => 'Classifica';

  @override
  String get close => 'chiusura';

  @override
  String get cancel => 'Cancellare';

  @override
  String get confirm => 'confermare';

  @override
  String get skip => 'saltare';

  @override
  String get continueAction => 'continuare';

  @override
  String get back => 'ritorno';

  @override
  String get menu => 'menu';

  @override
  String get startNewJourneyTitle => 'Iniziare un nuovo viaggio?';

  @override
  String get overwriteSaveMessage =>
      'Ci sono già progressi in questo slot. L\'avvio di una nuova partita sovrascriverà questo salvataggio. Vuoi continuare?';

  @override
  String get overwriteAndStart => 'Copri e inizia';

  @override
  String get connectPlayGamesTitle => 'Connetti Gioca ai giochi';

  @override
  String get connectPlayGamesMessage =>
      'Connettiti a Google Play Games per visualizzare risultati e classifiche. Puoi giocare normalmente senza connetterti.';

  @override
  String get connectLater => 'Parliamo più tardi';

  @override
  String get connectNow => 'Connettiti ora';

  @override
  String get returnToTitleTitle => 'Titolo restituito?';

  @override
  String get returnToTitleMessage =>
      'I progressi attuali sono stati salvati automaticamente e possono essere ripristinati dalla pagina del titolo \"Continua il viaggio\".';

  @override
  String get returnToTitle => 'titolo di ritorno';

  @override
  String get quitAppTitle => 'Abbandonare il gioco?';

  @override
  String get quitAppMessage => 'La Torre della Nebbia sarà chiusa.';

  @override
  String get quit => 'esentato';

  @override
  String get combatPauseTitle => 'Menu Battaglia · Pausa';

  @override
  String get resumeCombat => 'continuare a combattere';

  @override
  String get backToTitle => 'Ritorna al titolo';

  @override
  String get privacySettings => 'Impostazioni sulla privacy';

  @override
  String get privacySettingsHint => 'Impostazioni sulla privacy · privacy';

  @override
  String get rewardOfferTitle => 'Dono della nebbia';

  @override
  String rewardOfferGold(int base, int doubled) {
    return 'Monete d\'oro in questo gioco +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable =>
      'I regali sono temporaneamente non disponibili, puoi continuare direttamente l\'avventura';

  @override
  String get rewardOfferWatch => 'Guarda gli annunci · Monete d\'oro doppie';

  @override
  String get rewardOfferLoading => 'Evocare doni...';

  @override
  String get continueAdventure => 'continuare l\'avventura';

  @override
  String get watchAd => 'Guarda gli annunci';

  @override
  String get watchAdRecoverLoss => 'Guarda gli annunci · Recupera le perdite';

  @override
  String refundScorePoints(int points) {
    return 'Restituisci $points punti';
  }

  @override
  String get summoningGlimmer => 'Evocazione nel crepuscolo...';

  @override
  String get glimmerNoResponse =>
      'Shimmer non ha ancora risposto, riprova più tardi.';

  @override
  String get endingDragonTitle => 'Il giovane drago è caduto';

  @override
  String get endingDragonSubtitle =>
      'La gemma magica cade nelle tue mani.\nNon solo può aprire la porta di pietra dal cimitero al rifugio, ma anche richiamare i ricordi perduti sulla cima della torre.';

  @override
  String get endingDragonPrimary => 'continuare l\'avventura';

  @override
  String get endingDragonSecondary => 'Ritorno per completare il viaggio';

  @override
  String get endingMainTitle => 'La nebbia si dissipa';

  @override
  String get endingMainSubtitle =>
      'I ricordi rifluirono nella sua mente e la barriera della torre crollò.\nSei libero, ma ci sono ancora degli affari in sospeso nel profondo del manicomio.';

  @override
  String get endingMainPrimary => 'Continua a esplorare';

  @override
  String get endingSiteTitle => 'Azione del sito completata';

  @override
  String get endingSiteSubtitle =>
      'Il prototipo finale è stato soppresso e il caveau di contenimento è caduto nel silenzio.\nUn lungo viaggio sta per concludersi.';

  @override
  String get endingSitePrimary => 'Visualizza l\'elenco del personale';

  @override
  String get endingGameOverTitle => 'sei caduto';

  @override
  String get endingGameOverSubtitle =>
      'La nebbia ingoia la tua figura.\nTi svegli nell\'ultimo luogo che hai esplorato, con un punteggio di -100 (non inferiore a 0).';

  @override
  String get endingGameOverPrimary => 'svegliarsi all\'ultimo posto';

  @override
  String get inventoryTitle => 'Zaino · Inventario';

  @override
  String get inventoryUseTitle => 'Usa oggetti di scena · Usa';

  @override
  String get inventoryDropTitle =>
      'Lascia cadere gli oggetti di scena · Lascia cadere';

  @override
  String get teleportTitle => 'Invia a · Teletrasporto';

  @override
  String get notLoaded => 'Non ancora caricato';

  @override
  String get noUsableItems => 'Non ci sono oggetti di scena disponibili.';

  @override
  String get noDroppableItems => 'Non ci sono oggetti di scena da buttare via.';

  @override
  String get inventoryEmpty => 'Lo zaino è vuoto.';

  @override
  String get noMoreDescription => 'Nessuna ulteriore descrizione.';

  @override
  String itemType(String type) {
    return 'Digita $type';
  }

  @override
  String itemWeight(int weight) {
    return 'Peso $weight';
  }

  @override
  String itemValue(int value) {
    return 'Valore $value';
  }

  @override
  String itemHeal(int heal) {
    return 'Trattamento +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return 'Attacco +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return 'Difesa +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return 'Capacità $capacity';
  }

  @override
  String itemCount(int count) {
    return 'Quantità x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return 'Effetto di utilizzo: $msg';
  }

  @override
  String statAtkShort(int bonus) {
    return 'Attacco+$bonus';
  }

  @override
  String statDefShort(int bonus) {
    return 'Anti+$bonus';
  }

  @override
  String get equip => 'attrezzatura';

  @override
  String get use => 'utilizzo';

  @override
  String get drop => 'Buttar via';

  @override
  String get combatAttack => 'attacco';

  @override
  String get combatSkill => 'Abilità';

  @override
  String get combatItem => 'Oggetti di scena';

  @override
  String get combatDefend => 'difesa';

  @override
  String get combatMelee => 'Mischia';

  @override
  String get combatFlee => 'fuggire';

  @override
  String get combatAttackShort => 'attacco';

  @override
  String get combatSkillShort => 'tecnologia';

  @override
  String get combatItemShort => 'strada';

  @override
  String get combatDefendShort => 'Difendere';

  @override
  String get combatFleeShort => 'fuga';

  @override
  String get combatCommandsTitle => 'Comandi';

  @override
  String get combatExecute => 'attrezzo';

  @override
  String get combatVictory => 'vittoria in battaglia';

  @override
  String get combatVictoryTap => '点击继续';

  @override
  String get combatDefeated => 'colpo';

  @override
  String get combatLoot => 'bottino';

  @override
  String get combatHarvest => 'Raccolto';

  @override
  String combatGoldGain(int gold) {
    return '💰 Moneta d\'oro +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ Esperienza +$exp';
  }

  @override
  String get combatNoItems =>
      'Nello zaino non sono disponibili oggetti da combattimento';

  @override
  String get combatPickItem => 'Seleziona gli oggetti di scena';

  @override
  String get combatInitiative => 'Iniziativa in sequenza di azioni';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return 'Bit $index $name Velocità $speed';
  }

  @override
  String get combatLogTitle => 'Registro del rapporto di battaglia';

  @override
  String combatRound(int round) {
    return 'Rotondo $round';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return 'Seleziona comando: $name';
  }

  @override
  String get combatPhasePickCommand => 'Seleziona comando';

  @override
  String get combatPhasePickTarget => 'Seleziona destinazione';

  @override
  String get combatPhasePickItem => 'Scegli oggetti di scena e bersagli';

  @override
  String get combatPhaseReady => 'Pronto per eseguire il giro';

  @override
  String get combatPhaseAnimating => 'Turno in corso…';

  @override
  String get combatQueueTitle => 'Comandi della coda di comando';

  @override
  String get combatQueuePending => 'Da selezionare…';

  @override
  String get combatEnemies => 'Nemici Nemici';

  @override
  String get combatParty => 'Festa di squadra';

  @override
  String get combatTitle => 'Combattimento a turni';

  @override
  String get combatMenuSemantics => 'menu di battaglia';

  @override
  String get combatEnded => 'La battaglia è finita';

  @override
  String get meleeEnded => 'La mischia finisce.';

  @override
  String get meleeCancelled => 'La mischia è stata annullata.';

  @override
  String get enemyGeneric => 'nemico';

  @override
  String get cmdLook => 'Controllo';

  @override
  String get cmdBag => 'Zaino';

  @override
  String get cmdTalk => 'dialogo';

  @override
  String get cmdHeal => 'trattare';

  @override
  String get cmdRecruit => 'reclutare';

  @override
  String get cmdParty => 'squadra';

  @override
  String get cmdScore => 'Punto';

  @override
  String get cmdHelp => 'aiuto';

  @override
  String get cmdNgPlus => 'Seconda settimana';

  @override
  String get cmdMore => 'Di più';

  @override
  String get cmdTake => 'raccolta';

  @override
  String get cmdBuy => 'Acquistare';

  @override
  String get cmdSell => 'vendere';

  @override
  String get cmdShop => 'merce';

  @override
  String get cmdMoreTitle => 'Altri comandi · Altro';

  @override
  String get cmdMoreSemantics => 'Più comandi';

  @override
  String get cmdTakeTitle => 'prendere prendere';

  @override
  String get cmdBuyTitle => 'comprare comprare';

  @override
  String get cmdSellTitle => 'vendere vendere';

  @override
  String get cmdTakeAll => 'tutto tutto';

  @override
  String get cmdMapOn => 'mappa';

  @override
  String get cmdMapOff => 'Mappa·Guan';

  @override
  String get cmdToggleMap => 'Cambia mappa';

  @override
  String get cmdDevMapOn => 'Apri l\'intera immagine';

  @override
  String get cmdDevMapOff => 'Livello mappa completo';

  @override
  String get cmdSend => 'Invia comando';

  @override
  String get cmdHint => 'Comando cmd: guarda/prendi 1/n…';

  @override
  String get dirNorth => 'Nord N';

  @override
  String get dirWest => 'Ovest W';

  @override
  String get dirEast => 'Est E';

  @override
  String get dirSouth => 'Sud S';

  @override
  String get dirUp => 'Su U';

  @override
  String get dirDown => 'Il prossimo D';

  @override
  String get mapHint =>
      'Trascina e fai una panoramica · Scorri la rotella/pizzica per ingrandire · Fai clic sui nodi adiacenti per spostarti';

  @override
  String mapFullCount(int count) {
    return 'Immagine intera $count';
  }

  @override
  String mapExploredCount(int count) {
    return 'Esplorato $count';
  }

  @override
  String get mapCannotMoveInCombat =>
      'Impossibile muoversi durante il combattimento.';

  @override
  String mapGoing(String dir) {
    return 'Vai a $dir...';
  }

  @override
  String get mapDevFullMap => 'DEV·Immagine completa';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name — non adiacente, non direttamente accessibile';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name (qui)';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · Peso $weight/$capacity · $count pezzi · 💰$gold';
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
    return '$name HP $hp/$maxHp Attacco $atk Difesa $def Velocità $spd';
  }

  @override
  String get creditQa => 'Garanzia di qualità';

  @override
  String get creditPresentedBy => 'Prodotto/Presentato da';

  @override
  String get creditDirectedBy => 'Regista / Diretto da';

  @override
  String get creditWrittenBy => 'Sceneggiatore/Scritto da';

  @override
  String get creditGameDesign =>
      'Progettazione di giochi / Progettazione di giochi';

  @override
  String get creditNarrativeDesign => 'Design narrativo / Design narrativo';

  @override
  String get creditArtDirection => 'Direzione artistica / Direzione artistica';

  @override
  String get creditLevelDesign =>
      'Progettazione dei livelli / Progettazione dei livelli';

  @override
  String get creditSystemsDesign =>
      'Progettazione di sistemi / Progettazione di sistemi';

  @override
  String get creditCombatDesign =>
      'Progettazione del combattimento / Progettazione del combattimento';

  @override
  String get creditSoundConcept => 'Concetto del suono/Concetto del suono';

  @override
  String get creditProducedBy => 'Produttore / Prodotto da';

  @override
  String get creditEngineering => 'Programma/Ingegneria';

  @override
  String get creditSpecialThanks => '特别鸣谢 / Special Thanks';

  @override
  String get creditTechSupport => 'Supporto tecnico/Supporto tecnologico';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsBgmEnabled => 'Musica di sottofondo';

  @override
  String get settingsSfxEnabled => 'Effetti sonori';

  @override
  String get settingsGearSemantics => 'Impostazioni';

  @override
  String get settingsHint => 'Regola il volume con i tasti del dispositivo.';

  @override
  String get settingsMenuLabel => 'Impostazioni';
}
