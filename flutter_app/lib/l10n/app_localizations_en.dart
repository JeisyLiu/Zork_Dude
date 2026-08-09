// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mist Tower';

  @override
  String get appTitleEn => 'MIST TOWER';

  @override
  String get taglineShort =>
      'Explore, collect, talk, fight — reclaim what was lost.';

  @override
  String get taglineFull =>
      'You wake in a misty forest with no memory.\nExplore, collect, talk, and fight — reclaim what was lost.';

  @override
  String get homeHint => 'Command exploration · Mist map · Turn-based combat';

  @override
  String get loading => 'Loading…';

  @override
  String get continueJourney => 'Continue';

  @override
  String get enterMist => 'Enter the Mist';

  @override
  String get achievements => 'Achievements';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get skip => 'Skip';

  @override
  String get continueAction => 'Continue';

  @override
  String get back => 'Back';

  @override
  String get menu => 'Menu';

  @override
  String get startNewJourneyTitle => 'Start a new journey?';

  @override
  String get overwriteSaveMessage =>
      'This slot already has a save. Starting a new game will overwrite it. Continue?';

  @override
  String get overwriteAndStart => 'Overwrite & start';

  @override
  String get connectPlayGamesTitle => 'Connect Play Games';

  @override
  String get connectPlayGamesMessage =>
      'Sign in to Google Play Games to view achievements and leaderboards. You can play without connecting.';

  @override
  String get connectLater => 'Not now';

  @override
  String get connectNow => 'Connect';

  @override
  String get returnToTitleTitle => 'Return to title?';

  @override
  String get returnToTitleMessage =>
      'Progress is auto-saved. Resume from the title screen with Continue.';

  @override
  String get returnToTitle => 'Return to title';

  @override
  String get quitAppTitle => 'Quit game?';

  @override
  String get quitAppMessage => 'This will close Mist Tower.';

  @override
  String get quit => 'Quit';

  @override
  String get combatPauseTitle => 'Combat menu · Pause';

  @override
  String get resumeCombat => 'Resume combat';

  @override
  String get backToTitle => 'Title screen';

  @override
  String get privacySettings => 'Privacy settings';

  @override
  String get privacySettingsHint => 'Privacy · privacy';

  @override
  String get rewardOfferTitle => 'Mist Gift';

  @override
  String rewardOfferGold(int base, int doubled) {
    return 'Gold this fight +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable => 'Gift unavailable — continue without it';

  @override
  String get rewardOfferWatch => 'Watch ad · Double gold';

  @override
  String get rewardOfferLoading => 'Summoning gift…';

  @override
  String get continueAdventure => 'Continue adventure';

  @override
  String get watchAd => 'Watch ad';

  @override
  String get watchAdRecoverLoss => 'Watch ad · Recover loss';

  @override
  String refundScorePoints(int points) {
    return 'Refund $points points';
  }

  @override
  String get summoningGlimmer => 'Summoning glimmer…';

  @override
  String get glimmerNoResponse => 'No response. Try again later.';

  @override
  String get endingDragonTitle => 'The Young Dragon Falls';

  @override
  String get endingDragonSubtitle =>
      'The magic gem is yours.\nIt can open the cemetery gate to the Site — or restore lost memories atop the tower.';

  @override
  String get endingDragonPrimary => 'Keep exploring';

  @override
  String get endingDragonSecondary => 'Finish the journey';

  @override
  String get endingMainTitle => 'The Mist Clears';

  @override
  String get endingMainSubtitle =>
      'Memories flood back as the tower\'s ward breaks.\nYou are free — yet unfinished business waits deep in the Site.';

  @override
  String get endingMainPrimary => 'Keep exploring';

  @override
  String get endingSiteTitle => 'Site Operation Complete';

  @override
  String get endingSiteSubtitle =>
      'The Final Prototype is contained. The vault falls silent.\nA long journey nears its end.';

  @override
  String get endingSitePrimary => 'Watch credits';

  @override
  String get endingGameOverTitle => 'You Have Fallen';

  @override
  String get endingGameOverSubtitle =>
      'The mist swallows you.\nYou wake at your last explored place. Score −100 (not below 0).';

  @override
  String get endingGameOverPrimary => 'Wake at last place';

  @override
  String get inventoryTitle => 'Bag · Inventory';

  @override
  String get inventoryUseTitle => 'Use item · Use';

  @override
  String get inventoryDropTitle => 'Drop item · Drop';

  @override
  String get teleportTitle => 'Teleport to · Teleport';

  @override
  String get notLoaded => 'Not loaded yet';

  @override
  String get noUsableItems => 'No usable items.';

  @override
  String get noDroppableItems => 'No droppable items.';

  @override
  String get inventoryEmpty => 'Your bag is empty.';

  @override
  String get noMoreDescription => 'No further description.';

  @override
  String itemType(String type) {
    return 'Type $type';
  }

  @override
  String itemWeight(int weight) {
    return 'Weight $weight';
  }

  @override
  String itemValue(int value) {
    return 'Value $value';
  }

  @override
  String itemHeal(int heal) {
    return 'Heal +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return 'Attack +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return 'Defense +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return 'Capacity $capacity';
  }

  @override
  String itemCount(int count) {
    return 'Qty x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return 'Effect: $msg';
  }

  @override
  String statAtkShort(int bonus) {
    return 'Atk+$bonus';
  }

  @override
  String statDefShort(int bonus) {
    return 'Def+$bonus';
  }

  @override
  String get equip => 'Equip';

  @override
  String get use => 'Use';

  @override
  String get drop => 'Drop';

  @override
  String get combatAttack => 'Attack';

  @override
  String get combatSkill => 'Skill';

  @override
  String get combatItem => 'Item';

  @override
  String get combatDefend => 'Defend';

  @override
  String get combatMelee => 'Melee';

  @override
  String get combatFlee => 'Flee';

  @override
  String get combatAttackShort => 'Atk';

  @override
  String get combatSkillShort => 'Skl';

  @override
  String get combatItemShort => 'Itm';

  @override
  String get combatDefendShort => 'Def';

  @override
  String get combatFleeShort => 'Flee';

  @override
  String get combatCommandsTitle => 'Commands';

  @override
  String get combatExecute => 'Execute';

  @override
  String get combatVictory => 'Victory';

  @override
  String get combatVictoryTap => 'Tap to continue';

  @override
  String get combatDefeated => 'Defeated';

  @override
  String get combatLoot => 'Loot';

  @override
  String get combatHarvest => 'Rewards';

  @override
  String combatGoldGain(int gold) {
    return '💰 Gold +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ EXP +$exp';
  }

  @override
  String get combatNoItems => 'No usable combat items in bag';

  @override
  String get combatPickItem => 'Choose item';

  @override
  String get combatInitiative => 'Initiative';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return 'Slot $index: $name, speed $speed';
  }

  @override
  String get combatLogTitle => 'Combat log';

  @override
  String combatRound(int round) {
    return 'Round $round';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return 'Choose command: $name';
  }

  @override
  String get combatPhasePickCommand => 'Choose command';

  @override
  String get combatPhasePickTarget => 'Choose target';

  @override
  String get combatPhasePickItem => 'Choose item & target';

  @override
  String get combatPhaseReady => 'Ready to execute';

  @override
  String get combatPhaseAnimating => 'Round in progress…';

  @override
  String get combatQueueTitle => 'Command queue';

  @override
  String get combatQueuePending => 'Pending…';

  @override
  String get combatEnemies => 'Enemies';

  @override
  String get combatParty => 'Party';

  @override
  String get combatTitle => 'Turn combat';

  @override
  String get combatMenuSemantics => 'Combat menu';

  @override
  String get combatEnded => 'Combat ended';

  @override
  String get meleeEnded => 'Melee ended.';

  @override
  String get meleeCancelled => 'Melee cancelled.';

  @override
  String get enemyGeneric => 'Enemy';

  @override
  String get cmdLook => 'Look';

  @override
  String get cmdBag => 'Bag';

  @override
  String get cmdTalk => 'Talk';

  @override
  String get cmdHeal => 'Heal';

  @override
  String get cmdRecruit => 'Recruit';

  @override
  String get cmdParty => 'Party';

  @override
  String get cmdScore => 'Score';

  @override
  String get cmdHelp => 'Help';

  @override
  String get cmdNgPlus => 'NG+';

  @override
  String get cmdMore => 'More';

  @override
  String get cmdTake => 'Take';

  @override
  String get cmdBuy => 'Buy';

  @override
  String get cmdSell => 'Sell';

  @override
  String get cmdShop => 'Shop';

  @override
  String get cmdMoreTitle => 'More commands';

  @override
  String get cmdMoreSemantics => 'More commands';

  @override
  String get cmdTakeTitle => 'Take';

  @override
  String get cmdBuyTitle => 'Buy';

  @override
  String get cmdSellTitle => 'Sell';

  @override
  String get cmdTakeAll => 'All';

  @override
  String get cmdMapOn => 'Map';

  @override
  String get cmdMapOff => 'Map off';

  @override
  String get cmdToggleMap => 'Toggle map';

  @override
  String get cmdDevMapOn => 'Full map on';

  @override
  String get cmdDevMapOff => 'Full map off';

  @override
  String get cmdSend => 'Send command';

  @override
  String get cmdHint => 'cmd: look / take 1 / n …';

  @override
  String get dirNorth => 'N';

  @override
  String get dirWest => 'W';

  @override
  String get dirEast => 'E';

  @override
  String get dirSouth => 'S';

  @override
  String get dirUp => 'U';

  @override
  String get dirDown => 'D';

  @override
  String get mapHint =>
      'Drag to pan · Scroll/pinch to zoom · Tap adjacent node to move';

  @override
  String mapFullCount(int count) {
    return 'Full map $count';
  }

  @override
  String mapExploredCount(int count) {
    return 'Explored $count';
  }

  @override
  String get mapCannotMoveInCombat => 'Cannot move during combat.';

  @override
  String mapGoing(String dir) {
    return 'Going $dir…';
  }

  @override
  String get mapDevFullMap => 'DEV · Full map';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name — not adjacent, cannot travel directly';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name (here)';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · weight $weight/$capacity · $count items · 💰$gold';
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
    return '$name HP $hp/$maxHp ATK $atk DEF $def SPD $spd';
  }

  @override
  String get creditQa => 'QA / Quality Assurance';

  @override
  String get creditPresentedBy => 'Presented by';

  @override
  String get creditDirectedBy => 'Directed by';

  @override
  String get creditWrittenBy => 'Written by';

  @override
  String get creditGameDesign => 'Game Design';

  @override
  String get creditNarrativeDesign => 'Narrative Design';

  @override
  String get creditArtDirection => 'Art Direction';

  @override
  String get creditLevelDesign => 'Level Design';

  @override
  String get creditSystemsDesign => 'Systems Design';

  @override
  String get creditCombatDesign => 'Combat Design';

  @override
  String get creditSoundConcept => 'Sound Concept';

  @override
  String get creditProducedBy => 'Produced by';

  @override
  String get creditEngineering => 'Engineering';

  @override
  String get creditSpecialThanks => 'Special Thanks';

  @override
  String get creditTechSupport => 'Technology Support';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsBgmEnabled => 'Background music';

  @override
  String get settingsSfxEnabled => 'Sound effects';

  @override
  String get settingsGearSemantics => 'Settings';

  @override
  String get settingsHint =>
      'Use your device volume buttons to adjust loudness.';

  @override
  String get settingsMenuLabel => 'Settings';

  @override
  String get deleteSaveTitle => 'Delete save?';

  @override
  String get deleteSaveMessage =>
      'Progress in this slot will be permanently deleted.';

  @override
  String get deleteSaveConfirm => 'Delete';

  @override
  String get deleteSaveSemantics => 'Delete save';
}

/// The translations for English, as used in the United States (`en_US`).
class AppLocalizationsEnUs extends AppLocalizationsEn {
  AppLocalizationsEnUs() : super('en_US');

  @override
  String get appTitle => 'Mist Tower';

  @override
  String get appTitleEn => 'MIST TOWER';

  @override
  String get taglineShort =>
      'Explore, collect, talk, fight — reclaim what was lost.';

  @override
  String get taglineFull =>
      'You wake in a misty forest with no memory.\nExplore, collect, talk, and fight — reclaim what was lost.';

  @override
  String get homeHint => 'Command exploration · Mist map · Turn-based combat';

  @override
  String get loading => 'Loading…';

  @override
  String get continueJourney => 'Continue';

  @override
  String get enterMist => 'Enter the Mist';

  @override
  String get achievements => 'Achievements';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get skip => 'Skip';

  @override
  String get continueAction => 'Continue';

  @override
  String get back => 'Back';

  @override
  String get menu => 'Menu';

  @override
  String get startNewJourneyTitle => 'Start a new journey?';

  @override
  String get overwriteSaveMessage =>
      'This slot already has a save. Starting a new game will overwrite it. Continue?';

  @override
  String get overwriteAndStart => 'Overwrite & start';

  @override
  String get connectPlayGamesTitle => 'Connect Play Games';

  @override
  String get connectPlayGamesMessage =>
      'Sign in to Google Play Games to view achievements and leaderboards. You can play without connecting.';

  @override
  String get connectLater => 'Not now';

  @override
  String get connectNow => 'Connect';

  @override
  String get returnToTitleTitle => 'Return to title?';

  @override
  String get returnToTitleMessage =>
      'Progress is auto-saved. Resume from the title screen with Continue.';

  @override
  String get returnToTitle => 'Return to title';

  @override
  String get quitAppTitle => 'Quit game?';

  @override
  String get quitAppMessage => 'This will close Mist Tower.';

  @override
  String get quit => 'Quit';

  @override
  String get combatPauseTitle => 'Combat menu · Pause';

  @override
  String get resumeCombat => 'Resume combat';

  @override
  String get backToTitle => 'Title screen';

  @override
  String get privacySettings => 'Privacy settings';

  @override
  String get privacySettingsHint => 'Privacy · privacy';

  @override
  String get rewardOfferTitle => 'Mist Gift';

  @override
  String rewardOfferGold(int base, int doubled) {
    return 'Gold this fight +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable => 'Gift unavailable — continue without it';

  @override
  String get rewardOfferWatch => 'Watch ad · Double gold';

  @override
  String get rewardOfferLoading => 'Summoning gift…';

  @override
  String get continueAdventure => 'Continue adventure';

  @override
  String get watchAd => 'Watch ad';

  @override
  String get watchAdRecoverLoss => 'Watch ad · Recover loss';

  @override
  String refundScorePoints(int points) {
    return 'Refund $points points';
  }

  @override
  String get summoningGlimmer => 'Summoning glimmer…';

  @override
  String get glimmerNoResponse => 'No response. Try again later.';

  @override
  String get endingDragonTitle => 'The Young Dragon Falls';

  @override
  String get endingDragonSubtitle =>
      'The magic gem is yours.\nIt can open the cemetery gate to the Site — or restore lost memories atop the tower.';

  @override
  String get endingDragonPrimary => 'Keep exploring';

  @override
  String get endingDragonSecondary => 'Finish the journey';

  @override
  String get endingMainTitle => 'The Mist Clears';

  @override
  String get endingMainSubtitle =>
      'Memories flood back as the tower\'s ward breaks.\nYou are free — yet unfinished business waits deep in the Site.';

  @override
  String get endingMainPrimary => 'Keep exploring';

  @override
  String get endingSiteTitle => 'Site Operation Complete';

  @override
  String get endingSiteSubtitle =>
      'The Final Prototype is contained. The vault falls silent.\nA long journey nears its end.';

  @override
  String get endingSitePrimary => 'Watch credits';

  @override
  String get endingGameOverTitle => 'You Have Fallen';

  @override
  String get endingGameOverSubtitle =>
      'The mist swallows you.\nYou wake at your last explored place. Score −100 (not below 0).';

  @override
  String get endingGameOverPrimary => 'Wake at last place';

  @override
  String get inventoryTitle => 'Bag · Inventory';

  @override
  String get inventoryUseTitle => 'Use item · Use';

  @override
  String get inventoryDropTitle => 'Drop item · Drop';

  @override
  String get teleportTitle => 'Teleport to · Teleport';

  @override
  String get notLoaded => 'Not loaded yet';

  @override
  String get noUsableItems => 'No usable items.';

  @override
  String get noDroppableItems => 'No droppable items.';

  @override
  String get inventoryEmpty => 'Your bag is empty.';

  @override
  String get noMoreDescription => 'No further description.';

  @override
  String itemType(String type) {
    return 'Type $type';
  }

  @override
  String itemWeight(int weight) {
    return 'Weight $weight';
  }

  @override
  String itemValue(int value) {
    return 'Value $value';
  }

  @override
  String itemHeal(int heal) {
    return 'Heal +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return 'Attack +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return 'Defense +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return 'Capacity $capacity';
  }

  @override
  String itemCount(int count) {
    return 'Qty x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return 'Effect: $msg';
  }

  @override
  String statAtkShort(int bonus) {
    return 'Atk+$bonus';
  }

  @override
  String statDefShort(int bonus) {
    return 'Def+$bonus';
  }

  @override
  String get equip => 'Equip';

  @override
  String get use => 'Use';

  @override
  String get drop => 'Drop';

  @override
  String get combatAttack => 'Attack';

  @override
  String get combatSkill => 'Skill';

  @override
  String get combatItem => 'Item';

  @override
  String get combatDefend => 'Defend';

  @override
  String get combatMelee => 'Melee';

  @override
  String get combatFlee => 'Flee';

  @override
  String get combatAttackShort => 'Atk';

  @override
  String get combatSkillShort => 'Skl';

  @override
  String get combatItemShort => 'Itm';

  @override
  String get combatDefendShort => 'Def';

  @override
  String get combatFleeShort => 'Flee';

  @override
  String get combatCommandsTitle => 'Commands';

  @override
  String get combatExecute => 'Execute';

  @override
  String get combatVictory => 'Victory';

  @override
  String get combatVictoryTap => 'Tap to continue';

  @override
  String get combatDefeated => 'Defeated';

  @override
  String get combatLoot => 'Loot';

  @override
  String get combatHarvest => 'Rewards';

  @override
  String combatGoldGain(int gold) {
    return '💰 Gold +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ EXP +$exp';
  }

  @override
  String get combatNoItems => 'No usable combat items in bag';

  @override
  String get combatPickItem => 'Choose item';

  @override
  String get combatInitiative => 'Initiative';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return 'Slot $index: $name, speed $speed';
  }

  @override
  String get combatLogTitle => 'Combat log';

  @override
  String combatRound(int round) {
    return 'Round $round';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return 'Choose command: $name';
  }

  @override
  String get combatPhasePickCommand => 'Choose command';

  @override
  String get combatPhasePickTarget => 'Choose target';

  @override
  String get combatPhasePickItem => 'Choose item & target';

  @override
  String get combatPhaseReady => 'Ready to execute';

  @override
  String get combatPhaseAnimating => 'Round in progress…';

  @override
  String get combatQueueTitle => 'Command queue';

  @override
  String get combatQueuePending => 'Pending…';

  @override
  String get combatEnemies => 'Enemies';

  @override
  String get combatParty => 'Party';

  @override
  String get combatTitle => 'Turn combat';

  @override
  String get combatMenuSemantics => 'Combat menu';

  @override
  String get combatEnded => 'Combat ended';

  @override
  String get meleeEnded => 'Melee ended.';

  @override
  String get meleeCancelled => 'Melee cancelled.';

  @override
  String get enemyGeneric => 'Enemy';

  @override
  String get cmdLook => 'Look';

  @override
  String get cmdBag => 'Bag';

  @override
  String get cmdTalk => 'Talk';

  @override
  String get cmdHeal => 'Heal';

  @override
  String get cmdRecruit => 'Recruit';

  @override
  String get cmdParty => 'Party';

  @override
  String get cmdScore => 'Score';

  @override
  String get cmdHelp => 'Help';

  @override
  String get cmdNgPlus => 'NG+';

  @override
  String get cmdMore => 'More';

  @override
  String get cmdTake => 'Take';

  @override
  String get cmdBuy => 'Buy';

  @override
  String get cmdSell => 'Sell';

  @override
  String get cmdShop => 'Shop';

  @override
  String get cmdMoreTitle => 'More commands';

  @override
  String get cmdMoreSemantics => 'More commands';

  @override
  String get cmdTakeTitle => 'Take';

  @override
  String get cmdBuyTitle => 'Buy';

  @override
  String get cmdSellTitle => 'Sell';

  @override
  String get cmdTakeAll => 'All';

  @override
  String get cmdMapOn => 'Map';

  @override
  String get cmdMapOff => 'Map off';

  @override
  String get cmdToggleMap => 'Toggle map';

  @override
  String get cmdDevMapOn => 'Full map on';

  @override
  String get cmdDevMapOff => 'Full map off';

  @override
  String get cmdSend => 'Send command';

  @override
  String get cmdHint => 'cmd: look / take 1 / n …';

  @override
  String get dirNorth => 'N';

  @override
  String get dirWest => 'W';

  @override
  String get dirEast => 'E';

  @override
  String get dirSouth => 'S';

  @override
  String get dirUp => 'U';

  @override
  String get dirDown => 'D';

  @override
  String get mapHint =>
      'Drag to pan · Scroll/pinch to zoom · Tap adjacent node to move';

  @override
  String mapFullCount(int count) {
    return 'Full map $count';
  }

  @override
  String mapExploredCount(int count) {
    return 'Explored $count';
  }

  @override
  String get mapCannotMoveInCombat => 'Cannot move during combat.';

  @override
  String mapGoing(String dir) {
    return 'Going $dir…';
  }

  @override
  String get mapDevFullMap => 'DEV · Full map';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name — not adjacent, cannot travel directly';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name (here)';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · weight $weight/$capacity · $count items · 💰$gold';
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
    return '$name HP $hp/$maxHp ATK $atk DEF $def SPD $spd';
  }

  @override
  String get creditQa => 'QA / Quality Assurance';

  @override
  String get creditPresentedBy => 'Presented by';

  @override
  String get creditDirectedBy => 'Directed by';

  @override
  String get creditWrittenBy => 'Written by';

  @override
  String get creditGameDesign => 'Game Design';

  @override
  String get creditNarrativeDesign => 'Narrative Design';

  @override
  String get creditArtDirection => 'Art Direction';

  @override
  String get creditLevelDesign => 'Level Design';

  @override
  String get creditSystemsDesign => 'Systems Design';

  @override
  String get creditCombatDesign => 'Combat Design';

  @override
  String get creditSoundConcept => 'Sound Concept';

  @override
  String get creditProducedBy => 'Produced by';

  @override
  String get creditEngineering => 'Engineering';

  @override
  String get creditSpecialThanks => 'Special Thanks';

  @override
  String get creditTechSupport => 'Technology Support';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsBgmEnabled => 'Background music';

  @override
  String get settingsSfxEnabled => 'Sound effects';

  @override
  String get settingsGearSemantics => 'Settings';

  @override
  String get settingsHint =>
      'Use your device volume buttons to adjust loudness.';

  @override
  String get settingsMenuLabel => 'Settings';

  @override
  String get deleteSaveTitle => 'Delete save?';

  @override
  String get deleteSaveMessage =>
      'Progress in this slot will be permanently deleted.';

  @override
  String get deleteSaveConfirm => 'Delete';

  @override
  String get deleteSaveSemantics => 'Delete save';
}
