// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Torre de las Nieblas';

  @override
  String get appTitleEn => 'TORRE DE NIEBLA';

  @override
  String get taglineShort =>
      'Explora, recopila, habla, lucha: recupera la verdad perdida.';

  @override
  String get taglineFull =>
      'Te despiertas de un bosque de niebla sin memoria.\nExplora, recopila, habla, lucha: recupera la verdad perdida.';

  @override
  String get homeHint =>
      'Exploración de comandos · Mapa de niebla · Encuentra un enemigo y entra en una ronda de batalla';

  @override
  String get loading => 'cargando…';

  @override
  String get continueJourney => 'Continuar el viaje';

  @override
  String get enterMist => 'entra en la niebla';

  @override
  String get achievements => 'Logro';

  @override
  String get leaderboard => 'lista de clasificación';

  @override
  String get close => 'cierre';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'confirmar';

  @override
  String get skip => 'salte por encima';

  @override
  String get continueAction => 'continuar';

  @override
  String get back => 'devolver';

  @override
  String get menu => 'menú';

  @override
  String get startNewJourneyTitle => '¿Comenzando un nuevo viaje?';

  @override
  String get overwriteSaveMessage =>
      'Ya hay avances en este espacio. Iniciar un nuevo juego sobrescribirá este guardado. ¿Quieres continuar?';

  @override
  String get overwriteAndStart => 'Cubrir y empezar';

  @override
  String get connectPlayGamesTitle => 'Conectar Jugar Juegos';

  @override
  String get connectPlayGamesMessage =>
      'Conéctese a Google Play Games para ver logros y tablas de clasificación. Puedes jugar normalmente sin conectarte.';

  @override
  String get connectLater => 'Hablaré contigo más tarde';

  @override
  String get connectNow => 'Conéctate ahora';

  @override
  String get returnToTitleTitle => '¿Devolver título?';

  @override
  String get returnToTitleMessage =>
      'El progreso actual se ha guardado automáticamente y se puede restaurar desde la página de título \"Continuar viaje\".';

  @override
  String get returnToTitle => 'título de devolución';

  @override
  String get quitAppTitle => '¿Salir del juego?';

  @override
  String get quitAppMessage => 'La Torre de la Niebla estará cerrada.';

  @override
  String get quit => 'abandonar';

  @override
  String get combatPauseTitle => 'Menú de batalla · Pausa';

  @override
  String get resumeCombat => 'sigue luchando';

  @override
  String get backToTitle => 'Volver al título';

  @override
  String get privacySettings => 'Configuración de privacidad';

  @override
  String get privacySettingsHint => 'Configuración de privacidad · privacidad';

  @override
  String get rewardOfferTitle => 'Regalo de la niebla';

  @override
  String rewardOfferGold(int base, int doubled) {
    return 'Monedas de oro en este juego +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable =>
      'Los regalos no están disponibles temporalmente, puedes continuar la aventura directamente';

  @override
  String get rewardOfferWatch => 'Ver anuncios · Monedas de oro dobles';

  @override
  String get rewardOfferLoading => 'Regalos de invocación...';

  @override
  String get continueAdventure => 'continúa la aventura';

  @override
  String get watchAd => 'Ver anuncios';

  @override
  String get watchAdRecoverLoss => 'Ver anuncios · Recuperar pérdidas';

  @override
  String refundScorePoints(int points) {
    return 'Devolver $points puntos';
  }

  @override
  String get summoningGlimmer => 'Invocando en el crepúsculo…';

  @override
  String get glimmerNoResponse =>
      'Shimmer aún no ha respondido, inténtalo de nuevo más tarde.';

  @override
  String get endingDragonTitle => 'El joven dragón ha caído';

  @override
  String get endingDragonSubtitle =>
      'La gema mágica cae en tus manos.\nNo sólo puede abrir la puerta de piedra del cementerio al refugio, sino también recordar recuerdos perdidos en la cima de la torre.';

  @override
  String get endingDragonPrimary => 'continúa la aventura';

  @override
  String get endingDragonSecondary => 'Regresar para completar el viaje.';

  @override
  String get endingMainTitle => 'La niebla se disipa';

  @override
  String get endingMainSubtitle =>
      'Los recuerdos volvieron a su mente y la barrera de la torre se derrumbó.\nEres libre, pero todavía hay asuntos pendientes en lo profundo del asilo.';

  @override
  String get endingMainPrimary => 'Sigue explorando';

  @override
  String get endingSiteTitle => 'Acción del sitio completada';

  @override
  String get endingSiteSubtitle =>
      'El prototipo final ha sido suprimido y la bóveda de contención ha quedado en silencio.\nUn largo viaje está llegando a su fin.';

  @override
  String get endingSitePrimary => 'Ver lista de personal';

  @override
  String get endingGameOverTitle => 'te caíste';

  @override
  String get endingGameOverSubtitle =>
      'La niebla se traga tu figura.\nTe despiertas en el último lugar que exploraste, con una puntuación de -100 (nada menos que 0).';

  @override
  String get endingGameOverPrimary => 'despierta en el último lugar';

  @override
  String get inventoryTitle => 'Mochila · Inventario';

  @override
  String get inventoryUseTitle => 'Usar accesorios · Usar';

  @override
  String get inventoryDropTitle => 'Soltar accesorios · Soltar';

  @override
  String get teleportTitle => 'Enviar a · Teletransportar';

  @override
  String get notLoaded => 'Aún no cargado';

  @override
  String get noUsableItems => 'No hay accesorios disponibles.';

  @override
  String get noDroppableItems => 'No hay accesorios que tirar.';

  @override
  String get inventoryEmpty => 'La mochila está vacía.';

  @override
  String get noMoreDescription => 'Sin más descripción.';

  @override
  String itemType(String type) {
    return 'Escriba $type';
  }

  @override
  String itemWeight(int weight) {
    return 'Peso $weight';
  }

  @override
  String itemValue(int value) {
    return 'Valor $value';
  }

  @override
  String itemHeal(int heal) {
    return 'Tratamiento +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return 'Ataque +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return 'Defensa +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return 'Capacidad $capacity';
  }

  @override
  String itemCount(int count) {
    return 'Cantidad x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return 'Efecto de uso: $msg';
  }

  @override
  String statAtkShort(int bonus) {
    return 'Ataque+$bonus';
  }

  @override
  String statDefShort(int bonus) {
    return 'Anti+$bonus';
  }

  @override
  String get equip => 'equipo';

  @override
  String get use => 'usar';

  @override
  String get drop => 'tirar a la basura';

  @override
  String get combatAttack => 'ataque';

  @override
  String get combatSkill => 'Habilidad';

  @override
  String get combatItem => 'Accesorios';

  @override
  String get combatDefend => 'defensa';

  @override
  String get combatMelee => 'Pelea confusa';

  @override
  String get combatFlee => 'huir';

  @override
  String get combatAttackShort => 'ataque';

  @override
  String get combatSkillShort => 'tecnología';

  @override
  String get combatItemShort => 'camino';

  @override
  String get combatDefendShort => 'Defender';

  @override
  String get combatFleeShort => 'escapar';

  @override
  String get combatCommandsTitle => 'Comandos';

  @override
  String get combatExecute => 'implementar';

  @override
  String get combatVictory => 'victoria de batalla';

  @override
  String get combatVictoryTap => 'Haga clic para continuar';

  @override
  String get combatDefeated => 'derrotar';

  @override
  String get combatLoot => 'botín';

  @override
  String get combatHarvest => 'Cosecha';

  @override
  String combatGoldGain(int gold) {
    return '💰 Moneda de oro +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ Experiencia +$exp';
  }

  @override
  String get combatNoItems =>
      'No hay elementos de combate disponibles en la mochila.';

  @override
  String get combatPickItem => 'Seleccionar elementos de accesorios';

  @override
  String get combatInitiative => 'Iniciativa de secuencia de acción';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return 'Bit $index $name Velocidad $speed';
  }

  @override
  String get combatLogTitle => 'Registro de informe de batalla';

  @override
  String combatRound(int round) {
    return 'Ronda $round';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return 'Seleccionar comando: $name';
  }

  @override
  String get combatPhasePickCommand => 'Seleccionar comando';

  @override
  String get combatPhasePickTarget => 'Seleccionar objetivo';

  @override
  String get combatPhasePickItem => 'Elige accesorios y objetivos.';

  @override
  String get combatPhaseReady => 'Listo para ejecutar ronda';

  @override
  String get combatPhaseAnimating => 'Ronda en progreso…';

  @override
  String get combatQueueTitle => 'Comandos de la cola de comandos';

  @override
  String get combatQueuePending => 'Para ser seleccionado…';

  @override
  String get combatEnemies => 'enemigos enemigos';

  @override
  String get combatParty => 'Fiesta del equipo';

  @override
  String get combatTitle => 'Combate por turnos';

  @override
  String get combatMenuSemantics => 'menú de batalla';

  @override
  String get combatEnded => 'La batalla ha terminado';

  @override
  String get meleeEnded => 'El tumulto termina.';

  @override
  String get meleeCancelled => 'Cuerpo a cuerpo ha sido cancelado.';

  @override
  String get enemyGeneric => 'enemigo';

  @override
  String get cmdLook => 'Controlar';

  @override
  String get cmdBag => 'Mochila';

  @override
  String get cmdTalk => 'diálogo';

  @override
  String get cmdHeal => 'tratar';

  @override
  String get cmdRecruit => 'recluta';

  @override
  String get cmdParty => 'equipo';

  @override
  String get cmdScore => 'Puntaje';

  @override
  String get cmdHelp => 'ayuda';

  @override
  String get cmdNgPlus => 'Segunda semana';

  @override
  String get cmdMore => 'Más';

  @override
  String get cmdTake => 'levantar';

  @override
  String get cmdBuy => 'Comprar';

  @override
  String get cmdSell => 'vender';

  @override
  String get cmdShop => 'producto';

  @override
  String get cmdMoreTitle => 'Más comandos · Más';

  @override
  String get cmdMoreSemantics => 'Más comandos';

  @override
  String get cmdTakeTitle => 'recoger tomar';

  @override
  String get cmdBuyTitle => 'comprar comprar';

  @override
  String get cmdSellTitle => 'vender vender';

  @override
  String get cmdTakeAll => 'todos todos';

  @override
  String get cmdMapOn => 'mapa';

  @override
  String get cmdMapOff => 'Mapa·Guan';

  @override
  String get cmdToggleMap => 'Cambiar mapa';

  @override
  String get cmdDevMapOn => 'Abre la imagen completa';

  @override
  String get cmdDevMapOff => 'Nivel de mapa completo';

  @override
  String get cmdSend => 'enviar comando';

  @override
  String get cmdHint => 'Comando cmd: mirar/tomar 1/n…';

  @override
  String get dirNorth => 'norte norte';

  @override
  String get dirWest => 'Oeste Oeste';

  @override
  String get dirEast => 'este este';

  @override
  String get dirSouth => 'sur sur';

  @override
  String get dirUp => 'Arriba U';

  @override
  String get dirDown => 'Siguiente D';

  @override
  String get mapHint =>
      'Arrastrar y desplazar · Rueda de desplazamiento/pellizcar para hacer zoom · Haga clic en los nodos adyacentes para moverse';

  @override
  String mapFullCount(int count) {
    return 'Imagen completa $count';
  }

  @override
  String mapExploredCount(int count) {
    return 'Explorado $count';
  }

  @override
  String get mapCannotMoveInCombat => 'Incapaz de moverse durante el combate.';

  @override
  String mapGoing(String dir) {
    return 'Ir a $dir…';
  }

  @override
  String get mapDevFullMap => 'DEV·Imagen completa';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name — no adyacente, no accesible directamente';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name (aquí)';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · Peso $weight/$capacity · $count piezas · 💰$gold';
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
    return '$name HP $hp/$maxHp Ataque $atk Defensa $def Velocidad $spd';
  }

  @override
  String get creditQa => 'Seguro de calidad';

  @override
  String get creditPresentedBy => 'Producido / Presentado por';

  @override
  String get creditDirectedBy => 'Director/Dirigido por';

  @override
  String get creditWrittenBy => 'Guionista/Escrito por';

  @override
  String get creditGameDesign => 'Diseño de juegos / Diseño de juegos';

  @override
  String get creditNarrativeDesign => 'Diseño Narrativo / Diseño Narrativo';

  @override
  String get creditArtDirection => 'Dirección de Arte / Dirección de Arte';

  @override
  String get creditLevelDesign => 'Diseño de niveles / Diseño de niveles';

  @override
  String get creditSystemsDesign => 'Diseño de Sistemas / Diseño de Sistemas';

  @override
  String get creditCombatDesign => 'Diseño de combate / Diseño de combate';

  @override
  String get creditSoundConcept => 'Concepto de sonido / Concepto de sonido';

  @override
  String get creditProducedBy => 'Productor / Producido por';

  @override
  String get creditEngineering => 'Programa / Ingeniería';

  @override
  String get creditSpecialThanks =>
      'Agradecimiento Especial / Agradecimiento Especial';

  @override
  String get creditTechSupport => 'Soporte Técnico / Soporte Tecnológico';
}

/// The translations for Spanish Castilian, as used in Spain (`es_ES`).
class AppLocalizationsEsEs extends AppLocalizationsEs {
  AppLocalizationsEsEs() : super('es_ES');

  @override
  String get appTitle => 'Torre de las Nieblas';

  @override
  String get appTitleEn => 'TORRE DE NIEBLA';

  @override
  String get taglineShort =>
      'Explora, recopila, habla, lucha: recupera la verdad perdida.';

  @override
  String get taglineFull =>
      'Te despiertas de un bosque de niebla sin memoria.\nExplora, recopila, habla, lucha: recupera la verdad perdida.';

  @override
  String get homeHint =>
      'Exploración de comandos · Mapa de niebla · Encuentra un enemigo y entra en una ronda de batalla';

  @override
  String get loading => 'cargando…';

  @override
  String get continueJourney => 'Continuar el viaje';

  @override
  String get enterMist => 'entra en la niebla';

  @override
  String get achievements => 'Logro';

  @override
  String get leaderboard => 'lista de clasificación';

  @override
  String get close => 'cierre';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'confirmar';

  @override
  String get skip => 'salte por encima';

  @override
  String get continueAction => 'continuar';

  @override
  String get back => 'devolver';

  @override
  String get menu => 'menú';

  @override
  String get startNewJourneyTitle => '¿Comenzando un nuevo viaje?';

  @override
  String get overwriteSaveMessage =>
      'Ya hay avances en este espacio. Iniciar un nuevo juego sobrescribirá este guardado. ¿Quieres continuar?';

  @override
  String get overwriteAndStart => 'Cubrir y empezar';

  @override
  String get connectPlayGamesTitle => 'Conectar Jugar Juegos';

  @override
  String get connectPlayGamesMessage =>
      'Conéctese a Google Play Games para ver logros y tablas de clasificación. Puedes jugar normalmente sin conectarte.';

  @override
  String get connectLater => 'Hablaré contigo más tarde';

  @override
  String get connectNow => 'Conéctate ahora';

  @override
  String get returnToTitleTitle => '¿Devolver título?';

  @override
  String get returnToTitleMessage =>
      'El progreso actual se ha guardado automáticamente y se puede restaurar desde la página de título \"Continuar viaje\".';

  @override
  String get returnToTitle => 'título de devolución';

  @override
  String get quitAppTitle => '¿Salir del juego?';

  @override
  String get quitAppMessage => 'La Torre de la Niebla estará cerrada.';

  @override
  String get quit => 'abandonar';

  @override
  String get combatPauseTitle => 'Menú de batalla · Pausa';

  @override
  String get resumeCombat => 'sigue luchando';

  @override
  String get backToTitle => 'Volver al título';

  @override
  String get privacySettings => 'Configuración de privacidad';

  @override
  String get privacySettingsHint => 'Configuración de privacidad · privacidad';

  @override
  String get rewardOfferTitle => 'Regalo de la niebla';

  @override
  String rewardOfferGold(int base, int doubled) {
    return 'Monedas de oro en este juego +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable =>
      'Los regalos no están disponibles temporalmente, puedes continuar la aventura directamente';

  @override
  String get rewardOfferWatch => 'Ver anuncios · Monedas de oro dobles';

  @override
  String get rewardOfferLoading => 'Regalos de invocación...';

  @override
  String get continueAdventure => 'continúa la aventura';

  @override
  String get watchAd => 'Ver anuncios';

  @override
  String get watchAdRecoverLoss => 'Ver anuncios · Recuperar pérdidas';

  @override
  String refundScorePoints(int points) {
    return 'Devolver $points puntos';
  }

  @override
  String get summoningGlimmer => 'Invocando en el crepúsculo…';

  @override
  String get glimmerNoResponse =>
      'Shimmer aún no ha respondido, inténtalo de nuevo más tarde.';

  @override
  String get endingDragonTitle => 'El joven dragón ha caído';

  @override
  String get endingDragonSubtitle =>
      'La gema mágica cae en tus manos.\nNo sólo puede abrir la puerta de piedra del cementerio al refugio, sino también recordar recuerdos perdidos en la cima de la torre.';

  @override
  String get endingDragonPrimary => 'continúa la aventura';

  @override
  String get endingDragonSecondary => 'Regresar para completar el viaje.';

  @override
  String get endingMainTitle => 'La niebla se disipa';

  @override
  String get endingMainSubtitle =>
      'Los recuerdos volvieron a su mente y la barrera de la torre se derrumbó.\nEres libre, pero todavía hay asuntos pendientes en lo profundo del asilo.';

  @override
  String get endingMainPrimary => 'Sigue explorando';

  @override
  String get endingSiteTitle => 'Acción del sitio completada';

  @override
  String get endingSiteSubtitle =>
      'El prototipo final ha sido suprimido y la bóveda de contención ha quedado en silencio.\nUn largo viaje está llegando a su fin.';

  @override
  String get endingSitePrimary => 'Ver lista de personal';

  @override
  String get endingGameOverTitle => 'te caíste';

  @override
  String get endingGameOverSubtitle =>
      'La niebla se traga tu figura.\nTe despiertas en el último lugar que exploraste, con una puntuación de -100 (nada menos que 0).';

  @override
  String get endingGameOverPrimary => 'despierta en el último lugar';

  @override
  String get inventoryTitle => 'Mochila · Inventario';

  @override
  String get inventoryUseTitle => 'Usar accesorios · Usar';

  @override
  String get inventoryDropTitle => 'Soltar accesorios · Soltar';

  @override
  String get teleportTitle => 'Enviar a · Teletransportar';

  @override
  String get notLoaded => 'Aún no cargado';

  @override
  String get noUsableItems => 'No hay accesorios disponibles.';

  @override
  String get noDroppableItems => 'No hay accesorios que tirar.';

  @override
  String get inventoryEmpty => 'La mochila está vacía.';

  @override
  String get noMoreDescription => 'Sin más descripción.';

  @override
  String itemType(String type) {
    return 'Escriba $type';
  }

  @override
  String itemWeight(int weight) {
    return 'Peso $weight';
  }

  @override
  String itemValue(int value) {
    return 'Valor $value';
  }

  @override
  String itemHeal(int heal) {
    return 'Tratamiento +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return 'Ataque +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return 'Defensa +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return 'Capacidad $capacity';
  }

  @override
  String itemCount(int count) {
    return 'Cantidad x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return 'Efecto de uso: $msg';
  }

  @override
  String statAtkShort(int bonus) {
    return 'Ataque+$bonus';
  }

  @override
  String statDefShort(int bonus) {
    return 'Anti+$bonus';
  }

  @override
  String get equip => 'equipo';

  @override
  String get use => 'usar';

  @override
  String get drop => 'tirar a la basura';

  @override
  String get combatAttack => 'ataque';

  @override
  String get combatSkill => 'Habilidad';

  @override
  String get combatItem => 'Accesorios';

  @override
  String get combatDefend => 'defensa';

  @override
  String get combatMelee => 'Pelea confusa';

  @override
  String get combatFlee => 'huir';

  @override
  String get combatAttackShort => 'ataque';

  @override
  String get combatSkillShort => 'tecnología';

  @override
  String get combatItemShort => 'camino';

  @override
  String get combatDefendShort => 'Defender';

  @override
  String get combatFleeShort => 'escapar';

  @override
  String get combatCommandsTitle => 'Comandos';

  @override
  String get combatExecute => 'implementar';

  @override
  String get combatVictory => 'victoria de batalla';

  @override
  String get combatVictoryTap => 'Haga clic para continuar';

  @override
  String get combatDefeated => 'derrotar';

  @override
  String get combatLoot => 'botín';

  @override
  String get combatHarvest => 'Cosecha';

  @override
  String combatGoldGain(int gold) {
    return '💰 Moneda de oro +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ Experiencia +$exp';
  }

  @override
  String get combatNoItems =>
      'No hay elementos de combate disponibles en la mochila.';

  @override
  String get combatPickItem => 'Seleccionar elementos de accesorios';

  @override
  String get combatInitiative => 'Iniciativa de secuencia de acción';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return 'Bit $index $name Velocidad $speed';
  }

  @override
  String get combatLogTitle => 'Registro de informe de batalla';

  @override
  String combatRound(int round) {
    return 'Ronda $round';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return 'Seleccionar comando: $name';
  }

  @override
  String get combatPhasePickCommand => 'Seleccionar comando';

  @override
  String get combatPhasePickTarget => 'Seleccionar objetivo';

  @override
  String get combatPhasePickItem => 'Elige accesorios y objetivos.';

  @override
  String get combatPhaseReady => 'Listo para ejecutar ronda';

  @override
  String get combatPhaseAnimating => 'Ronda en progreso…';

  @override
  String get combatQueueTitle => 'Comandos de la cola de comandos';

  @override
  String get combatQueuePending => 'Para ser seleccionado…';

  @override
  String get combatEnemies => 'enemigos enemigos';

  @override
  String get combatParty => 'Fiesta del equipo';

  @override
  String get combatTitle => 'Combate por turnos';

  @override
  String get combatMenuSemantics => 'menú de batalla';

  @override
  String get combatEnded => 'La batalla ha terminado';

  @override
  String get meleeEnded => 'El tumulto termina.';

  @override
  String get meleeCancelled => 'Cuerpo a cuerpo ha sido cancelado.';

  @override
  String get enemyGeneric => 'enemigo';

  @override
  String get cmdLook => 'Controlar';

  @override
  String get cmdBag => 'Mochila';

  @override
  String get cmdTalk => 'diálogo';

  @override
  String get cmdHeal => 'tratar';

  @override
  String get cmdRecruit => 'recluta';

  @override
  String get cmdParty => 'equipo';

  @override
  String get cmdScore => 'Puntaje';

  @override
  String get cmdHelp => 'ayuda';

  @override
  String get cmdNgPlus => 'Segunda semana';

  @override
  String get cmdMore => 'Más';

  @override
  String get cmdTake => 'levantar';

  @override
  String get cmdBuy => 'Comprar';

  @override
  String get cmdSell => 'vender';

  @override
  String get cmdShop => 'producto';

  @override
  String get cmdMoreTitle => 'Más comandos · Más';

  @override
  String get cmdMoreSemantics => 'Más comandos';

  @override
  String get cmdTakeTitle => 'recoger tomar';

  @override
  String get cmdBuyTitle => 'comprar comprar';

  @override
  String get cmdSellTitle => 'vender vender';

  @override
  String get cmdTakeAll => 'todos todos';

  @override
  String get cmdMapOn => 'mapa';

  @override
  String get cmdMapOff => 'Mapa·Guan';

  @override
  String get cmdToggleMap => 'Cambiar mapa';

  @override
  String get cmdDevMapOn => 'Abre la imagen completa';

  @override
  String get cmdDevMapOff => 'Nivel de mapa completo';

  @override
  String get cmdSend => 'enviar comando';

  @override
  String get cmdHint => 'Comando cmd: mirar/tomar 1/n…';

  @override
  String get dirNorth => 'norte norte';

  @override
  String get dirWest => 'Oeste Oeste';

  @override
  String get dirEast => 'este este';

  @override
  String get dirSouth => 'sur sur';

  @override
  String get dirUp => 'Arriba U';

  @override
  String get dirDown => 'Siguiente D';

  @override
  String get mapHint =>
      'Arrastrar y desplazar · Rueda de desplazamiento/pellizcar para hacer zoom · Haga clic en los nodos adyacentes para moverse';

  @override
  String mapFullCount(int count) {
    return 'Imagen completa $count';
  }

  @override
  String mapExploredCount(int count) {
    return 'Explorado $count';
  }

  @override
  String get mapCannotMoveInCombat => 'Incapaz de moverse durante el combate.';

  @override
  String mapGoing(String dir) {
    return 'Ir a $dir…';
  }

  @override
  String get mapDevFullMap => 'DEV·Imagen completa';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name — no adyacente, no accesible directamente';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name (aquí)';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · Peso $weight/$capacity · $count piezas · 💰$gold';
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
    return '$name HP $hp/$maxHp Ataque $atk Defensa $def Velocidad $spd';
  }

  @override
  String get creditQa => 'Seguro de calidad';

  @override
  String get creditPresentedBy => 'Producido / Presentado por';

  @override
  String get creditDirectedBy => 'Director/Dirigido por';

  @override
  String get creditWrittenBy => 'Guionista/Escrito por';

  @override
  String get creditGameDesign => 'Diseño de juegos / Diseño de juegos';

  @override
  String get creditNarrativeDesign => 'Diseño Narrativo / Diseño Narrativo';

  @override
  String get creditArtDirection => 'Dirección de Arte / Dirección de Arte';

  @override
  String get creditLevelDesign => 'Diseño de niveles / Diseño de niveles';

  @override
  String get creditSystemsDesign => 'Diseño de Sistemas / Diseño de Sistemas';

  @override
  String get creditCombatDesign => 'Diseño de combate / Diseño de combate';

  @override
  String get creditSoundConcept => 'Concepto de sonido / Concepto de sonido';

  @override
  String get creditProducedBy => 'Productor / Producido por';

  @override
  String get creditEngineering => 'Programa / Ingeniería';

  @override
  String get creditSpecialThanks =>
      'Agradecimiento Especial / Agradecimiento Especial';

  @override
  String get creditTechSupport => 'Soporte Técnico / Soporte Tecnológico';
}
