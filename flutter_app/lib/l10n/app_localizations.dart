import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'US'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'迷雾之塔'**
  String get appTitle;

  /// No description provided for @appTitleEn.
  ///
  /// In zh_Hans, this message translates to:
  /// **'MIST TOWER'**
  String get appTitleEn;

  /// No description provided for @taglineShort.
  ///
  /// In zh_Hans, this message translates to:
  /// **'探索、收集、对话、战斗——找回失落的真相。'**
  String get taglineShort;

  /// No description provided for @taglineFull.
  ///
  /// In zh_Hans, this message translates to:
  /// **'你从迷雾森林中醒来，失去记忆。\n探索、收集、对话、战斗——找回失落的真相。'**
  String get taglineFull;

  /// No description provided for @homeHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'指令探索 · 迷雾地图 · 遇敌进入回合战斗'**
  String get homeHint;

  /// No description provided for @loading.
  ///
  /// In zh_Hans, this message translates to:
  /// **'加载中…'**
  String get loading;

  /// No description provided for @continueJourney.
  ///
  /// In zh_Hans, this message translates to:
  /// **'继续旅程'**
  String get continueJourney;

  /// No description provided for @enterMist.
  ///
  /// In zh_Hans, this message translates to:
  /// **'进入迷雾'**
  String get enterMist;

  /// No description provided for @achievements.
  ///
  /// In zh_Hans, this message translates to:
  /// **'成就'**
  String get achievements;

  /// No description provided for @leaderboard.
  ///
  /// In zh_Hans, this message translates to:
  /// **'排行榜'**
  String get leaderboard;

  /// No description provided for @close.
  ///
  /// In zh_Hans, this message translates to:
  /// **'关闭'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In zh_Hans, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In zh_Hans, this message translates to:
  /// **'确认'**
  String get confirm;

  /// No description provided for @skip.
  ///
  /// In zh_Hans, this message translates to:
  /// **'跳过'**
  String get skip;

  /// No description provided for @continueAction.
  ///
  /// In zh_Hans, this message translates to:
  /// **'继续'**
  String get continueAction;

  /// No description provided for @back.
  ///
  /// In zh_Hans, this message translates to:
  /// **'返回'**
  String get back;

  /// No description provided for @menu.
  ///
  /// In zh_Hans, this message translates to:
  /// **'菜单'**
  String get menu;

  /// No description provided for @startNewJourneyTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'开始新旅程？'**
  String get startNewJourneyTitle;

  /// No description provided for @overwriteSaveMessage.
  ///
  /// In zh_Hans, this message translates to:
  /// **'该槽位已有进度，开始新游戏将覆盖此存档，是否继续？'**
  String get overwriteSaveMessage;

  /// No description provided for @overwriteAndStart.
  ///
  /// In zh_Hans, this message translates to:
  /// **'覆盖并开始'**
  String get overwriteAndStart;

  /// No description provided for @connectPlayGamesTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'连接 Play 游戏'**
  String get connectPlayGamesTitle;

  /// No description provided for @connectPlayGamesMessage.
  ///
  /// In zh_Hans, this message translates to:
  /// **'连接 Google Play 游戏后可查看成就与排行榜。不连接也可正常游玩。'**
  String get connectPlayGamesMessage;

  /// No description provided for @connectLater.
  ///
  /// In zh_Hans, this message translates to:
  /// **'稍后再说'**
  String get connectLater;

  /// No description provided for @connectNow.
  ///
  /// In zh_Hans, this message translates to:
  /// **'立即连接'**
  String get connectNow;

  /// No description provided for @returnToTitleTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'返回标题？'**
  String get returnToTitleTitle;

  /// No description provided for @returnToTitleMessage.
  ///
  /// In zh_Hans, this message translates to:
  /// **'当前进度已自动保存，可从标题页「继续旅程」恢复。'**
  String get returnToTitleMessage;

  /// No description provided for @returnToTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'返回标题'**
  String get returnToTitle;

  /// No description provided for @quitAppTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'退出游戏？'**
  String get quitAppTitle;

  /// No description provided for @quitAppMessage.
  ///
  /// In zh_Hans, this message translates to:
  /// **'将关闭迷雾之塔。'**
  String get quitAppMessage;

  /// No description provided for @quit.
  ///
  /// In zh_Hans, this message translates to:
  /// **'退出'**
  String get quit;

  /// No description provided for @combatPauseTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'战斗菜单 · Pause'**
  String get combatPauseTitle;

  /// No description provided for @resumeCombat.
  ///
  /// In zh_Hans, this message translates to:
  /// **'继续战斗'**
  String get resumeCombat;

  /// No description provided for @backToTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'回标题'**
  String get backToTitle;

  /// No description provided for @privacySettings.
  ///
  /// In zh_Hans, this message translates to:
  /// **'隐私设置'**
  String get privacySettings;

  /// No description provided for @privacySettingsHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'隐私设置 · privacy'**
  String get privacySettingsHint;

  /// No description provided for @rewardOfferTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'迷雾馈赠'**
  String get rewardOfferTitle;

  /// No description provided for @rewardOfferGold.
  ///
  /// In zh_Hans, this message translates to:
  /// **'本场金币 +{base} → +{doubled}'**
  String rewardOfferGold(int base, int doubled);

  /// No description provided for @rewardOfferUnavailable.
  ///
  /// In zh_Hans, this message translates to:
  /// **'馈赠暂不可用，可直接继续冒险'**
  String get rewardOfferUnavailable;

  /// No description provided for @rewardOfferWatch.
  ///
  /// In zh_Hans, this message translates to:
  /// **'观看广告 · 金币翻倍'**
  String get rewardOfferWatch;

  /// No description provided for @rewardOfferLoading.
  ///
  /// In zh_Hans, this message translates to:
  /// **'召唤馈赠中…'**
  String get rewardOfferLoading;

  /// No description provided for @continueAdventure.
  ///
  /// In zh_Hans, this message translates to:
  /// **'继续冒险'**
  String get continueAdventure;

  /// No description provided for @watchAd.
  ///
  /// In zh_Hans, this message translates to:
  /// **'观看广告'**
  String get watchAd;

  /// No description provided for @watchAdRecoverLoss.
  ///
  /// In zh_Hans, this message translates to:
  /// **'观看广告 · 挽回损失'**
  String get watchAdRecoverLoss;

  /// No description provided for @refundScorePoints.
  ///
  /// In zh_Hans, this message translates to:
  /// **'返还 {points} 分'**
  String refundScorePoints(int points);

  /// No description provided for @summoningGlimmer.
  ///
  /// In zh_Hans, this message translates to:
  /// **'召唤微光中…'**
  String get summoningGlimmer;

  /// No description provided for @glimmerNoResponse.
  ///
  /// In zh_Hans, this message translates to:
  /// **'微光暂未回应，请稍后再试'**
  String get glimmerNoResponse;

  /// No description provided for @endingDragonTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'幼龙已陨落'**
  String get endingDragonTitle;

  /// No description provided for @endingDragonSubtitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'魔法宝石落入你手中。\n它既能打开墓地通往收容站的石门，也能在塔顶唤回失落的记忆。'**
  String get endingDragonSubtitle;

  /// No description provided for @endingDragonPrimary.
  ///
  /// In zh_Hans, this message translates to:
  /// **'继续探险'**
  String get endingDragonPrimary;

  /// No description provided for @endingDragonSecondary.
  ///
  /// In zh_Hans, this message translates to:
  /// **'返程完成旅行'**
  String get endingDragonSecondary;

  /// No description provided for @endingMainTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'迷雾消散'**
  String get endingMainTitle;

  /// No description provided for @endingMainSubtitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'记忆涌回脑海，高塔的结界随之瓦解。\n你自由了——但收容站深处仍有未竟之事。'**
  String get endingMainSubtitle;

  /// No description provided for @endingMainPrimary.
  ///
  /// In zh_Hans, this message translates to:
  /// **'继续探索'**
  String get endingMainPrimary;

  /// No description provided for @endingSiteTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'站点行动完成'**
  String get endingSiteTitle;

  /// No description provided for @endingSiteSubtitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'终焉原型已被压制，收容库归于沉寂。\n一段漫长的旅途，即将迎来尾声。'**
  String get endingSiteSubtitle;

  /// No description provided for @endingSitePrimary.
  ///
  /// In zh_Hans, this message translates to:
  /// **'观看职员表'**
  String get endingSitePrimary;

  /// No description provided for @endingGameOverTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'你倒下了'**
  String get endingGameOverTitle;

  /// No description provided for @endingGameOverSubtitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'迷雾吞没了你的身影。\n你在上一处探索过的地点醒来，得分 -100（不低于 0）。'**
  String get endingGameOverSubtitle;

  /// No description provided for @endingGameOverPrimary.
  ///
  /// In zh_Hans, this message translates to:
  /// **'在上一地点醒来'**
  String get endingGameOverPrimary;

  /// No description provided for @inventoryTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'背包 · Inventory'**
  String get inventoryTitle;

  /// No description provided for @inventoryUseTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'使用道具 · Use'**
  String get inventoryUseTitle;

  /// No description provided for @inventoryDropTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'丢弃道具 · Drop'**
  String get inventoryDropTitle;

  /// No description provided for @teleportTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'传送到 · Teleport'**
  String get teleportTitle;

  /// No description provided for @notLoaded.
  ///
  /// In zh_Hans, this message translates to:
  /// **'尚未加载'**
  String get notLoaded;

  /// No description provided for @noUsableItems.
  ///
  /// In zh_Hans, this message translates to:
  /// **'没有可使用的道具。'**
  String get noUsableItems;

  /// No description provided for @noDroppableItems.
  ///
  /// In zh_Hans, this message translates to:
  /// **'没有可丢弃的道具。'**
  String get noDroppableItems;

  /// No description provided for @inventoryEmpty.
  ///
  /// In zh_Hans, this message translates to:
  /// **'背包是空的。'**
  String get inventoryEmpty;

  /// No description provided for @noMoreDescription.
  ///
  /// In zh_Hans, this message translates to:
  /// **'没有更多描述。'**
  String get noMoreDescription;

  /// No description provided for @itemType.
  ///
  /// In zh_Hans, this message translates to:
  /// **'类型 {type}'**
  String itemType(String type);

  /// No description provided for @itemWeight.
  ///
  /// In zh_Hans, this message translates to:
  /// **'重量 {weight}'**
  String itemWeight(int weight);

  /// No description provided for @itemValue.
  ///
  /// In zh_Hans, this message translates to:
  /// **'价值 {value}'**
  String itemValue(int value);

  /// No description provided for @itemHeal.
  ///
  /// In zh_Hans, this message translates to:
  /// **'治疗 +{heal}'**
  String itemHeal(int heal);

  /// No description provided for @itemAttackBonus.
  ///
  /// In zh_Hans, this message translates to:
  /// **'攻击 +{bonus}'**
  String itemAttackBonus(int bonus);

  /// No description provided for @itemDefenseBonus.
  ///
  /// In zh_Hans, this message translates to:
  /// **'防御 +{bonus}'**
  String itemDefenseBonus(int bonus);

  /// No description provided for @itemCapacity.
  ///
  /// In zh_Hans, this message translates to:
  /// **'容量 {capacity}'**
  String itemCapacity(int capacity);

  /// No description provided for @itemCount.
  ///
  /// In zh_Hans, this message translates to:
  /// **'数量 x{count}'**
  String itemCount(int count);

  /// No description provided for @itemUseEffect.
  ///
  /// In zh_Hans, this message translates to:
  /// **'使用效果：{msg}'**
  String itemUseEffect(String msg);

  /// No description provided for @statAtkShort.
  ///
  /// In zh_Hans, this message translates to:
  /// **'攻+{bonus}'**
  String statAtkShort(int bonus);

  /// No description provided for @statDefShort.
  ///
  /// In zh_Hans, this message translates to:
  /// **'防+{bonus}'**
  String statDefShort(int bonus);

  /// No description provided for @equip.
  ///
  /// In zh_Hans, this message translates to:
  /// **'装备'**
  String get equip;

  /// No description provided for @use.
  ///
  /// In zh_Hans, this message translates to:
  /// **'使用'**
  String get use;

  /// No description provided for @drop.
  ///
  /// In zh_Hans, this message translates to:
  /// **'丢弃'**
  String get drop;

  /// No description provided for @combatAttack.
  ///
  /// In zh_Hans, this message translates to:
  /// **'攻击'**
  String get combatAttack;

  /// No description provided for @combatSkill.
  ///
  /// In zh_Hans, this message translates to:
  /// **'技能'**
  String get combatSkill;

  /// No description provided for @combatItem.
  ///
  /// In zh_Hans, this message translates to:
  /// **'道具'**
  String get combatItem;

  /// No description provided for @combatDefend.
  ///
  /// In zh_Hans, this message translates to:
  /// **'防御'**
  String get combatDefend;

  /// No description provided for @combatMelee.
  ///
  /// In zh_Hans, this message translates to:
  /// **'混战'**
  String get combatMelee;

  /// No description provided for @combatFlee.
  ///
  /// In zh_Hans, this message translates to:
  /// **'逃跑'**
  String get combatFlee;

  /// No description provided for @combatAttackShort.
  ///
  /// In zh_Hans, this message translates to:
  /// **'攻'**
  String get combatAttackShort;

  /// No description provided for @combatSkillShort.
  ///
  /// In zh_Hans, this message translates to:
  /// **'技'**
  String get combatSkillShort;

  /// No description provided for @combatItemShort.
  ///
  /// In zh_Hans, this message translates to:
  /// **'道'**
  String get combatItemShort;

  /// No description provided for @combatDefendShort.
  ///
  /// In zh_Hans, this message translates to:
  /// **'防'**
  String get combatDefendShort;

  /// No description provided for @combatFleeShort.
  ///
  /// In zh_Hans, this message translates to:
  /// **'逃'**
  String get combatFleeShort;

  /// No description provided for @combatCommandsTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'指令 Commands'**
  String get combatCommandsTitle;

  /// No description provided for @combatExecute.
  ///
  /// In zh_Hans, this message translates to:
  /// **'执行'**
  String get combatExecute;

  /// No description provided for @combatVictory.
  ///
  /// In zh_Hans, this message translates to:
  /// **'战斗胜利'**
  String get combatVictory;

  /// No description provided for @combatVictoryTap.
  ///
  /// In zh_Hans, this message translates to:
  /// **'点击继续'**
  String get combatVictoryTap;

  /// No description provided for @combatDefeated.
  ///
  /// In zh_Hans, this message translates to:
  /// **'击败'**
  String get combatDefeated;

  /// No description provided for @combatLoot.
  ///
  /// In zh_Hans, this message translates to:
  /// **'战利品'**
  String get combatLoot;

  /// No description provided for @combatHarvest.
  ///
  /// In zh_Hans, this message translates to:
  /// **'收获'**
  String get combatHarvest;

  /// No description provided for @combatGoldGain.
  ///
  /// In zh_Hans, this message translates to:
  /// **'💰 金币 +{gold}'**
  String combatGoldGain(int gold);

  /// No description provided for @combatExpGain.
  ///
  /// In zh_Hans, this message translates to:
  /// **'⭐ 经验 +{exp}'**
  String combatExpGain(int exp);

  /// No description provided for @combatNoItems.
  ///
  /// In zh_Hans, this message translates to:
  /// **'背包中没有可用战斗道具'**
  String get combatNoItems;

  /// No description provided for @combatPickItem.
  ///
  /// In zh_Hans, this message translates to:
  /// **'选择道具 Items'**
  String get combatPickItem;

  /// No description provided for @combatInitiative.
  ///
  /// In zh_Hans, this message translates to:
  /// **'行动顺序 Initiative'**
  String get combatInitiative;

  /// No description provided for @combatTurnOrderSemantics.
  ///
  /// In zh_Hans, this message translates to:
  /// **'第 {index} 位 {name} 速度 {speed}'**
  String combatTurnOrderSemantics(int index, String name, int speed);

  /// No description provided for @combatLogTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'战报 Log'**
  String get combatLogTitle;

  /// No description provided for @combatRound.
  ///
  /// In zh_Hans, this message translates to:
  /// **'第 {round} 回合'**
  String combatRound(int round);

  /// No description provided for @combatPhasePickCommandNamed.
  ///
  /// In zh_Hans, this message translates to:
  /// **'选择指令：{name}'**
  String combatPhasePickCommandNamed(String name);

  /// No description provided for @combatPhasePickCommand.
  ///
  /// In zh_Hans, this message translates to:
  /// **'选择指令'**
  String get combatPhasePickCommand;

  /// No description provided for @combatPhasePickTarget.
  ///
  /// In zh_Hans, this message translates to:
  /// **'选择目标'**
  String get combatPhasePickTarget;

  /// No description provided for @combatPhasePickItem.
  ///
  /// In zh_Hans, this message translates to:
  /// **'选择道具与目标'**
  String get combatPhasePickItem;

  /// No description provided for @combatPhaseReady.
  ///
  /// In zh_Hans, this message translates to:
  /// **'准备执行回合'**
  String get combatPhaseReady;

  /// No description provided for @combatPhaseAnimating.
  ///
  /// In zh_Hans, this message translates to:
  /// **'回合进行中…'**
  String get combatPhaseAnimating;

  /// No description provided for @combatQueueTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'指令队列 Commands'**
  String get combatQueueTitle;

  /// No description provided for @combatQueuePending.
  ///
  /// In zh_Hans, this message translates to:
  /// **'待选…'**
  String get combatQueuePending;

  /// No description provided for @combatEnemies.
  ///
  /// In zh_Hans, this message translates to:
  /// **'敌人 Enemies'**
  String get combatEnemies;

  /// No description provided for @combatParty.
  ///
  /// In zh_Hans, this message translates to:
  /// **'队伍 Party'**
  String get combatParty;

  /// No description provided for @combatTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'回合战斗'**
  String get combatTitle;

  /// No description provided for @combatMenuSemantics.
  ///
  /// In zh_Hans, this message translates to:
  /// **'战斗菜单'**
  String get combatMenuSemantics;

  /// No description provided for @combatEnded.
  ///
  /// In zh_Hans, this message translates to:
  /// **'战斗已结束'**
  String get combatEnded;

  /// No description provided for @meleeEnded.
  ///
  /// In zh_Hans, this message translates to:
  /// **'混战结束。'**
  String get meleeEnded;

  /// No description provided for @meleeCancelled.
  ///
  /// In zh_Hans, this message translates to:
  /// **'已取消混战。'**
  String get meleeCancelled;

  /// No description provided for @enemyGeneric.
  ///
  /// In zh_Hans, this message translates to:
  /// **'敌人'**
  String get enemyGeneric;

  /// No description provided for @cmdLook.
  ///
  /// In zh_Hans, this message translates to:
  /// **'查看'**
  String get cmdLook;

  /// No description provided for @cmdBag.
  ///
  /// In zh_Hans, this message translates to:
  /// **'背包'**
  String get cmdBag;

  /// No description provided for @cmdTalk.
  ///
  /// In zh_Hans, this message translates to:
  /// **'对话'**
  String get cmdTalk;

  /// No description provided for @cmdHeal.
  ///
  /// In zh_Hans, this message translates to:
  /// **'治疗'**
  String get cmdHeal;

  /// No description provided for @cmdRecruit.
  ///
  /// In zh_Hans, this message translates to:
  /// **'招募'**
  String get cmdRecruit;

  /// No description provided for @cmdParty.
  ///
  /// In zh_Hans, this message translates to:
  /// **'队伍'**
  String get cmdParty;

  /// No description provided for @cmdScore.
  ///
  /// In zh_Hans, this message translates to:
  /// **'得分'**
  String get cmdScore;

  /// No description provided for @cmdHelp.
  ///
  /// In zh_Hans, this message translates to:
  /// **'帮助'**
  String get cmdHelp;

  /// No description provided for @cmdNgPlus.
  ///
  /// In zh_Hans, this message translates to:
  /// **'二周目'**
  String get cmdNgPlus;

  /// No description provided for @cmdMore.
  ///
  /// In zh_Hans, this message translates to:
  /// **'更多'**
  String get cmdMore;

  /// No description provided for @cmdTake.
  ///
  /// In zh_Hans, this message translates to:
  /// **'拿起'**
  String get cmdTake;

  /// No description provided for @cmdBuy.
  ///
  /// In zh_Hans, this message translates to:
  /// **'购买'**
  String get cmdBuy;

  /// No description provided for @cmdSell.
  ///
  /// In zh_Hans, this message translates to:
  /// **'出售'**
  String get cmdSell;

  /// No description provided for @cmdShop.
  ///
  /// In zh_Hans, this message translates to:
  /// **'商品'**
  String get cmdShop;

  /// No description provided for @cmdMoreTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'更多命令 · More'**
  String get cmdMoreTitle;

  /// No description provided for @cmdMoreSemantics.
  ///
  /// In zh_Hans, this message translates to:
  /// **'更多命令'**
  String get cmdMoreSemantics;

  /// No description provided for @cmdTakeTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'拿起 take'**
  String get cmdTakeTitle;

  /// No description provided for @cmdBuyTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'购买 buy'**
  String get cmdBuyTitle;

  /// No description provided for @cmdSellTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'出售 sell'**
  String get cmdSellTitle;

  /// No description provided for @cmdTakeAll.
  ///
  /// In zh_Hans, this message translates to:
  /// **'全部 all'**
  String get cmdTakeAll;

  /// No description provided for @cmdMapOn.
  ///
  /// In zh_Hans, this message translates to:
  /// **'地图'**
  String get cmdMapOn;

  /// No description provided for @cmdMapOff.
  ///
  /// In zh_Hans, this message translates to:
  /// **'地图·关'**
  String get cmdMapOff;

  /// No description provided for @cmdToggleMap.
  ///
  /// In zh_Hans, this message translates to:
  /// **'切换地图'**
  String get cmdToggleMap;

  /// No description provided for @cmdDevMapOn.
  ///
  /// In zh_Hans, this message translates to:
  /// **'全图开'**
  String get cmdDevMapOn;

  /// No description provided for @cmdDevMapOff.
  ///
  /// In zh_Hans, this message translates to:
  /// **'全图关'**
  String get cmdDevMapOff;

  /// No description provided for @cmdSend.
  ///
  /// In zh_Hans, this message translates to:
  /// **'发送命令'**
  String get cmdSend;

  /// No description provided for @cmdHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'命令 cmd: look / take 1 / n …'**
  String get cmdHint;

  /// No description provided for @dirNorth.
  ///
  /// In zh_Hans, this message translates to:
  /// **'北 N'**
  String get dirNorth;

  /// No description provided for @dirWest.
  ///
  /// In zh_Hans, this message translates to:
  /// **'西 W'**
  String get dirWest;

  /// No description provided for @dirEast.
  ///
  /// In zh_Hans, this message translates to:
  /// **'东 E'**
  String get dirEast;

  /// No description provided for @dirSouth.
  ///
  /// In zh_Hans, this message translates to:
  /// **'南 S'**
  String get dirSouth;

  /// No description provided for @dirUp.
  ///
  /// In zh_Hans, this message translates to:
  /// **'上 U'**
  String get dirUp;

  /// No description provided for @dirDown.
  ///
  /// In zh_Hans, this message translates to:
  /// **'下 D'**
  String get dirDown;

  /// No description provided for @mapHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'拖拽平移 · 滚轮/双指缩放 · 点击相邻节点移动'**
  String get mapHint;

  /// No description provided for @mapFullCount.
  ///
  /// In zh_Hans, this message translates to:
  /// **'全图 {count}'**
  String mapFullCount(int count);

  /// No description provided for @mapExploredCount.
  ///
  /// In zh_Hans, this message translates to:
  /// **'已探索 {count}'**
  String mapExploredCount(int count);

  /// No description provided for @mapCannotMoveInCombat.
  ///
  /// In zh_Hans, this message translates to:
  /// **'战斗中无法移动。'**
  String get mapCannotMoveInCombat;

  /// No description provided for @mapGoing.
  ///
  /// In zh_Hans, this message translates to:
  /// **'前往 {dir}…'**
  String mapGoing(String dir);

  /// No description provided for @creditPresentedBy.
  ///
  /// In zh_Hans, this message translates to:
  /// **'出品 / Presented by'**
  String get creditPresentedBy;

  /// No description provided for @creditDirectedBy.
  ///
  /// In zh_Hans, this message translates to:
  /// **'导演 / Directed by'**
  String get creditDirectedBy;

  /// No description provided for @creditWrittenBy.
  ///
  /// In zh_Hans, this message translates to:
  /// **'编剧 / Written by'**
  String get creditWrittenBy;

  /// No description provided for @creditGameDesign.
  ///
  /// In zh_Hans, this message translates to:
  /// **'游戏设计 / Game Design'**
  String get creditGameDesign;

  /// No description provided for @creditNarrativeDesign.
  ///
  /// In zh_Hans, this message translates to:
  /// **'叙事设计 / Narrative Design'**
  String get creditNarrativeDesign;

  /// No description provided for @creditArtDirection.
  ///
  /// In zh_Hans, this message translates to:
  /// **'美术指导 / Art Direction'**
  String get creditArtDirection;

  /// No description provided for @creditLevelDesign.
  ///
  /// In zh_Hans, this message translates to:
  /// **'关卡设计 / Level Design'**
  String get creditLevelDesign;

  /// No description provided for @creditSystemsDesign.
  ///
  /// In zh_Hans, this message translates to:
  /// **'系统设计 / Systems Design'**
  String get creditSystemsDesign;

  /// No description provided for @creditCombatDesign.
  ///
  /// In zh_Hans, this message translates to:
  /// **'战斗设计 / Combat Design'**
  String get creditCombatDesign;

  /// No description provided for @creditSoundConcept.
  ///
  /// In zh_Hans, this message translates to:
  /// **'音效构想 / Sound Concept'**
  String get creditSoundConcept;

  /// No description provided for @creditProducedBy.
  ///
  /// In zh_Hans, this message translates to:
  /// **'制作人 / Produced by'**
  String get creditProducedBy;

  /// No description provided for @creditEngineering.
  ///
  /// In zh_Hans, this message translates to:
  /// **'程序 / Engineering'**
  String get creditEngineering;

  /// No description provided for @creditSpecialThanks.
  ///
  /// In zh_Hans, this message translates to:
  /// **'特别鸣谢 / Special Thanks'**
  String get creditSpecialThanks;

  /// No description provided for @creditTechSupport.
  ///
  /// In zh_Hans, this message translates to:
  /// **'技术支持 / Technology Support'**
  String get creditTechSupport;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'US':
            return AppLocalizationsEnUs();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
