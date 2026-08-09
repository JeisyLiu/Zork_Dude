// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '迷雾之塔';

  @override
  String get appTitleEn => 'MIST TOWER';

  @override
  String get taglineShort => '探索、收集、对话、战斗——找回失落的真相。';

  @override
  String get taglineFull => '你从迷雾森林中醒来，失去记忆。\n探索、收集、对话、战斗——找回失落的真相。';

  @override
  String get homeHint => '指令探索 · 迷雾地图 · 遇敌进入回合战斗';

  @override
  String get loading => '加载中…';

  @override
  String get continueJourney => '继续旅程';

  @override
  String get enterMist => '进入迷雾';

  @override
  String get achievements => '成就';

  @override
  String get leaderboard => '排行榜';

  @override
  String get close => '关闭';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get skip => '跳过';

  @override
  String get continueAction => '继续';

  @override
  String get back => '返回';

  @override
  String get menu => '菜单';

  @override
  String get startNewJourneyTitle => '开始新旅程？';

  @override
  String get overwriteSaveMessage => '该槽位已有进度，开始新游戏将覆盖此存档，是否继续？';

  @override
  String get overwriteAndStart => '覆盖并开始';

  @override
  String get connectPlayGamesTitle => '连接 Play 游戏';

  @override
  String get connectPlayGamesMessage =>
      '连接 Google Play 游戏后可查看成就与排行榜。不连接也可正常游玩。';

  @override
  String get connectLater => '稍后再说';

  @override
  String get connectNow => '立即连接';

  @override
  String get returnToTitleTitle => '返回标题？';

  @override
  String get returnToTitleMessage => '当前进度已自动保存，可从标题页「继续旅程」恢复。';

  @override
  String get returnToTitle => '返回标题';

  @override
  String get quitAppTitle => '退出游戏？';

  @override
  String get quitAppMessage => '将关闭迷雾之塔。';

  @override
  String get quit => '退出';

  @override
  String get combatPauseTitle => '战斗菜单 · Pause';

  @override
  String get resumeCombat => '继续战斗';

  @override
  String get backToTitle => '回标题';

  @override
  String get privacySettings => '隐私设置';

  @override
  String get privacySettingsHint => '隐私设置 · privacy';

  @override
  String get rewardOfferTitle => '迷雾馈赠';

  @override
  String rewardOfferGold(int base, int doubled) {
    return '本场金币 +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable => '馈赠暂不可用，可直接继续冒险';

  @override
  String get rewardOfferWatch => '观看广告 · 金币翻倍';

  @override
  String get rewardOfferLoading => '召唤馈赠中…';

  @override
  String get continueAdventure => '继续冒险';

  @override
  String get watchAd => '观看广告';

  @override
  String get watchAdRecoverLoss => '观看广告 · 挽回损失';

  @override
  String refundScorePoints(int points) {
    return '返还 $points 分';
  }

  @override
  String get summoningGlimmer => '召唤微光中…';

  @override
  String get glimmerNoResponse => '微光暂未回应，请稍后再试';

  @override
  String get endingDragonTitle => '幼龙已陨落';

  @override
  String get endingDragonSubtitle =>
      '魔法宝石落入你手中。\n它既能打开墓地通往收容站的石门，也能在塔顶唤回失落的记忆。';

  @override
  String get endingDragonPrimary => '继续探险';

  @override
  String get endingDragonSecondary => '返程完成旅行';

  @override
  String get endingMainTitle => '迷雾消散';

  @override
  String get endingMainSubtitle => '记忆涌回脑海，高塔的结界随之瓦解。\n你自由了——但收容站深处仍有未竟之事。';

  @override
  String get endingMainPrimary => '继续探索';

  @override
  String get endingSiteTitle => '站点行动完成';

  @override
  String get endingSiteSubtitle => '终焉原型已被压制，收容库归于沉寂。\n一段漫长的旅途，即将迎来尾声。';

  @override
  String get endingSitePrimary => '观看职员表';

  @override
  String get endingGameOverTitle => '你倒下了';

  @override
  String get endingGameOverSubtitle =>
      '迷雾吞没了你的身影。\n你在上一处探索过的地点醒来，得分 -100（不低于 0）。';

  @override
  String get endingGameOverPrimary => '在上一地点醒来';

  @override
  String get inventoryTitle => '背包 · Inventory';

  @override
  String get inventoryUseTitle => '使用道具 · Use';

  @override
  String get inventoryDropTitle => '丢弃道具 · Drop';

  @override
  String get teleportTitle => '传送到 · Teleport';

  @override
  String get notLoaded => '尚未加载';

  @override
  String get noUsableItems => '没有可使用的道具。';

  @override
  String get noDroppableItems => '没有可丢弃的道具。';

  @override
  String get inventoryEmpty => '背包是空的。';

  @override
  String get noMoreDescription => '没有更多描述。';

  @override
  String itemType(String type) {
    return '类型 $type';
  }

  @override
  String itemWeight(int weight) {
    return '重量 $weight';
  }

  @override
  String itemValue(int value) {
    return '价值 $value';
  }

  @override
  String itemHeal(int heal) {
    return '治疗 +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return '攻击 +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return '防御 +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return '容量 $capacity';
  }

  @override
  String itemCount(int count) {
    return '数量 x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return '使用效果：$msg';
  }

  @override
  String statAtkShort(int bonus) {
    return '攻+$bonus';
  }

  @override
  String statDefShort(int bonus) {
    return '防+$bonus';
  }

  @override
  String get equip => '装备';

  @override
  String get use => '使用';

  @override
  String get drop => '丢弃';

  @override
  String get combatAttack => '攻击';

  @override
  String get combatSkill => '技能';

  @override
  String get combatItem => '道具';

  @override
  String get combatDefend => '防御';

  @override
  String get combatMelee => '混战';

  @override
  String get combatFlee => '逃跑';

  @override
  String get combatAttackShort => '攻';

  @override
  String get combatSkillShort => '技';

  @override
  String get combatItemShort => '道';

  @override
  String get combatDefendShort => '防';

  @override
  String get combatFleeShort => '逃';

  @override
  String get combatCommandsTitle => '指令 Commands';

  @override
  String get combatExecute => '执行';

  @override
  String get combatVictory => '战斗胜利';

  @override
  String get combatVictoryTap => '点击继续';

  @override
  String get combatDefeated => '击败';

  @override
  String get combatLoot => '战利品';

  @override
  String get combatHarvest => '收获';

  @override
  String combatGoldGain(int gold) {
    return '💰 金币 +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ 经验 +$exp';
  }

  @override
  String get combatNoItems => '背包中没有可用战斗道具';

  @override
  String get combatPickItem => '选择道具 Items';

  @override
  String get combatInitiative => '行动顺序 Initiative';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return '第 $index 位 $name 速度 $speed';
  }

  @override
  String get combatLogTitle => '战报 Log';

  @override
  String combatRound(int round) {
    return '第 $round 回合';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return '选择指令：$name';
  }

  @override
  String get combatPhasePickCommand => '选择指令';

  @override
  String get combatPhasePickTarget => '选择目标';

  @override
  String get combatPhasePickItem => '选择道具与目标';

  @override
  String get combatPhaseReady => '准备执行回合';

  @override
  String get combatPhaseAnimating => '回合进行中…';

  @override
  String get combatQueueTitle => '指令队列 Commands';

  @override
  String get combatQueuePending => '待选…';

  @override
  String get combatEnemies => '敌人 Enemies';

  @override
  String get combatParty => '队伍 Party';

  @override
  String get combatTitle => '回合战斗';

  @override
  String get combatMenuSemantics => '战斗菜单';

  @override
  String get combatEnded => '战斗已结束';

  @override
  String get meleeEnded => '混战结束。';

  @override
  String get meleeCancelled => '已取消混战。';

  @override
  String get enemyGeneric => '敌人';

  @override
  String get cmdLook => '查看';

  @override
  String get cmdBag => '背包';

  @override
  String get cmdTalk => '对话';

  @override
  String get cmdHeal => '治疗';

  @override
  String get cmdRecruit => '招募';

  @override
  String get cmdParty => '队伍';

  @override
  String get cmdScore => '得分';

  @override
  String get cmdHelp => '帮助';

  @override
  String get cmdNgPlus => '二周目';

  @override
  String get cmdMore => '更多';

  @override
  String get cmdTake => '拿起';

  @override
  String get cmdBuy => '购买';

  @override
  String get cmdSell => '出售';

  @override
  String get cmdShop => '商品';

  @override
  String get cmdMoreTitle => '更多命令 · More';

  @override
  String get cmdMoreSemantics => '更多命令';

  @override
  String get cmdTakeTitle => '拿起 take';

  @override
  String get cmdBuyTitle => '购买 buy';

  @override
  String get cmdSellTitle => '出售 sell';

  @override
  String get cmdTakeAll => '全部 all';

  @override
  String get cmdMapOn => '地图';

  @override
  String get cmdMapOff => '地图·关';

  @override
  String get cmdToggleMap => '切换地图';

  @override
  String get cmdDevMapOn => '全图开';

  @override
  String get cmdDevMapOff => '全图关';

  @override
  String get cmdSend => '发送命令';

  @override
  String get cmdHint => '命令 cmd: look / take 1 / n …';

  @override
  String get dirNorth => '北 N';

  @override
  String get dirWest => '西 W';

  @override
  String get dirEast => '东 E';

  @override
  String get dirSouth => '南 S';

  @override
  String get dirUp => '上 U';

  @override
  String get dirDown => '下 D';

  @override
  String get mapHint => '拖拽平移 · 滚轮/双指缩放 · 点击相邻节点移动';

  @override
  String mapFullCount(int count) {
    return '全图 $count';
  }

  @override
  String mapExploredCount(int count) {
    return '已探索 $count';
  }

  @override
  String get mapCannotMoveInCombat => '战斗中无法移动。';

  @override
  String mapGoing(String dir) {
    return '前往 $dir…';
  }

  @override
  String get mapDevFullMap => 'DEV · 全图';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name — 不相邻，无法直达';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name（此处）';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · 重量 $weight/$capacity · $count 件 · 💰$gold';
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
    return '$name HP $hp/$maxHp 攻击 $atk 防御 $def 速度 $spd';
  }

  @override
  String get creditQa => '质检 / Quality Assurance';

  @override
  String get creditPresentedBy => '出品 / Presented by';

  @override
  String get creditDirectedBy => '导演 / Directed by';

  @override
  String get creditWrittenBy => '编剧 / Written by';

  @override
  String get creditGameDesign => '游戏设计 / Game Design';

  @override
  String get creditNarrativeDesign => '叙事设计 / Narrative Design';

  @override
  String get creditArtDirection => '美术指导 / Art Direction';

  @override
  String get creditLevelDesign => '关卡设计 / Level Design';

  @override
  String get creditSystemsDesign => '系统设计 / Systems Design';

  @override
  String get creditCombatDesign => '战斗设计 / Combat Design';

  @override
  String get creditSoundConcept => '音效构想 / Sound Concept';

  @override
  String get creditProducedBy => '制作人 / Produced by';

  @override
  String get creditEngineering => '程序 / Engineering';

  @override
  String get creditSpecialThanks => '特别鸣谢 / Special Thanks';

  @override
  String get creditTechSupport => '技术支持 / Technology Support';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsBgmEnabled => '背景音乐';

  @override
  String get settingsSfxEnabled => '音效';

  @override
  String get settingsGearSemantics => '设置';

  @override
  String get settingsMenuLabel => '设置';

  @override
  String get deleteSaveTitle => '删除存档？';

  @override
  String get deleteSaveMessage => '该槽位的进度将被永久删除，无法恢复。';

  @override
  String get deleteSaveConfirm => '删除';

  @override
  String get deleteSaveSemantics => '删除存档';

  @override
  String get settingsLanguage => '语言';

  @override
  String get languageRestartTitle => '切换语言';

  @override
  String get languageRestartMessage => '需要重启应用以加载新语言文本。是否立即重启？';

  @override
  String get languageRestartConfirm => '立即重启';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get appTitle => '迷雾之塔';

  @override
  String get appTitleEn => 'MIST TOWER';

  @override
  String get taglineShort => '探索、收集、对话、战斗——找回失落的真相。';

  @override
  String get taglineFull => '你从迷雾森林中醒来，失去记忆。\n探索、收集、对话、战斗——找回失落的真相。';

  @override
  String get homeHint => '指令探索 · 迷雾地图 · 遇敌进入回合战斗';

  @override
  String get loading => '加载中…';

  @override
  String get continueJourney => '继续旅程';

  @override
  String get enterMist => '进入迷雾';

  @override
  String get achievements => '成就';

  @override
  String get leaderboard => '排行榜';

  @override
  String get close => '关闭';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get skip => '跳过';

  @override
  String get continueAction => '继续';

  @override
  String get back => '返回';

  @override
  String get menu => '菜单';

  @override
  String get startNewJourneyTitle => '开始新旅程？';

  @override
  String get overwriteSaveMessage => '该槽位已有进度，开始新游戏将覆盖此存档，是否继续？';

  @override
  String get overwriteAndStart => '覆盖并开始';

  @override
  String get connectPlayGamesTitle => '连接 Play 游戏';

  @override
  String get connectPlayGamesMessage =>
      '连接 Google Play 游戏后可查看成就与排行榜。不连接也可正常游玩。';

  @override
  String get connectLater => '稍后再说';

  @override
  String get connectNow => '立即连接';

  @override
  String get returnToTitleTitle => '返回标题？';

  @override
  String get returnToTitleMessage => '当前进度已自动保存，可从标题页「继续旅程」恢复。';

  @override
  String get returnToTitle => '返回标题';

  @override
  String get quitAppTitle => '退出游戏？';

  @override
  String get quitAppMessage => '将关闭迷雾之塔。';

  @override
  String get quit => '退出';

  @override
  String get combatPauseTitle => '战斗菜单 · Pause';

  @override
  String get resumeCombat => '继续战斗';

  @override
  String get backToTitle => '回标题';

  @override
  String get privacySettings => '隐私设置';

  @override
  String get privacySettingsHint => '隐私设置 · privacy';

  @override
  String get rewardOfferTitle => '迷雾馈赠';

  @override
  String rewardOfferGold(int base, int doubled) {
    return '本场金币 +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable => '馈赠暂不可用，可直接继续冒险';

  @override
  String get rewardOfferWatch => '观看广告 · 金币翻倍';

  @override
  String get rewardOfferLoading => '召唤馈赠中…';

  @override
  String get continueAdventure => '继续冒险';

  @override
  String get watchAd => '观看广告';

  @override
  String get watchAdRecoverLoss => '观看广告 · 挽回损失';

  @override
  String refundScorePoints(int points) {
    return '返还 $points 分';
  }

  @override
  String get summoningGlimmer => '召唤微光中…';

  @override
  String get glimmerNoResponse => '微光暂未回应，请稍后再试';

  @override
  String get endingDragonTitle => '幼龙已陨落';

  @override
  String get endingDragonSubtitle =>
      '魔法宝石落入你手中。\n它既能打开墓地通往收容站的石门，也能在塔顶唤回失落的记忆。';

  @override
  String get endingDragonPrimary => '继续探险';

  @override
  String get endingDragonSecondary => '返程完成旅行';

  @override
  String get endingMainTitle => '迷雾消散';

  @override
  String get endingMainSubtitle => '记忆涌回脑海，高塔的结界随之瓦解。\n你自由了——但收容站深处仍有未竟之事。';

  @override
  String get endingMainPrimary => '继续探索';

  @override
  String get endingSiteTitle => '站点行动完成';

  @override
  String get endingSiteSubtitle => '终焉原型已被压制，收容库归于沉寂。\n一段漫长的旅途，即将迎来尾声。';

  @override
  String get endingSitePrimary => '观看职员表';

  @override
  String get endingGameOverTitle => '你倒下了';

  @override
  String get endingGameOverSubtitle =>
      '迷雾吞没了你的身影。\n你在上一处探索过的地点醒来，得分 -100（不低于 0）。';

  @override
  String get endingGameOverPrimary => '在上一地点醒来';

  @override
  String get inventoryTitle => '背包 · Inventory';

  @override
  String get inventoryUseTitle => '使用道具 · Use';

  @override
  String get inventoryDropTitle => '丢弃道具 · Drop';

  @override
  String get teleportTitle => '传送到 · Teleport';

  @override
  String get notLoaded => '尚未加载';

  @override
  String get noUsableItems => '没有可使用的道具。';

  @override
  String get noDroppableItems => '没有可丢弃的道具。';

  @override
  String get inventoryEmpty => '背包是空的。';

  @override
  String get noMoreDescription => '没有更多描述。';

  @override
  String itemType(String type) {
    return '类型 $type';
  }

  @override
  String itemWeight(int weight) {
    return '重量 $weight';
  }

  @override
  String itemValue(int value) {
    return '价值 $value';
  }

  @override
  String itemHeal(int heal) {
    return '治疗 +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return '攻击 +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return '防御 +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return '容量 $capacity';
  }

  @override
  String itemCount(int count) {
    return '数量 x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return '使用效果：$msg';
  }

  @override
  String statAtkShort(int bonus) {
    return '攻+$bonus';
  }

  @override
  String statDefShort(int bonus) {
    return '防+$bonus';
  }

  @override
  String get equip => '装备';

  @override
  String get use => '使用';

  @override
  String get drop => '丢弃';

  @override
  String get combatAttack => '攻击';

  @override
  String get combatSkill => '技能';

  @override
  String get combatItem => '道具';

  @override
  String get combatDefend => '防御';

  @override
  String get combatMelee => '混战';

  @override
  String get combatFlee => '逃跑';

  @override
  String get combatAttackShort => '攻';

  @override
  String get combatSkillShort => '技';

  @override
  String get combatItemShort => '道';

  @override
  String get combatDefendShort => '防';

  @override
  String get combatFleeShort => '逃';

  @override
  String get combatCommandsTitle => '指令 Commands';

  @override
  String get combatExecute => '执行';

  @override
  String get combatVictory => '战斗胜利';

  @override
  String get combatVictoryTap => '点击继续';

  @override
  String get combatDefeated => '击败';

  @override
  String get combatLoot => '战利品';

  @override
  String get combatHarvest => '收获';

  @override
  String combatGoldGain(int gold) {
    return '💰 金币 +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ 经验 +$exp';
  }

  @override
  String get combatNoItems => '背包中没有可用战斗道具';

  @override
  String get combatPickItem => '选择道具 Items';

  @override
  String get combatInitiative => '行动顺序 Initiative';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return '第 $index 位 $name 速度 $speed';
  }

  @override
  String get combatLogTitle => '战报 Log';

  @override
  String combatRound(int round) {
    return '第 $round 回合';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return '选择指令：$name';
  }

  @override
  String get combatPhasePickCommand => '选择指令';

  @override
  String get combatPhasePickTarget => '选择目标';

  @override
  String get combatPhasePickItem => '选择道具与目标';

  @override
  String get combatPhaseReady => '准备执行回合';

  @override
  String get combatPhaseAnimating => '回合进行中…';

  @override
  String get combatQueueTitle => '指令队列 Commands';

  @override
  String get combatQueuePending => '待选…';

  @override
  String get combatEnemies => '敌人 Enemies';

  @override
  String get combatParty => '队伍 Party';

  @override
  String get combatTitle => '回合战斗';

  @override
  String get combatMenuSemantics => '战斗菜单';

  @override
  String get combatEnded => '战斗已结束';

  @override
  String get meleeEnded => '混战结束。';

  @override
  String get meleeCancelled => '已取消混战。';

  @override
  String get enemyGeneric => '敌人';

  @override
  String get cmdLook => '查看';

  @override
  String get cmdBag => '背包';

  @override
  String get cmdTalk => '对话';

  @override
  String get cmdHeal => '治疗';

  @override
  String get cmdRecruit => '招募';

  @override
  String get cmdParty => '队伍';

  @override
  String get cmdScore => '得分';

  @override
  String get cmdHelp => '帮助';

  @override
  String get cmdNgPlus => '二周目';

  @override
  String get cmdMore => '更多';

  @override
  String get cmdTake => '拿起';

  @override
  String get cmdBuy => '购买';

  @override
  String get cmdSell => '出售';

  @override
  String get cmdShop => '商品';

  @override
  String get cmdMoreTitle => '更多命令 · More';

  @override
  String get cmdMoreSemantics => '更多命令';

  @override
  String get cmdTakeTitle => '拿起 take';

  @override
  String get cmdBuyTitle => '购买 buy';

  @override
  String get cmdSellTitle => '出售 sell';

  @override
  String get cmdTakeAll => '全部 all';

  @override
  String get cmdMapOn => '地图';

  @override
  String get cmdMapOff => '地图·关';

  @override
  String get cmdToggleMap => '切换地图';

  @override
  String get cmdDevMapOn => '全图开';

  @override
  String get cmdDevMapOff => '全图关';

  @override
  String get cmdSend => '发送命令';

  @override
  String get cmdHint => '命令 cmd: look / take 1 / n …';

  @override
  String get dirNorth => '北 N';

  @override
  String get dirWest => '西 W';

  @override
  String get dirEast => '东 E';

  @override
  String get dirSouth => '南 S';

  @override
  String get dirUp => '上 U';

  @override
  String get dirDown => '下 D';

  @override
  String get mapHint => '拖拽平移 · 滚轮/双指缩放 · 点击相邻节点移动';

  @override
  String mapFullCount(int count) {
    return '全图 $count';
  }

  @override
  String mapExploredCount(int count) {
    return '已探索 $count';
  }

  @override
  String get mapCannotMoveInCombat => '战斗中无法移动。';

  @override
  String mapGoing(String dir) {
    return '前往 $dir…';
  }

  @override
  String get mapDevFullMap => 'DEV · 全图';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name — 不相邻，无法直达';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name（此处）';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · 重量 $weight/$capacity · $count 件 · 💰$gold';
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
    return '$name HP $hp/$maxHp 攻击 $atk 防御 $def 速度 $spd';
  }

  @override
  String get creditQa => '质检 / Quality Assurance';

  @override
  String get creditPresentedBy => '出品 / Presented by';

  @override
  String get creditDirectedBy => '导演 / Directed by';

  @override
  String get creditWrittenBy => '编剧 / Written by';

  @override
  String get creditGameDesign => '游戏设计 / Game Design';

  @override
  String get creditNarrativeDesign => '叙事设计 / Narrative Design';

  @override
  String get creditArtDirection => '美术指导 / Art Direction';

  @override
  String get creditLevelDesign => '关卡设计 / Level Design';

  @override
  String get creditSystemsDesign => '系统设计 / Systems Design';

  @override
  String get creditCombatDesign => '战斗设计 / Combat Design';

  @override
  String get creditSoundConcept => '音效构想 / Sound Concept';

  @override
  String get creditProducedBy => '制作人 / Produced by';

  @override
  String get creditEngineering => '程序 / Engineering';

  @override
  String get creditSpecialThanks => '特别鸣谢 / Special Thanks';

  @override
  String get creditTechSupport => '技术支持 / Technology Support';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsBgmEnabled => '背景音乐';

  @override
  String get settingsSfxEnabled => '音效';

  @override
  String get settingsGearSemantics => '设置';

  @override
  String get settingsMenuLabel => '设置';

  @override
  String get deleteSaveTitle => '删除存档？';

  @override
  String get deleteSaveMessage => '该槽位的进度将被永久删除，无法恢复。';

  @override
  String get deleteSaveConfirm => '删除';

  @override
  String get deleteSaveSemantics => '删除存档';

  @override
  String get settingsLanguage => '语言';

  @override
  String get languageRestartTitle => '切换语言';

  @override
  String get languageRestartMessage => '需要重启应用以加载新语言文本。是否立即重启？';

  @override
  String get languageRestartConfirm => '立即重启';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => '迷霧之塔';

  @override
  String get appTitleEn => 'MIST TOWER';

  @override
  String get taglineShort => '探索、收集、對話、戰鬥－找回失落的真相。';

  @override
  String get taglineFull => '你從迷霧森林中醒來，失去記憶。\n探索、收集、對話、戰鬥－找回失落的真相。';

  @override
  String get homeHint => '指令探索 · 迷霧地圖 · 遇敵進入回合戰鬥';

  @override
  String get loading => '載入中…';

  @override
  String get continueJourney => '繼續旅程';

  @override
  String get enterMist => '進入迷霧';

  @override
  String get achievements => '成就';

  @override
  String get leaderboard => '排行榜';

  @override
  String get close => '關閉';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確認';

  @override
  String get skip => '跳過';

  @override
  String get continueAction => '繼續';

  @override
  String get back => '返回';

  @override
  String get menu => '選單';

  @override
  String get startNewJourneyTitle => '開始新旅程？';

  @override
  String get overwriteSaveMessage => '該插槽已有進度，開始新遊戲將覆蓋此存檔，是否繼續？';

  @override
  String get overwriteAndStart => '覆蓋並開始';

  @override
  String get connectPlayGamesTitle => '連接 Play 遊戲';

  @override
  String get connectPlayGamesMessage =>
      '連接 Google Play 遊戲後可查看成就與排行榜。不連接也可正常遊玩。';

  @override
  String get connectLater => '稍後再說';

  @override
  String get connectNow => '立即連接';

  @override
  String get returnToTitleTitle => '回標題？';

  @override
  String get returnToTitleMessage => '當前進度已自動儲存，可從標題頁「繼續旅程」恢復。';

  @override
  String get returnToTitle => '回傳標題';

  @override
  String get quitAppTitle => '退出遊戲？';

  @override
  String get quitAppMessage => '將關閉迷霧之塔。';

  @override
  String get quit => '退出';

  @override
  String get combatPauseTitle => '戰鬥選單 · Pause';

  @override
  String get resumeCombat => '繼續戰鬥';

  @override
  String get backToTitle => '回到標題';

  @override
  String get privacySettings => '隱私設定';

  @override
  String get privacySettingsHint => '隱私設定 · privacy';

  @override
  String get rewardOfferTitle => '霧饋贈';

  @override
  String rewardOfferGold(int base, int doubled) {
    return '本場金幣 +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable => '饋贈暫不可用，可直接繼續冒險';

  @override
  String get rewardOfferWatch => '觀看廣告 · 金幣翻倍';

  @override
  String get rewardOfferLoading => '召喚饋贈中…';

  @override
  String get continueAdventure => '繼續冒險';

  @override
  String get watchAd => '觀看廣告';

  @override
  String get watchAdRecoverLoss => '觀看廣告 · 挽回損失';

  @override
  String refundScorePoints(int points) {
    return '返還 $points 分';
  }

  @override
  String get summoningGlimmer => '召喚微光中…';

  @override
  String get glimmerNoResponse => '微光暫未回應，請稍後再試';

  @override
  String get endingDragonTitle => '幼龍隕落';

  @override
  String get endingDragonSubtitle =>
      '魔法寶石落入你手中。\n它既能打開墓地通往收容站的石門，也能在塔頂喚回失落的記憶。';

  @override
  String get endingDragonPrimary => '繼續探險';

  @override
  String get endingDragonSecondary => '返程完成旅行';

  @override
  String get endingMainTitle => '迷霧消散';

  @override
  String get endingMainSubtitle => '記憶湧回腦海，高塔的結界隨之瓦解。\n你自由了——但收容站深處仍有未竟之事。';

  @override
  String get endingMainPrimary => '繼續探索';

  @override
  String get endingSiteTitle => '站點行動完成';

  @override
  String get endingSiteSubtitle => '终焉原型已被压制，收容库归于沉寂。\n一段漫長的旅途，即將迎來尾聲。';

  @override
  String get endingSitePrimary => '觀看職員表';

  @override
  String get endingGameOverTitle => '你倒下了';

  @override
  String get endingGameOverSubtitle =>
      '迷霧吞沒了你的身影。\n你在上一處探索過的地點醒來，得分 -100（不低於 0）。';

  @override
  String get endingGameOverPrimary => '在上一地點醒來';

  @override
  String get inventoryTitle => '背包 · Inventory';

  @override
  String get inventoryUseTitle => '使用道具 · Use';

  @override
  String get inventoryDropTitle => '丟棄道具 · Drop';

  @override
  String get teleportTitle => '傳送到 · Teleport';

  @override
  String get notLoaded => '尚未加載';

  @override
  String get noUsableItems => '沒有可使用的道具。';

  @override
  String get noDroppableItems => '沒有可丟棄的道具。';

  @override
  String get inventoryEmpty => '背包是空的。';

  @override
  String get noMoreDescription => '沒有更多描述。';

  @override
  String itemType(String type) {
    return '類型 $type';
  }

  @override
  String itemWeight(int weight) {
    return '重量 $weight';
  }

  @override
  String itemValue(int value) {
    return '價值 $value';
  }

  @override
  String itemHeal(int heal) {
    return '治療 +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return '攻擊 +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return '防禦 +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return '容量 $capacity';
  }

  @override
  String itemCount(int count) {
    return '數量 x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return '使用效果：$msg';
  }

  @override
  String statAtkShort(int bonus) {
    return '攻+$bonus';
  }

  @override
  String statDefShort(int bonus) {
    return '防+$bonus';
  }

  @override
  String get equip => '裝備';

  @override
  String get use => '使用';

  @override
  String get drop => '丟棄';

  @override
  String get combatAttack => '攻擊';

  @override
  String get combatSkill => '技能';

  @override
  String get combatItem => '道具';

  @override
  String get combatDefend => '防禦';

  @override
  String get combatMelee => '混戰';

  @override
  String get combatFlee => '逃跑';

  @override
  String get combatAttackShort => '攻';

  @override
  String get combatSkillShort => '技';

  @override
  String get combatItemShort => '道';

  @override
  String get combatDefendShort => '防';

  @override
  String get combatFleeShort => '逃';

  @override
  String get combatCommandsTitle => '指令 Commands';

  @override
  String get combatExecute => '執行';

  @override
  String get combatVictory => '戰鬥勝利';

  @override
  String get combatVictoryTap => '點擊繼續';

  @override
  String get combatDefeated => '擊敗';

  @override
  String get combatLoot => '戰利品';

  @override
  String get combatHarvest => '收穫';

  @override
  String combatGoldGain(int gold) {
    return '💰 金幣 +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ 經驗 +$exp';
  }

  @override
  String get combatNoItems => '背包中沒有可用戰鬥道具';

  @override
  String get combatPickItem => '選擇道具 Items';

  @override
  String get combatInitiative => '行動順序 Initiative';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return '第 $index 位元 $name 速度 $speed';
  }

  @override
  String get combatLogTitle => '戰報 Log';

  @override
  String combatRound(int round) {
    return '第 $round 回合';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return '選擇指令：$name';
  }

  @override
  String get combatPhasePickCommand => '選擇指令';

  @override
  String get combatPhasePickTarget => '選擇目標';

  @override
  String get combatPhasePickItem => '選擇道具與目標';

  @override
  String get combatPhaseReady => '準備執行回合';

  @override
  String get combatPhaseAnimating => '回合進行中…';

  @override
  String get combatQueueTitle => '指令隊列 Commands';

  @override
  String get combatQueuePending => '待選…';

  @override
  String get combatEnemies => '敵人 Enemies';

  @override
  String get combatParty => '隊伍 Party';

  @override
  String get combatTitle => '回合戰鬥';

  @override
  String get combatMenuSemantics => '戰鬥選單';

  @override
  String get combatEnded => '戰鬥已結束';

  @override
  String get meleeEnded => '混戰結束。';

  @override
  String get meleeCancelled => '已取消混戰。';

  @override
  String get enemyGeneric => '敵人';

  @override
  String get cmdLook => '查看';

  @override
  String get cmdBag => '背包';

  @override
  String get cmdTalk => '對話';

  @override
  String get cmdHeal => '治療';

  @override
  String get cmdRecruit => '招募';

  @override
  String get cmdParty => '隊伍';

  @override
  String get cmdScore => '得分';

  @override
  String get cmdHelp => '幫助';

  @override
  String get cmdNgPlus => '二週目';

  @override
  String get cmdMore => '更多';

  @override
  String get cmdTake => '拿起';

  @override
  String get cmdBuy => '購買';

  @override
  String get cmdSell => '出售';

  @override
  String get cmdShop => '商品';

  @override
  String get cmdMoreTitle => '更多命令 · More';

  @override
  String get cmdMoreSemantics => '更多指令';

  @override
  String get cmdTakeTitle => '拿起 take';

  @override
  String get cmdBuyTitle => '購買 buy';

  @override
  String get cmdSellTitle => '出售 sell';

  @override
  String get cmdTakeAll => '全部 all';

  @override
  String get cmdMapOn => '地圖';

  @override
  String get cmdMapOff => '地圖·關';

  @override
  String get cmdToggleMap => '切換地圖';

  @override
  String get cmdDevMapOn => '全圖開';

  @override
  String get cmdDevMapOff => '全圖關';

  @override
  String get cmdSend => '發送命令';

  @override
  String get cmdHint => '指令 cmd: look / take 1 / n …';

  @override
  String get dirNorth => '北 N';

  @override
  String get dirWest => '西 W';

  @override
  String get dirEast => '東 E';

  @override
  String get dirSouth => '南 S';

  @override
  String get dirUp => '上 U';

  @override
  String get dirDown => '下 D';

  @override
  String get mapHint => '拖曳平移 · 滾輪/雙指縮放 · 點選相鄰節點移動';

  @override
  String mapFullCount(int count) {
    return '全圖 $count';
  }

  @override
  String mapExploredCount(int count) {
    return '已探討 $count';
  }

  @override
  String get mapCannotMoveInCombat => '戰鬥中無法移動。';

  @override
  String mapGoing(String dir) {
    return '前往 $dir…';
  }

  @override
  String get mapDevFullMap => 'DEV · 全圖';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name — 不相鄰，無法直達';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name（此處）';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · 重量 $weight/$capacity · $count 件 · 💰$gold';
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
    return '$name HP $hp/$maxHp 攻擊 $atk 防禦 $def 速度 $spd';
  }

  @override
  String get creditQa => '質檢 / Quality Assurance';

  @override
  String get creditPresentedBy => '出品 / Presented by';

  @override
  String get creditDirectedBy => '導演 / Directed by';

  @override
  String get creditWrittenBy => '編劇 / Written by';

  @override
  String get creditGameDesign => '遊戲設計 / Game Design';

  @override
  String get creditNarrativeDesign => '敘事設計 / Narrative Design';

  @override
  String get creditArtDirection => '美術指導 / Art Direction';

  @override
  String get creditLevelDesign => '關卡設計 / Level Design';

  @override
  String get creditSystemsDesign => '系統設計 / Systems Design';

  @override
  String get creditCombatDesign => '戰鬥設計 / Combat Design';

  @override
  String get creditSoundConcept => '音效構想 / Sound Concept';

  @override
  String get creditProducedBy => '製作人 / Produced by';

  @override
  String get creditEngineering => '程序 / Engineering';

  @override
  String get creditSpecialThanks => '特別鳴謝 / Special Thanks';

  @override
  String get creditTechSupport => '技術支援 / Technology Support';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsBgmEnabled => '背景音樂';

  @override
  String get settingsSfxEnabled => '音效';

  @override
  String get settingsGearSemantics => '設定';

  @override
  String get settingsMenuLabel => '設定';

  @override
  String get deleteSaveTitle => '刪除存檔？';

  @override
  String get deleteSaveMessage => '該槽位的進度將被永久刪除，無法恢復。';

  @override
  String get deleteSaveConfirm => '刪除';

  @override
  String get deleteSaveSemantics => '刪除存檔';

  @override
  String get settingsLanguage => '語言';

  @override
  String get languageRestartTitle => '切換語言';

  @override
  String get languageRestartMessage => '需要重新啟動應用程式以載入新語言文字。是否立即重新啟動？';

  @override
  String get languageRestartConfirm => '立即重新啟動';
}
