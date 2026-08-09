// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '霧の塔';

  @override
  String get appTitleEn => 'ミストタワー';

  @override
  String get taglineShort => '探索し、収集し、話し、戦い、失われた真実を取り戻しましょう。';

  @override
  String get taglineFull =>
      'あなたは霧の森から記憶を失って目覚めます。\n探索し、収集し、話し、戦い、失われた真実を取り戻しましょう。';

  @override
  String get homeHint => 'コマンド探索・フォグマップ・敵と遭遇して戦闘ラウンドに入る';

  @override
  String get loading => '読み込み中…';

  @override
  String get continueJourney => '旅を続けてください';

  @override
  String get enterMist => '霧の中に入る';

  @override
  String get achievements => '成果';

  @override
  String get leaderboard => 'ランキング一覧';

  @override
  String get close => '閉鎖';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認する';

  @override
  String get skip => '飛び越える';

  @override
  String get continueAction => '続く';

  @override
  String get back => '戻る';

  @override
  String get menu => 'メニュー';

  @override
  String get startNewJourneyTitle => '新しい旅を始めませんか？';

  @override
  String get overwriteSaveMessage =>
      'このスロットにはすでに進捗があります。新しいゲームを開始すると、この保存は上書きされます。続けますか?';

  @override
  String get overwriteAndStart => 'カバーしてスタート';

  @override
  String get connectPlayGamesTitle => 'ゲームを接続する';

  @override
  String get connectPlayGamesMessage =>
      'Google Play ゲームに接続して、実績とリーダーボードを表示します。接続しなくても普通にプレイできます。';

  @override
  String get connectLater => '後でまた話しましょう';

  @override
  String get connectNow => '今すぐ接続してください';

  @override
  String get returnToTitleTitle => 'タイトルを返しますか？';

  @override
  String get returnToTitleMessage =>
      '現在の進行状況は自動的に保存され、タイトルページの「旅を続ける」から復元できます。';

  @override
  String get returnToTitle => 'タイトルを返す';

  @override
  String get quitAppTitle => 'ゲームをやめますか?';

  @override
  String get quitAppMessage => 'ミストタワーは閉館となります。';

  @override
  String get quit => 'やめる';

  @override
  String get combatPauseTitle => 'バトルメニュー・ポーズ';

  @override
  String get resumeCombat => '戦い続ける';

  @override
  String get backToTitle => 'タイトルに戻る';

  @override
  String get privacySettings => 'プライバシー設定';

  @override
  String get privacySettingsHint => 'プライバシー設定 · プライバシー';

  @override
  String get rewardOfferTitle => '霧の贈り物';

  @override
  String rewardOfferGold(int base, int doubled) {
    return 'このゲームのゴールド コイン +$base → +$doubled';
  }

  @override
  String get rewardOfferUnavailable => 'ギフトは一時的に利用できなくなります。冒険を直接続行できます';

  @override
  String get rewardOfferWatch => '広告を見る · ダブル金貨';

  @override
  String get rewardOfferLoading => 'ギフトを召喚しています...';

  @override
  String get continueAdventure => '冒険を続ける';

  @override
  String get watchAd => '広告を見る';

  @override
  String get watchAdRecoverLoss => '広告を見る · 損失を回復する';

  @override
  String refundScorePoints(int points) {
    return '$points ポイントを返却';
  }

  @override
  String get summoningGlimmer => '黄昏の召喚…';

  @override
  String get glimmerNoResponse => 'シマーはまだ応答していません。後でもう一度試してください。';

  @override
  String get endingDragonTitle => '若き竜は堕ちた';

  @override
  String get endingDragonSubtitle =>
      '魔法の宝石があなたの手に落ちます。\nそれは墓地から避難所への石の扉を開けるだけでなく、塔の頂上で失われた記憶を呼び戻すこともできます。';

  @override
  String get endingDragonPrimary => '冒険を続ける';

  @override
  String get endingDragonSecondary => '戻って旅行を完了する';

  @override
  String get endingMainTitle => '霧が消える';

  @override
  String get endingMainSubtitle =>
      '記憶が脳裏に甦り、塔の結界が崩れた。\nあなたは自由ですが、精神病院の奥深くにはまだやり残した仕事が残っています。';

  @override
  String get endingMainPrimary => '探索を続けてください';

  @override
  String get endingSiteTitle => 'サイトアクションが完了しました';

  @override
  String get endingSiteSubtitle => '最終試作機は鎮圧され、収容室は沈黙に陥った。\n長かった旅も終わりに近づいています。';

  @override
  String get endingSitePrimary => 'スタッフ一覧を見る';

  @override
  String get endingGameOverTitle => 'あなたは落ちました';

  @override
  String get endingGameOverSubtitle =>
      '霧があなたの姿を飲み込みます。\nあなたは、最後に探索した場所で目覚めます。スコアは -100 (0 以上) です。';

  @override
  String get endingGameOverPrimary => '最後の場所で目覚める';

  @override
  String get inventoryTitle => 'バックパック・在庫';

  @override
  String get inventoryUseTitle => '小道具を使用する・使用する';

  @override
  String get inventoryDropTitle => '小道具をドロップする · ドロップする';

  @override
  String get teleportTitle => '送信先・テレポート';

  @override
  String get notLoaded => 'まだロードされていません';

  @override
  String get noUsableItems => '利用できる小道具はありません。';

  @override
  String get noDroppableItems => '捨てる小道具はありません。';

  @override
  String get inventoryEmpty => 'バックパックは空です。';

  @override
  String get noMoreDescription => 'それ以上の説明はありません。';

  @override
  String itemType(String type) {
    return '$typeと入力してください';
  }

  @override
  String itemWeight(int weight) {
    return '重量 $weight';
  }

  @override
  String itemValue(int value) {
    return '値 $value';
  }

  @override
  String itemHeal(int heal) {
    return '治療 +$heal';
  }

  @override
  String itemAttackBonus(int bonus) {
    return '攻撃 +$bonus';
  }

  @override
  String itemDefenseBonus(int bonus) {
    return '防御 +$bonus';
  }

  @override
  String itemCapacity(int capacity) {
    return '容量$capacity';
  }

  @override
  String itemCount(int count) {
    return '数量 x$count';
  }

  @override
  String itemUseEffect(String msg) {
    return '使用効果: $msg';
  }

  @override
  String statAtkShort(int bonus) {
    return '攻撃+$bonus';
  }

  @override
  String statDefShort(int bonus) {
    return 'アンチ+$bonus';
  }

  @override
  String get equip => '装置';

  @override
  String get use => '使用';

  @override
  String get drop => '捨てる';

  @override
  String get combatAttack => '攻撃';

  @override
  String get combatSkill => 'スキル';

  @override
  String get combatItem => '小道具';

  @override
  String get combatDefend => '防衛';

  @override
  String get combatMelee => '近接攻撃';

  @override
  String get combatFlee => '逃げる';

  @override
  String get combatAttackShort => '攻撃';

  @override
  String get combatSkillShort => 'テクノロジー';

  @override
  String get combatItemShort => '道';

  @override
  String get combatDefendShort => '守る';

  @override
  String get combatFleeShort => '逃げる';

  @override
  String get combatCommandsTitle => 'コマンド';

  @override
  String get combatExecute => '埋め込む';

  @override
  String get combatVictory => '戦いの勝利';

  @override
  String get combatVictoryTap => 'クリックして続行します';

  @override
  String get combatDefeated => 'ビート';

  @override
  String get combatLoot => '戦利品';

  @override
  String get combatHarvest => '収穫';

  @override
  String combatGoldGain(int gold) {
    return '💰 ゴールドコイン +$gold';
  }

  @override
  String combatExpGain(int exp) {
    return '⭐ 経験 +$exp';
  }

  @override
  String get combatNoItems => 'バックパックには戦闘アイテムはありません';

  @override
  String get combatPickItem => '小道具アイテムの選択';

  @override
  String get combatInitiative => 'アクションシーケンスイニシアチブ';

  @override
  String combatTurnOrderSemantics(int index, String name, int speed) {
    return 'ビット $index $name 速度 $speed';
  }

  @override
  String get combatLogTitle => 'バトルレポートログ';

  @override
  String combatRound(int round) {
    return 'ラウンド $round';
  }

  @override
  String combatPhasePickCommandNamed(String name) {
    return 'コマンドを選択: $name';
  }

  @override
  String get combatPhasePickCommand => 'コマンドを選択';

  @override
  String get combatPhasePickTarget => 'ターゲットの選択';

  @override
  String get combatPhasePickItem => 'プロップとターゲットを選択する';

  @override
  String get combatPhaseReady => 'ラウンドを実行する準備ができました';

  @override
  String get combatPhaseAnimating => 'ラウンド進行中…';

  @override
  String get combatQueueTitle => 'コマンドキューコマンド';

  @override
  String get combatQueuePending => '選ばれるには…';

  @override
  String get combatEnemies => '敵 敵';

  @override
  String get combatParty => 'チームパーティー';

  @override
  String get combatTitle => 'ターン制戦闘';

  @override
  String get combatMenuSemantics => 'バトルメニュー';

  @override
  String get combatEnded => '戦いは終わった';

  @override
  String get meleeEnded => '乱戦は終了する。';

  @override
  String get meleeCancelled => '近接攻撃はキャンセルされました。';

  @override
  String get enemyGeneric => '敵';

  @override
  String get cmdLook => 'チェック';

  @override
  String get cmdBag => 'バックパック';

  @override
  String get cmdTalk => '対話';

  @override
  String get cmdHeal => '扱う';

  @override
  String get cmdRecruit => 'リクルート';

  @override
  String get cmdParty => 'チーム';

  @override
  String get cmdScore => 'スコア';

  @override
  String get cmdHelp => 'ヘルプ';

  @override
  String get cmdNgPlus => '2週目';

  @override
  String get cmdMore => 'もっと';

  @override
  String get cmdTake => '選び出す';

  @override
  String get cmdBuy => '買う';

  @override
  String get cmdSell => '売る';

  @override
  String get cmdShop => '商品';

  @override
  String get cmdMoreTitle => 'その他のコマンド · もっと見る';

  @override
  String get cmdMoreSemantics => 'その他のコマンド';

  @override
  String get cmdTakeTitle => '拾う';

  @override
  String get cmdBuyTitle => '買う 買う';

  @override
  String get cmdSellTitle => '売る';

  @override
  String get cmdTakeAll => '全部全部';

  @override
  String get cmdMapOn => '地図';

  @override
  String get cmdMapOff => '地図・関';

  @override
  String get cmdToggleMap => 'マップを切り替える';

  @override
  String get cmdDevMapOn => '全体像を開く';

  @override
  String get cmdDevMapOff => 'フルマップレベル';

  @override
  String get cmdSend => 'コマンドを送信する';

  @override
  String get cmdHint => 'コマンド cmd: look / take 1 / n …';

  @override
  String get dirNorth => '北北';

  @override
  String get dirWest => '西西';

  @override
  String get dirEast => '東東';

  @override
  String get dirSouth => '南南';

  @override
  String get dirUp => 'アップユー';

  @override
  String get dirDown => '次のD';

  @override
  String get mapHint =>
      'ドラッグしてパンする · ホイール/ピンチをスクロールしてズームする · 隣接するノードをクリックして移動する';

  @override
  String mapFullCount(int count) {
    return 'フル画像 $count';
  }

  @override
  String mapExploredCount(int count) {
    return '$countを探索しました';
  }

  @override
  String get mapCannotMoveInCombat => '戦闘中は移動不可。';

  @override
  String mapGoing(String dir) {
    return '$dir に移動します…';
  }

  @override
  String get mapDevFullMap => 'DEV・全体像';

  @override
  String mapNotAdjacentDetail(String name) {
    return '$name — 隣接していない、直接アクセスできない';
  }

  @override
  String inventoryRoomHere(String name) {
    return '$name (ここ)';
  }

  @override
  String inventoryHeader(
    String bag,
    int weight,
    int capacity,
    int count,
    int gold,
  ) {
    return '$bag · 重量 $weight/$capacity · $count 個 · 💰$gold';
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
    return '$name HP $hp/$maxHp 攻撃 $atk 防御 $def 速度 $spd';
  }

  @override
  String get creditQa => '品質保証';

  @override
  String get creditPresentedBy => '制作・提供：';

  @override
  String get creditDirectedBy => '監督 / 監督';

  @override
  String get creditWrittenBy => '脚本家・脚本家';

  @override
  String get creditGameDesign => 'ゲームデザイン / ゲームデザイン';

  @override
  String get creditNarrativeDesign => 'ナラティブデザイン / ナラティブデザイン';

  @override
  String get creditArtDirection => 'アートディレクション / アートディレクション';

  @override
  String get creditLevelDesign => 'レベルデザイン / レベルデザイン';

  @override
  String get creditSystemsDesign => 'システムデザイン / システムデザイン';

  @override
  String get creditCombatDesign => '戦闘デザイン / 戦闘デザイン';

  @override
  String get creditSoundConcept => 'サウンドコンセプト / サウンドコンセプト';

  @override
  String get creditProducedBy => 'プロデューサー / プロデュース';

  @override
  String get creditEngineering => 'プログラム / エンジニアリング';

  @override
  String get creditSpecialThanks => '特別な感謝 / 特別な感謝';

  @override
  String get creditTechSupport => '技術サポート / 技術サポート';
}
