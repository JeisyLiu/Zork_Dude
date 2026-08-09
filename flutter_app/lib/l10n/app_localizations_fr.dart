// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Tour des Brumes';

  @override
  String get appTitleEn => 'TOUR DE BRUME';

  @override
  String get taglineShort =>
      'Explorez, collectionnez, parlez, combattez : retrouvez la vérité perdue.';

  @override
  String get taglineFull =>
      'Vous vous réveillez d\'une forêt brumeuse sans aucun souvenir.\nExplorez, collectionnez, parlez, combattez : retrouvez la vérité perdue.';

  @override
  String get homeHint =>
      'Exploration de commandement · Carte de brouillard · Rencontrez un ennemi et participez à un combat';

  @override
  String get loading => 'chargement…';

  @override
  String get continueJourney => 'Continuer le voyage';

  @override
  String get enterMist => 'Entrez dans le brouillard';

  @override
  String get achievements => 'Réalisation';

  @override
  String get leaderboard => 'Liste de classement';

  @override
  String get close => 'fermeture';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'confirmer';

  @override
  String get skip => 'franchir';

  @override
  String get continueAction => 'continuer';

  @override
  String get back => 'retour';

  @override
  String get menu => 'menu';

  @override
  String get startNewJourneyTitle => 'Vous commencez un nouveau voyage ?';

  @override
  String get overwriteSaveMessage =>
      'Il y a déjà des progrès dans ce créneau. Démarrer une nouvelle partie écrasera cette sauvegarde. Voulez-vous continuer ?';

  @override
  String get overwriteAndStart => 'Couvrir et démarrer';

  @override
  String get connectPlayGamesTitle => 'Connecter Jouer à des jeux';

  @override
  String get connectPlayGamesMessage =>
      'Connectez-vous à Google Play Games pour afficher les réalisations et les classements. Vous pouvez jouer normalement sans vous connecter.';

  @override
  String get connectLater => 'On se parle plus tard';

  @override
  String get connectNow => 'Connectez-vous maintenant';

  @override
  String get returnToTitleTitle => 'Retourner le titre ?';

  @override
  String get returnToTitleMessage =>
      'La progression actuelle a été automatiquement enregistrée et peut être restaurée à partir de la page de titre « Continuer le voyage ».';

  @override
  String get returnToTitle => 'retourner le titre';

  @override
  String get quitAppTitle => 'Quitter le jeu ?';

  @override
  String get quitAppMessage => 'La Tour de Brume sera fermée.';

  @override
  String get quit => 'quitter';

  @override
  String get combatPauseTitle => 'Menu Bataille · Pause';

  @override
  String get resumeCombat => 'continuez à vous battre';

  @override
  String get backToTitle => 'Retour au titre';

  @override
  String get privacySettings => 'Paramètres de confidentialité';

  @override
  String get privacySettingsHint =>
      'Paramètres de confidentialité · confidentialité';

  @override
  String get rewardOfferTitle => 'Cadeau de la brume';

  @override
  String rewardOfferGold(int base, int doubled) {
    return 'Pièces d\'or dans ce jeu +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable =>
      'Les cadeaux sont temporairement indisponibles, vous pouvez continuer l\'aventure directement';

  @override
  String get rewardOfferWatch => 'Regarder des annonces · Pièces d\'or doubles';

  @override
  String get rewardOfferLoading => 'Cadeaux d\'invocation...';

  @override
  String get continueAdventure => 'continuer l\'aventure';

  @override
  String get watchAd => 'Regarder des publicités';

  @override
  String get watchAdRecoverLoss =>
      'Regarder des publicités · Récupérer les pertes';

  @override
  String refundScorePoints(int points) {
    return 'Retourner $points points';
  }

  @override
  String get summoningGlimmer => 'Invocation au crépuscule…';

  @override
  String get glimmerNoResponse =>
      'Shimmer n\'a pas encore répondu, veuillez réessayer plus tard.';

  @override
  String get endingDragonTitle => 'Le jeune dragon est tombé';

  @override
  String get endingDragonSubtitle =>
      'La gemme magique tombe entre vos mains.\nIl peut non seulement ouvrir la porte en pierre du cimetière à l\'abri, mais aussi rappeler des souvenirs perdus au sommet de la tour.';

  @override
  String get endingDragonPrimary => 'continuer l\'aventure';

  @override
  String get endingDragonSecondary => 'Retour pour terminer le voyage';

  @override
  String get endingMainTitle => 'Le brouillard se dissipe';

  @override
  String get endingMainSubtitle =>
      'Les souvenirs revinrent dans son esprit et la barrière de la tour s\'effondra.\nVous êtes libre, mais il reste encore des choses à terminer au plus profond de l\'asile.';

  @override
  String get endingMainPrimary => 'Continuez à explorer';

  @override
  String get endingSiteTitle => 'Action sur le site terminée';

  @override
  String get endingSiteSubtitle =>
      'Le prototype final a été supprimé et la chambre forte de confinement est tombée dans le silence.\nUn long voyage touche à sa fin.';

  @override
  String get endingSitePrimary => 'Afficher la liste du personnel';

  @override
  String get endingGameOverTitle => 'tu es tombé';

  @override
  String get endingGameOverSubtitle =>
      'La brume engloutit votre silhouette.\nVous vous réveillez au dernier endroit que vous avez exploré, avec un score de -100 (pas moins de 0).';

  @override
  String get endingGameOverPrimary => 'réveille-toi au dernier endroit';

  @override
  String get inventoryTitle => 'Sac à dos · Inventaire';

  @override
  String get inventoryUseTitle => 'Utiliser des accessoires · Utiliser';

  @override
  String get inventoryDropTitle =>
      'Laisser tomber des accessoires · Laisser tomber';

  @override
  String get teleportTitle => 'Envoyer à · Téléporter';

  @override
  String get notLoaded => 'Pas encore chargé';

  @override
  String get noUsableItems => 'Il n\'y a aucun accessoire disponible.';

  @override
  String get noDroppableItems => 'Il n\'y a aucun accessoire à jeter.';

  @override
  String get inventoryEmpty => 'Le sac à dos est vide.';

  @override
  String get noMoreDescription => 'Aucune autre description.';

  @override
  String itemType(String type) {
    return 'Tapez $type';
  }

  @override
  String itemWeight(int weight) {
    return 'Poids $weight';
  }

  @override
  String itemValue(int value) {
    return 'Valeur $value';
  }

  @override
  String itemHeal(int heal) {
    return 'Traitement +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return 'Attaque +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return 'Défense +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return 'Capacité $capacity';
  }

  @override
  String itemCount(int count) {
    return 'Quantité x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return 'Effet d\'utilisation : $msg';
  }

  @override
  String statAtkShort(int bonus) {
    return 'Attaque+$bonus';
  }

  @override
  String statDefShort(int bonus) {
    return 'Anti+$bonus';
  }

  @override
  String get equip => 'équipement';

  @override
  String get use => 'utiliser';

  @override
  String get drop => 'jeter';

  @override
  String get combatAttack => 'attaque';

  @override
  String get combatSkill => 'Compétence';

  @override
  String get combatItem => 'Accessoires';

  @override
  String get combatDefend => 'défense';

  @override
  String get combatMelee => 'Mêlée';

  @override
  String get combatFlee => 'fuyez';

  @override
  String get combatAttackShort => 'attaque';

  @override
  String get combatSkillShort => 'technologie';

  @override
  String get combatItemShort => 'route';

  @override
  String get combatDefendShort => 'Défendre';

  @override
  String get combatFleeShort => 's\'échapper';

  @override
  String get combatCommandsTitle => 'Commandes';

  @override
  String get combatExecute => 'mettre en œuvre';

  @override
  String get combatVictory => 'victoire au combat';

  @override
  String get combatVictoryTap => 'Cliquez pour continuer';

  @override
  String get combatDefeated => 'battre';

  @override
  String get combatLoot => 'butin';

  @override
  String get combatHarvest => 'Récolte';

  @override
  String combatGoldGain(int gold) {
    return '💰 Pièce d\'or +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ Expérience +$exp';
  }

  @override
  String get combatNoItems =>
      'Il n\'y a aucun objet de combat disponible dans le sac à dos';

  @override
  String get combatPickItem => 'Sélectionnez les articles d\'accessoires';

  @override
  String get combatInitiative => 'Initiative de séquence d’actions';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return 'Bit $index $name Vitesse $speed';
  }

  @override
  String get combatLogTitle => 'Rapport de bataille';

  @override
  String combatRound(int round) {
    return 'Rond $round';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return 'Sélectionnez la commande : $name';
  }

  @override
  String get combatPhasePickCommand => 'Sélectionnez la commande';

  @override
  String get combatPhasePickTarget => 'Sélectionnez la cible';

  @override
  String get combatPhasePickItem => 'Choisissez des accessoires et des cibles';

  @override
  String get combatPhaseReady => 'Prêt à exécuter le tour';

  @override
  String get combatPhaseAnimating => 'Tour en cours…';

  @override
  String get combatQueueTitle => 'Commandes de la file d\'attente de commandes';

  @override
  String get combatQueuePending => 'A sélectionner…';

  @override
  String get combatEnemies => 'Ennemis Ennemis';

  @override
  String get combatParty => 'Fête d\'équipe';

  @override
  String get combatTitle => 'Combat au tour par tour';

  @override
  String get combatMenuSemantics => 'menu de bataille';

  @override
  String get combatEnded => 'La bataille est terminée';

  @override
  String get meleeEnded => 'La mêlée se termine.';

  @override
  String get meleeCancelled => 'La mêlée a été annulée.';

  @override
  String get enemyGeneric => 'ennemi';

  @override
  String get cmdLook => 'Vérifier';

  @override
  String get cmdBag => 'Sac à dos';

  @override
  String get cmdTalk => 'dialogue';

  @override
  String get cmdHeal => 'traiter';

  @override
  String get cmdRecruit => 'recruter';

  @override
  String get cmdParty => 'équipe';

  @override
  String get cmdScore => 'Score';

  @override
  String get cmdHelp => 'aide';

  @override
  String get cmdNgPlus => 'Deuxième semaine';

  @override
  String get cmdMore => 'Plus';

  @override
  String get cmdTake => 'ramasser';

  @override
  String get cmdBuy => 'Acheter';

  @override
  String get cmdSell => 'vendre';

  @override
  String get cmdShop => 'marchandise';

  @override
  String get cmdMoreTitle => 'Plus de commandes · Plus';

  @override
  String get cmdMoreSemantics => 'Plus de commandes';

  @override
  String get cmdTakeTitle => 'prendre prendre';

  @override
  String get cmdBuyTitle => 'acheter acheter';

  @override
  String get cmdSellTitle => 'vendre vendre';

  @override
  String get cmdTakeAll => 'tout tout';

  @override
  String get cmdMapOn => 'carte';

  @override
  String get cmdMapOff => 'Carte·Guan';

  @override
  String get cmdToggleMap => 'Changer de carte';

  @override
  String get cmdDevMapOn => 'Ouvrez l\'image entière';

  @override
  String get cmdDevMapOff => 'Niveau de carte complet';

  @override
  String get cmdSend => 'Envoyer la commande';

  @override
  String get cmdHint => 'Commande cmd : regarder/prendre 1/n…';

  @override
  String get dirNorth => 'Nord N';

  @override
  String get dirWest => 'Ouest W';

  @override
  String get dirEast => 'Est E';

  @override
  String get dirSouth => 'Sud S';

  @override
  String get dirUp => 'Jusqu\'à toi';

  @override
  String get dirDown => 'Suivant D';

  @override
  String get mapHint =>
      'Faites glisser et déplacez · Molette de défilement/pincer pour zoomer · Cliquez sur les nœuds adjacents pour vous déplacer';

  @override
  String mapFullCount(int count) {
    return 'Image complète $count';
  }

  @override
  String mapExploredCount(int count) {
    return 'Exploré $count';
  }

  @override
  String get mapCannotMoveInCombat => 'Incapable de bouger pendant le combat.';

  @override
  String mapGoing(String dir) {
    return 'Allez à $dir…';
  }

  @override
  String get mapDevFullMap => 'DEV·Image complète';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name — non adjacent, non directement accessible';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name (ici)';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · Poids $weight/$capacity · $count pièces · 💰$gold';
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
    return '$name HP $hp/$maxHp Attaque $atk Défense $def Vitesse $spd';
  }

  @override
  String get creditQa => 'Assurance qualité';

  @override
  String get creditPresentedBy => 'Produit / Présenté par';

  @override
  String get creditDirectedBy => 'Réalisateur / Réalisé par';

  @override
  String get creditWrittenBy => 'Scénariste/Écrit par';

  @override
  String get creditGameDesign => 'Conception de jeux / Conception de jeux';

  @override
  String get creditNarrativeDesign =>
      'Conception narrative / Conception narrative';

  @override
  String get creditArtDirection =>
      'Direction artistique / Direction artistique';

  @override
  String get creditLevelDesign =>
      'Conception de niveaux / Conception de niveaux';

  @override
  String get creditSystemsDesign =>
      'Conception de systèmes / Conception de systèmes';

  @override
  String get creditCombatDesign =>
      'Conception de combat / Conception de combat';

  @override
  String get creditSoundConcept => 'Concept sonore / Concept sonore';

  @override
  String get creditProducedBy => 'Producteur / Produit par';

  @override
  String get creditEngineering => 'Programme / Ingénierie';

  @override
  String get creditSpecialThanks =>
      'Remerciements spéciaux / Remerciements spéciaux';

  @override
  String get creditTechSupport => 'Support technique/Support technologique';
}
