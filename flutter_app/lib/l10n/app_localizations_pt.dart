// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Torre das Brumas';

  @override
  String get appTitleEn => 'TORRE DE NÉVOA';

  @override
  String get taglineShort =>
      'Explore, colete, converse, lute – recupere a verdade perdida.';

  @override
  String get taglineFull =>
      'Você acorda de uma floresta nebulosa sem memória.\nExplore, colete, converse, lute – recupere a verdade perdida.';

  @override
  String get homeHint =>
      'Exploração de comando · Mapa de neblina · Encontre um inimigo e entre em uma rodada de batalha';

  @override
  String get loading => 'carregando…';

  @override
  String get continueJourney => 'Continue a jornada';

  @override
  String get enterMist => 'Entre na neblina';

  @override
  String get achievements => 'Conquista';

  @override
  String get leaderboard => 'Lista de classificação';

  @override
  String get close => 'encerramento';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'confirmar';

  @override
  String get skip => 'pular sobre';

  @override
  String get continueAction => 'continuar';

  @override
  String get back => 'retornar';

  @override
  String get menu => 'menu';

  @override
  String get startNewJourneyTitle => 'Iniciando uma nova jornada?';

  @override
  String get overwriteSaveMessage =>
      'Já há progresso neste slot. Iniciar um novo jogo substituirá este salvamento. Você quer continuar?';

  @override
  String get overwriteAndStart => 'Cubra e comece';

  @override
  String get connectPlayGamesTitle => 'Conecte-se para jogar jogos';

  @override
  String get connectPlayGamesMessage =>
      'Conecte-se ao Google Play Games para ver conquistas e placares. Você pode jogar normalmente sem conectar.';

  @override
  String get connectLater => 'Falo com você mais tarde';

  @override
  String get connectNow => 'Conecte-se agora';

  @override
  String get returnToTitleTitle => 'Título de retorno?';

  @override
  String get returnToTitleMessage =>
      'O progresso atual foi salvo automaticamente e pode ser restaurado na página de título \"Continuar jornada\".';

  @override
  String get returnToTitle => 'retornar título';

  @override
  String get quitAppTitle => 'Sair do jogo?';

  @override
  String get quitAppMessage => 'A Torre da Névoa estará fechada.';

  @override
  String get quit => 'desistir';

  @override
  String get combatPauseTitle => 'Menu de batalha · Pausa';

  @override
  String get resumeCombat => 'continue lutando';

  @override
  String get backToTitle => 'Voltar ao título';

  @override
  String get privacySettings => 'Configurações de privacidade';

  @override
  String get privacySettingsHint =>
      'Configurações de privacidade · privacidade';

  @override
  String get rewardOfferTitle => 'Presente da Névoa';

  @override
  String rewardOfferGold(int base, int doubled) {
    return 'Moedas de ouro neste jogo +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable =>
      'Os presentes estão temporariamente indisponíveis, você pode continuar a aventura diretamente';

  @override
  String get rewardOfferWatch => 'Assistir anúncios · Moedas de ouro duplas';

  @override
  String get rewardOfferLoading => 'Invocando presentes...';

  @override
  String get continueAdventure => 'continuar a aventura';

  @override
  String get watchAd => 'Assistir anúncios';

  @override
  String get watchAdRecoverLoss => 'Assistir anúncios · Recuperar perdas';

  @override
  String refundScorePoints(int points) {
    return 'Retornar $points pontos';
  }

  @override
  String get summoningGlimmer => 'Invocando no crepúsculo…';

  @override
  String get glimmerNoResponse =>
      'Shimmer ainda não respondeu, tente novamente mais tarde.';

  @override
  String get endingDragonTitle => 'O jovem dragão caiu';

  @override
  String get endingDragonSubtitle =>
      'A joia mágica cai em suas mãos.\nPode não só abrir a porta de pedra do cemitério ao abrigo, mas também relembrar memórias perdidas no topo da torre.';

  @override
  String get endingDragonPrimary => 'continuar a aventura';

  @override
  String get endingDragonSecondary => 'Voltar para completar a viagem';

  @override
  String get endingMainTitle => 'A neblina se dissipa';

  @override
  String get endingMainSubtitle =>
      'As memórias voltaram à sua mente e a barreira da torre desabou.\nVocê está livre, mas ainda há assuntos inacabados no asilo.';

  @override
  String get endingMainPrimary => 'Continue explorando';

  @override
  String get endingSiteTitle => 'Ação do site concluída';

  @override
  String get endingSiteSubtitle =>
      'O protótipo final foi suprimido e o cofre de contenção ficou em silêncio.\nUma longa jornada está chegando ao fim.';

  @override
  String get endingSitePrimary => 'Ver lista de funcionários';

  @override
  String get endingGameOverTitle => 'você caiu';

  @override
  String get endingGameOverSubtitle =>
      'A névoa engole sua figura.\nVocê acorda no último local que explorou, com pontuação de -100 (não menos que 0).';

  @override
  String get endingGameOverPrimary => 'acorde no último lugar';

  @override
  String get inventoryTitle => 'Mochila · Inventário';

  @override
  String get inventoryUseTitle => 'Usar adereços · Usar';

  @override
  String get inventoryDropTitle => 'Soltar adereços · Soltar';

  @override
  String get teleportTitle => 'Enviar para · Teleporte';

  @override
  String get notLoaded => 'Ainda não carregado';

  @override
  String get noUsableItems => 'Não há adereços disponíveis.';

  @override
  String get noDroppableItems => 'Não há adereços para jogar fora.';

  @override
  String get inventoryEmpty => 'A mochila está vazia.';

  @override
  String get noMoreDescription => 'Nenhuma descrição adicional.';

  @override
  String itemType(String type) {
    return 'Digite $type';
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
    return 'Tratamento +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return 'Ataque +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return 'Defesa +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return 'Capacidade $capacity';
  }

  @override
  String itemCount(int count) {
    return 'Quantidade x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return 'Efeito de uso: $msg';
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
  String get equip => 'equipamento';

  @override
  String get use => 'usar';

  @override
  String get drop => 'jogar fora';

  @override
  String get combatAttack => 'ataque';

  @override
  String get combatSkill => 'Habilidade';

  @override
  String get combatItem => 'Adereços';

  @override
  String get combatDefend => 'defesa';

  @override
  String get combatMelee => 'Corpo a corpo';

  @override
  String get combatFlee => 'fugir';

  @override
  String get combatAttackShort => 'ataque';

  @override
  String get combatSkillShort => 'tecnologia';

  @override
  String get combatItemShort => 'estrada';

  @override
  String get combatDefendShort => 'Defender';

  @override
  String get combatFleeShort => 'escapar';

  @override
  String get combatCommandsTitle => 'Comandos';

  @override
  String get combatExecute => 'implementar';

  @override
  String get combatVictory => 'vitória na batalha';

  @override
  String get combatVictoryTap => 'Clique para continuar';

  @override
  String get combatDefeated => 'bater';

  @override
  String get combatLoot => 'saque';

  @override
  String get combatHarvest => 'Colheita';

  @override
  String combatGoldGain(int gold) {
    return '💰 Moeda de Ouro +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ Experiência +$exp';
  }

  @override
  String get combatNoItems => 'Não há itens de combate disponíveis na mochila';

  @override
  String get combatPickItem => 'Selecione itens de adereços';

  @override
  String get combatInitiative => 'Iniciativa de Sequência de Ação';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return 'Bit $index $name Velocidade $speed';
  }

  @override
  String get combatLogTitle => 'Registro de relatório de batalha';

  @override
  String combatRound(int round) {
    return 'Rodada $round';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return 'Selecione o comando: $name';
  }

  @override
  String get combatPhasePickCommand => 'Selecione o comando';

  @override
  String get combatPhasePickTarget => 'Selecione o alvo';

  @override
  String get combatPhasePickItem => 'Escolha adereços e alvos';

  @override
  String get combatPhaseReady => 'Pronto para executar a rodada';

  @override
  String get combatPhaseAnimating => 'Rodada em andamento…';

  @override
  String get combatQueueTitle => 'Comandos da fila de comandos';

  @override
  String get combatQueuePending => 'Para ser selecionado…';

  @override
  String get combatEnemies => 'Inimigos Inimigos';

  @override
  String get combatParty => 'Festa da equipe';

  @override
  String get combatTitle => 'Combate baseado em turnos';

  @override
  String get combatMenuSemantics => 'menu de batalha';

  @override
  String get combatEnded => 'A batalha acabou';

  @override
  String get meleeEnded => 'A confusão termina.';

  @override
  String get meleeCancelled => 'Corpo a corpo foi cancelado.';

  @override
  String get enemyGeneric => 'inimigo';

  @override
  String get cmdLook => 'Verificar';

  @override
  String get cmdBag => 'Mochila';

  @override
  String get cmdTalk => 'diálogo';

  @override
  String get cmdHeal => 'tratar';

  @override
  String get cmdRecruit => 'recrutar';

  @override
  String get cmdParty => 'equipe';

  @override
  String get cmdScore => 'Pontuação';

  @override
  String get cmdHelp => 'ajuda';

  @override
  String get cmdNgPlus => 'Segunda semana';

  @override
  String get cmdMore => 'Mais';

  @override
  String get cmdTake => 'escolher';

  @override
  String get cmdBuy => 'Comprar';

  @override
  String get cmdSell => 'vender';

  @override
  String get cmdShop => 'mercadoria';

  @override
  String get cmdMoreTitle => 'Mais comandos · Mais';

  @override
  String get cmdMoreSemantics => 'Mais comandos';

  @override
  String get cmdTakeTitle => 'pegar, pegar';

  @override
  String get cmdBuyTitle => 'comprar comprar';

  @override
  String get cmdSellTitle => 'vender vender';

  @override
  String get cmdTakeAll => 'tudo tudo';

  @override
  String get cmdMapOn => 'mapa';

  @override
  String get cmdMapOff => 'Mapa·Guan';

  @override
  String get cmdToggleMap => 'Trocar mapa';

  @override
  String get cmdDevMapOn => 'Abra a imagem inteira';

  @override
  String get cmdDevMapOff => 'Nível completo do mapa';

  @override
  String get cmdSend => 'Enviar comando';

  @override
  String get cmdHint => 'Comando cmd: olha / pega 1 / n…';

  @override
  String get dirNorth => 'Norte N';

  @override
  String get dirWest => 'Oeste W';

  @override
  String get dirEast => 'Leste E';

  @override
  String get dirSouth => 'Sul S';

  @override
  String get dirUp => 'Acima de você';

  @override
  String get dirDown => 'Próxima D';

  @override
  String get mapHint =>
      'Arrastar e deslocar · Role a roda/aperte para ampliar · Clique nos nós adjacentes para mover';

  @override
  String mapFullCount(int count) {
    return 'Imagem completa $count';
  }

  @override
  String mapExploredCount(int count) {
    return 'Explorado $count';
  }

  @override
  String get mapCannotMoveInCombat => 'Incapaz de se mover durante o combate.';

  @override
  String mapGoing(String dir) {
    return 'Vá para $dir…';
  }

  @override
  String get mapDevFullMap => 'DEV·Imagem completa';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name — não adjacente, não acessível diretamente';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name (aqui)';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · Peso $weight/$capacity · $count peças · 💰$gold';
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
    return '$name HP $hp/$maxHp Ataque $atk Defesa $def Velocidade $spd';
  }

  @override
  String get creditQa => 'Garantia de Qualidade';

  @override
  String get creditPresentedBy => 'Produzido/Apresentado por';

  @override
  String get creditDirectedBy => 'Diretor / Dirigido por';

  @override
  String get creditWrittenBy => 'Roteirista/Escrito por';

  @override
  String get creditGameDesign => 'Design de Jogos / Design de Jogos';

  @override
  String get creditNarrativeDesign => 'Design Narrativo / Design Narrativo';

  @override
  String get creditArtDirection => 'Direção de Arte / Direção de Arte';

  @override
  String get creditLevelDesign => 'Design de níveis / Design de níveis';

  @override
  String get creditSystemsDesign => 'Projeto de Sistemas / Projeto de Sistemas';

  @override
  String get creditCombatDesign => 'Design de Combate / Design de Combate';

  @override
  String get creditSoundConcept => 'Conceito de Som / Conceito de Som';

  @override
  String get creditProducedBy => 'Produtor / Produzido por';

  @override
  String get creditEngineering => 'Programa / Engenharia';

  @override
  String get creditSpecialThanks =>
      'Agradecimentos Especiais / Agradecimentos Especiais';

  @override
  String get creditTechSupport => 'Suporte Técnico / Suporte Tecnológico';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsBgmEnabled => 'Música de fundo';

  @override
  String get settingsSfxEnabled => 'Efeitos sonoros';

  @override
  String get settingsGearSemantics => 'Configurações';

  @override
  String get settingsMenuLabel => 'Configurações';

  @override
  String get deleteSaveTitle => 'Excluir salvamento?';

  @override
  String get deleteSaveMessage =>
      'O progresso deste slot será excluído permanentemente.';

  @override
  String get deleteSaveConfirm => 'Excluir';

  @override
  String get deleteSaveSemantics => 'Excluir salvamento';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageRestartTitle => 'Alterar idioma';

  @override
  String get languageRestartMessage =>
      'O app precisa reiniciar para carregar o novo idioma. Reiniciar agora?';

  @override
  String get languageRestartConfirm => 'Reiniciar agora';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Torre das Brumas';

  @override
  String get appTitleEn => 'TORRE DE NÉVOA';

  @override
  String get taglineShort =>
      'Explore, colete, converse, lute – recupere a verdade perdida.';

  @override
  String get taglineFull =>
      'Você acorda de uma floresta nebulosa sem memória.\nExplore, colete, converse, lute – recupere a verdade perdida.';

  @override
  String get homeHint =>
      'Exploração de comando · Mapa de neblina · Encontre um inimigo e entre em uma rodada de batalha';

  @override
  String get loading => 'carregando…';

  @override
  String get continueJourney => 'Continue a jornada';

  @override
  String get enterMist => 'Entre na neblina';

  @override
  String get achievements => 'Conquista';

  @override
  String get leaderboard => 'Lista de classificação';

  @override
  String get close => 'encerramento';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'confirmar';

  @override
  String get skip => 'pular sobre';

  @override
  String get continueAction => 'continuar';

  @override
  String get back => 'retornar';

  @override
  String get menu => 'menu';

  @override
  String get startNewJourneyTitle => 'Iniciando uma nova jornada?';

  @override
  String get overwriteSaveMessage =>
      'Já há progresso neste slot. Iniciar um novo jogo substituirá este salvamento. Você quer continuar?';

  @override
  String get overwriteAndStart => 'Cubra e comece';

  @override
  String get connectPlayGamesTitle => 'Conecte-se para jogar jogos';

  @override
  String get connectPlayGamesMessage =>
      'Conecte-se ao Google Play Games para ver conquistas e placares. Você pode jogar normalmente sem conectar.';

  @override
  String get connectLater => 'Falo com você mais tarde';

  @override
  String get connectNow => 'Conecte-se agora';

  @override
  String get returnToTitleTitle => 'Título de retorno?';

  @override
  String get returnToTitleMessage =>
      'O progresso atual foi salvo automaticamente e pode ser restaurado na página de título \"Continuar jornada\".';

  @override
  String get returnToTitle => 'retornar título';

  @override
  String get quitAppTitle => 'Sair do jogo?';

  @override
  String get quitAppMessage => 'A Torre da Névoa estará fechada.';

  @override
  String get quit => 'desistir';

  @override
  String get combatPauseTitle => 'Menu de batalha · Pausa';

  @override
  String get resumeCombat => 'continue lutando';

  @override
  String get backToTitle => 'Voltar ao título';

  @override
  String get privacySettings => 'Configurações de privacidade';

  @override
  String get privacySettingsHint =>
      'Configurações de privacidade · privacidade';

  @override
  String get rewardOfferTitle => 'Presente da Névoa';

  @override
  String rewardOfferGold(int base, int doubled) {
    return 'Moedas de ouro neste jogo +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable =>
      'Os presentes estão temporariamente indisponíveis, você pode continuar a aventura diretamente';

  @override
  String get rewardOfferWatch => 'Assistir anúncios · Moedas de ouro duplas';

  @override
  String get rewardOfferLoading => 'Invocando presentes...';

  @override
  String get continueAdventure => 'continuar a aventura';

  @override
  String get watchAd => 'Assistir anúncios';

  @override
  String get watchAdRecoverLoss => 'Assistir anúncios · Recuperar perdas';

  @override
  String refundScorePoints(int points) {
    return 'Retornar $points pontos';
  }

  @override
  String get summoningGlimmer => 'Invocando no crepúsculo…';

  @override
  String get glimmerNoResponse =>
      'Shimmer ainda não respondeu, tente novamente mais tarde.';

  @override
  String get endingDragonTitle => 'O jovem dragão caiu';

  @override
  String get endingDragonSubtitle =>
      'A joia mágica cai em suas mãos.\nPode não só abrir a porta de pedra do cemitério ao abrigo, mas também relembrar memórias perdidas no topo da torre.';

  @override
  String get endingDragonPrimary => 'continuar a aventura';

  @override
  String get endingDragonSecondary => 'Voltar para completar a viagem';

  @override
  String get endingMainTitle => 'A neblina se dissipa';

  @override
  String get endingMainSubtitle =>
      'As memórias voltaram à sua mente e a barreira da torre desabou.\nVocê está livre, mas ainda há assuntos inacabados no asilo.';

  @override
  String get endingMainPrimary => 'Continue explorando';

  @override
  String get endingSiteTitle => 'Ação do site concluída';

  @override
  String get endingSiteSubtitle =>
      'O protótipo final foi suprimido e o cofre de contenção ficou em silêncio.\nUma longa jornada está chegando ao fim.';

  @override
  String get endingSitePrimary => 'Ver lista de funcionários';

  @override
  String get endingGameOverTitle => 'você caiu';

  @override
  String get endingGameOverSubtitle =>
      'A névoa engole sua figura.\nVocê acorda no último local que explorou, com pontuação de -100 (não menos que 0).';

  @override
  String get endingGameOverPrimary => 'acorde no último lugar';

  @override
  String get inventoryTitle => 'Mochila · Inventário';

  @override
  String get inventoryUseTitle => 'Usar adereços · Usar';

  @override
  String get inventoryDropTitle => 'Soltar adereços · Soltar';

  @override
  String get teleportTitle => 'Enviar para · Teleporte';

  @override
  String get notLoaded => 'Ainda não carregado';

  @override
  String get noUsableItems => 'Não há adereços disponíveis.';

  @override
  String get noDroppableItems => 'Não há adereços para jogar fora.';

  @override
  String get inventoryEmpty => 'A mochila está vazia.';

  @override
  String get noMoreDescription => 'Nenhuma descrição adicional.';

  @override
  String itemType(String type) {
    return 'Digite $type';
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
    return 'Tratamento +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return 'Ataque +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return 'Defesa +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return 'Capacidade $capacity';
  }

  @override
  String itemCount(int count) {
    return 'Quantidade x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return 'Efeito de uso: $msg';
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
  String get equip => 'equipamento';

  @override
  String get use => 'usar';

  @override
  String get drop => 'jogar fora';

  @override
  String get combatAttack => 'ataque';

  @override
  String get combatSkill => 'Habilidade';

  @override
  String get combatItem => 'Adereços';

  @override
  String get combatDefend => 'defesa';

  @override
  String get combatMelee => 'Corpo a corpo';

  @override
  String get combatFlee => 'fugir';

  @override
  String get combatAttackShort => 'ataque';

  @override
  String get combatSkillShort => 'tecnologia';

  @override
  String get combatItemShort => 'estrada';

  @override
  String get combatDefendShort => 'Defender';

  @override
  String get combatFleeShort => 'escapar';

  @override
  String get combatCommandsTitle => 'Comandos';

  @override
  String get combatExecute => 'implementar';

  @override
  String get combatVictory => 'vitória na batalha';

  @override
  String get combatVictoryTap => 'Clique para continuar';

  @override
  String get combatDefeated => 'bater';

  @override
  String get combatLoot => 'saque';

  @override
  String get combatHarvest => 'Colheita';

  @override
  String combatGoldGain(int gold) {
    return '💰 Moeda de Ouro +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ Experiência +$exp';
  }

  @override
  String get combatNoItems => 'Não há itens de combate disponíveis na mochila';

  @override
  String get combatPickItem => 'Selecione itens de adereços';

  @override
  String get combatInitiative => 'Iniciativa de Sequência de Ação';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return 'Bit $index $name Velocidade $speed';
  }

  @override
  String get combatLogTitle => 'Registro de relatório de batalha';

  @override
  String combatRound(int round) {
    return 'Rodada $round';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return 'Selecione o comando: $name';
  }

  @override
  String get combatPhasePickCommand => 'Selecione o comando';

  @override
  String get combatPhasePickTarget => 'Selecione o alvo';

  @override
  String get combatPhasePickItem => 'Escolha adereços e alvos';

  @override
  String get combatPhaseReady => 'Pronto para executar a rodada';

  @override
  String get combatPhaseAnimating => 'Rodada em andamento…';

  @override
  String get combatQueueTitle => 'Comandos da fila de comandos';

  @override
  String get combatQueuePending => 'Para ser selecionado…';

  @override
  String get combatEnemies => 'Inimigos Inimigos';

  @override
  String get combatParty => 'Festa da equipe';

  @override
  String get combatTitle => 'Combate baseado em turnos';

  @override
  String get combatMenuSemantics => 'menu de batalha';

  @override
  String get combatEnded => 'A batalha acabou';

  @override
  String get meleeEnded => 'A confusão termina.';

  @override
  String get meleeCancelled => 'Corpo a corpo foi cancelado.';

  @override
  String get enemyGeneric => 'inimigo';

  @override
  String get cmdLook => 'Verificar';

  @override
  String get cmdBag => 'Mochila';

  @override
  String get cmdTalk => 'diálogo';

  @override
  String get cmdHeal => 'tratar';

  @override
  String get cmdRecruit => 'recrutar';

  @override
  String get cmdParty => 'equipe';

  @override
  String get cmdScore => 'Pontuação';

  @override
  String get cmdHelp => 'ajuda';

  @override
  String get cmdNgPlus => 'Segunda semana';

  @override
  String get cmdMore => 'Mais';

  @override
  String get cmdTake => 'escolher';

  @override
  String get cmdBuy => 'Comprar';

  @override
  String get cmdSell => 'vender';

  @override
  String get cmdShop => 'mercadoria';

  @override
  String get cmdMoreTitle => 'Mais comandos · Mais';

  @override
  String get cmdMoreSemantics => 'Mais comandos';

  @override
  String get cmdTakeTitle => 'pegar, pegar';

  @override
  String get cmdBuyTitle => 'comprar comprar';

  @override
  String get cmdSellTitle => 'vender vender';

  @override
  String get cmdTakeAll => 'tudo tudo';

  @override
  String get cmdMapOn => 'mapa';

  @override
  String get cmdMapOff => 'Mapa·Guan';

  @override
  String get cmdToggleMap => 'Trocar mapa';

  @override
  String get cmdDevMapOn => 'Abra a imagem inteira';

  @override
  String get cmdDevMapOff => 'Nível completo do mapa';

  @override
  String get cmdSend => 'Enviar comando';

  @override
  String get cmdHint => 'Comando cmd: olha / pega 1 / n…';

  @override
  String get dirNorth => 'Norte N';

  @override
  String get dirWest => 'Oeste W';

  @override
  String get dirEast => 'Leste E';

  @override
  String get dirSouth => 'Sul S';

  @override
  String get dirUp => 'Acima de você';

  @override
  String get dirDown => 'Próxima D';

  @override
  String get mapHint =>
      'Arrastar e deslocar · Role a roda/aperte para ampliar · Clique nos nós adjacentes para mover';

  @override
  String mapFullCount(int count) {
    return 'Imagem completa $count';
  }

  @override
  String mapExploredCount(int count) {
    return 'Explorado $count';
  }

  @override
  String get mapCannotMoveInCombat => 'Incapaz de se mover durante o combate.';

  @override
  String mapGoing(String dir) {
    return 'Vá para $dir…';
  }

  @override
  String get mapDevFullMap => 'DEV·Imagem completa';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name — não adjacente, não acessível diretamente';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name (aqui)';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · Peso $weight/$capacity · $count peças · 💰$gold';
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
    return '$name HP $hp/$maxHp Ataque $atk Defesa $def Velocidade $spd';
  }

  @override
  String get creditQa => 'Garantia de Qualidade';

  @override
  String get creditPresentedBy => 'Produzido/Apresentado por';

  @override
  String get creditDirectedBy => 'Diretor / Dirigido por';

  @override
  String get creditWrittenBy => 'Roteirista/Escrito por';

  @override
  String get creditGameDesign => 'Design de Jogos / Design de Jogos';

  @override
  String get creditNarrativeDesign => 'Design Narrativo / Design Narrativo';

  @override
  String get creditArtDirection => 'Direção de Arte / Direção de Arte';

  @override
  String get creditLevelDesign => 'Design de níveis / Design de níveis';

  @override
  String get creditSystemsDesign => 'Projeto de Sistemas / Projeto de Sistemas';

  @override
  String get creditCombatDesign => 'Design de Combate / Design de Combate';

  @override
  String get creditSoundConcept => 'Conceito de Som / Conceito de Som';

  @override
  String get creditProducedBy => 'Produtor / Produzido por';

  @override
  String get creditEngineering => 'Programa / Engenharia';

  @override
  String get creditSpecialThanks =>
      'Agradecimentos Especiais / Agradecimentos Especiais';

  @override
  String get creditTechSupport => 'Suporte Técnico / Suporte Tecnológico';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsBgmEnabled => 'Música de fundo';

  @override
  String get settingsSfxEnabled => 'Efeitos sonoros';

  @override
  String get settingsGearSemantics => 'Configurações';

  @override
  String get settingsMenuLabel => 'Configurações';

  @override
  String get deleteSaveTitle => 'Excluir salvamento?';

  @override
  String get deleteSaveMessage =>
      'O progresso deste slot será excluído permanentemente.';

  @override
  String get deleteSaveConfirm => 'Excluir';

  @override
  String get deleteSaveSemantics => 'Excluir salvamento';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageRestartTitle => 'Alterar idioma';

  @override
  String get languageRestartMessage =>
      'O app precisa reiniciar para carregar o novo idioma. Reiniciar agora?';

  @override
  String get languageRestartConfirm => 'Reiniciar agora';
}
