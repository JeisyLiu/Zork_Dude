import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zork_dude/l10n/locale_tag.dart';

/// Runtime narrative strings for domain logic (no BuildContext).
class GameMessages {
  GameMessages(this._strings);

  final Map<String, String> _strings;

  static String? _cachedTag;
  static GameMessages? _cached;

  static Future<GameMessages> load(String localeTag) async {
    if (_cachedTag == localeTag && _cached != null) return _cached!;
    final tags = [localeTag, if (localeTag != LocaleTag.zhHans) LocaleTag.zhHans];
    for (final tag in tags) {
      try {
        final raw = await rootBundle.loadString(
          'assets/l10n/messages/$tag.json',
        );
        final map = (jsonDecode(raw) as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, v as String),
        );
        final messages = GameMessages(map);
        if (tag == localeTag) {
          _cachedTag = localeTag;
          _cached = messages;
        }
        return messages;
      } catch (_) {
        continue;
      }
    }
    return GameMessages(const {});
  }

  @visibleForTesting
  static void resetCacheForTest() {
    _cachedTag = null;
    _cached = null;
  }

  String operator [](String key) => _strings[key] ?? key;

  String msg(String key, [Map<String, Object?> args = const {}]) {
    var text = _strings[key] ?? key;
    for (final e in args.entries) {
      text = text.replaceAll('{${e.key}}', '${e.value}');
    }
    return text;
  }

  // --- Typed accessors (domain narrative) ---

  String get helpText => this['help_text'];
  String get gameOver => this['game_over'];
  String get emptyInputHint => this['empty_input_hint'];
  String unknownCommand(String cmd) => msg('unknown_command', {'cmd': cmd});
  String get mapToggleHint => this['map_toggle_hint'];

  String get roomUnknown => this['room_unknown'];
  String get roomTooDarkNeedLight => this['room_too_dark_need_light'];
  String roomItemsVisible(String items) =>
      msg('room_items_visible', {'items': items});
  String roomNpcPresent(String emoji, String name, String title) =>
      msg('room_npc_present', {'emoji': emoji, 'name': name, 'title': title});
  String roomMonsterPresent(
    String rankTag,
    String label,
    int hp,
    int maxHp,
  ) =>
      msg('room_monster_present', {
        'rank_tag': rankTag,
        'label': label,
        'hp': hp,
        'max_hp': maxHp,
      });
  String roomExits(String dirs) => msg('room_exits', {'dirs': dirs});

  String get moveBlockedCellBlock => this['move_blocked_cell_block'];
  String get moveBlocked682Pit => this['move_blocked_682_pit'];
  String get moveInCombat => this['move_in_combat'];
  String moveCannotGo(String dir) => msg('move_cannot_go', {'dir': dir});
  String get moveTooDark => this['move_too_dark'];
  String get graveGateOpened => this['grave_gate_opened'];

  String combatEnemiesAppeared(String names) =>
      msg('combat_enemies_appeared', {'names': names});
  String combatDefeatedEnemy(String name) =>
      msg('combat_defeated_enemy', {'name': name});
  String combatLootItem(String itemName) =>
      msg('combat_loot_item', {'item_name': itemName});
  String combatRewardGoldExp(int gold, int exp) =>
      msg('combat_reward_gold_exp', {'gold': gold, 'exp': exp});
  String get combatVictoryDefault => this['combat_victory_default'];
  String get combatContainmentBonus => this['combat_containment_bonus'];
  String get combatSiteBossSuppressed => this['combat_site_boss_suppressed'];
  String combatBossDefeated(String name) =>
      msg('combat_boss_defeated', {'name': name});
  String combatDefeat(int penalty) =>
      msg('combat_defeat', {'penalty': penalty});
  String get combatFled => this['combat_fled'];
  String get combatNoEnemy => this['combat_no_enemy'];
  String get combatTurnModeHint => this['combat_turn_mode_hint'];
  String get combatFleeFailed => this['combat_flee_failed'];
  String combatFleeFailedBlocked(String name) =>
      msg('combat_flee_failed_blocked', {'name': name});
  String get combatFleeCommandPending => this['combat_flee_command_pending'];
  String get itemEffectCleanse => this['item_effect_cleanse'];

  String inventoryHeader(
    String bagLabel,
    int weight,
    int capacity,
    int count,
  ) =>
      msg('inventory_header', {
        'bag_label': bagLabel,
        'weight': weight,
        'capacity': capacity,
        'count': count,
      });
  String get inventoryEmpty => this['inventory_empty'];
  String inventoryItemAtkBonus(int value) =>
      msg('inventory_item_atk_bonus', {'value': value});
  String inventoryItemDefBonus(int value) =>
      msg('inventory_item_def_bonus', {'value': value});
  String inventoryHpLine(int hp, int maxHp) =>
      msg('inventory_hp_line', {'hp': hp, 'max_hp': maxHp});
  String inventoryAtkDefLine(int atk, int def) =>
      msg('inventory_atk_def_line', {'atk': atk, 'def': def});
  String inventoryGoldScoreLine(int gold, int score) =>
      msg('inventory_gold_score_line', {'gold': gold, 'score': score});
  String get inventoryCompanionsHeader => this['inventory_companions_header'];
  String inventoryCompanionLine(
    String name,
    String role,
    int hp,
    int maxHp,
  ) =>
      msg('inventory_companion_line', {
        'name': name,
        'role': role,
        'hp': hp,
        'max_hp': maxHp,
      });
  String get defaultBagLabel => this['default_bag_label'];

  String get takeWhat => this['take_what'];
  String get combatCannotTake => this['combat_cannot_take'];
  String get takeNothingHere => this['take_nothing_here'];
  String takeMultiple(String items) => msg('take_multiple', {'items': items});
  String takeNotFound(String ref) => msg('take_not_found', {'ref': ref});
  String takeCannotPickUp(String name) =>
      msg('take_cannot_pick_up', {'name': name});
  String takeOverweight(int capacity) =>
      msg('take_overweight', {'capacity': capacity});
  String takePickedUp(String name, String extra) =>
      msg('take_picked_up', {'name': name, 'extra': extra});

  String get dropWhat => this['drop_what'];
  String get combatCannotDrop => this['combat_cannot_drop'];
  String dropNotFound(String ref) => msg('drop_not_found', {'ref': ref});
  String get dropCannotDropBag => this['drop_cannot_drop_bag'];
  String dropDropped(String name) => msg('drop_dropped', {'name': name});

  String get useWhat => this['use_what'];
  String useNotFound(String ref) => msg('use_not_found', {'ref': ref});
  String useCannotUse(String name) => msg('use_cannot_use', {'name': name});
  String useDefault(String name) => msg('use_default', {'name': name});
  String useHealDefault(int amount) =>
      msg('use_heal_default', {'amount': amount});

  String get scrollCombatBlocked => this['scroll_combat_blocked'];
  String get scrollNotOwned => this['scroll_not_owned'];
  String get scrollPickDestination => this['scroll_pick_destination'];
  String get scrollUsageHint => this['scroll_usage_hint'];
  String get scrollDestinationCurrent => this['scroll_destination_current'];
  String get scrollDestinationInvalid => this['scroll_destination_invalid'];
  String scrollAlreadyHere(String roomName) =>
      msg('scroll_already_here', {'room_name': roomName});
  String scrollTeleportSuccess(String roomName) =>
      msg('scroll_teleport_success', {'room_name': roomName});

  String get talkNoNpc => this['talk_no_npc'];
  String talkNpcHeader(String name, String title) =>
      msg('talk_npc_header', {'name': name, 'title': title});
  String get talkGreetDefault => this['talk_greet_default'];
  String talkNpcGiveItem(String name, String item) =>
      msg('talk_npc_give_item', {'name': name, 'item': item});
  String get talkExtraDefault => this['talk_extra_default'];
  String talkQuestSubmitReward(String item) =>
      msg('talk_quest_submit_reward', {'item': item});
  String talkQuestSubmitThanks(String name) =>
      msg('talk_quest_submit_thanks', {'name': name});
  String get talkScp079Unlock => this['talk_scp079_unlock'];
  String talkQuestAskDefault(String item) =>
      msg('talk_quest_ask_default', {'item': item});

  String get continueJourneyBanner => this['continue_journey'];
  String get mapShown => this['map_shown'];
  String get mapHidden => this['map_hidden'];
  String get devModeOn => this['dev_mode_on'];
  String get devModeOff => this['dev_mode_off'];
  String get mainClearAnnounced => this['main_clear_announced'];
  String get mainClearContinueHint => this['main_clear_continue_hint'];
  String get siteClearAnnounced => this['site_clear_announced'];
  String get siteClearContinueHint => this['site_clear_continue_hint'];
  String deathPenalty(int penalty) =>
      msg('death_penalty', {'penalty': penalty});
  String combatGoldBonus(int bonus) =>
      msg('combat_gold_bonus', {'bonus': bonus});
  String deathPenaltyRefund(int penalty) =>
      msg('death_penalty_refund', {'penalty': penalty});

  String mapLayerName(String layer) => this['map_layer_$layer'] ?? layer;
  String mapDirName(String dir) => this['map_dir_$dir'] ?? dir;
  String monsterRankName(String rank) => this['monster_rank_$rank'] ?? rank;

  String get playerName => this['player_name'];
  String get companionRecruitDefault => this['companion_recruit_default'];
  String roomItemsOnGround(String items) =>
      msg('room_items_on_ground', {'items': items});

  String combatAttack(
    String attacker,
    String target,
    int damage,
  ) =>
      msg('combat_attack', {
        'attacker': attacker,
        'target': target,
        'damage': damage,
      });
  String combatHeal(String healer, String target, int amount) =>
      msg('combat_heal', {
        'healer': healer,
        'target': target,
        'amount': amount,
      });
  String combatSkill(String attacker, String target, int damage) =>
      msg('combat_skill', {
        'attacker': attacker,
        'target': target,
        'damage': damage,
      });
  String combatItemUse(
    String user,
    String item,
    String target,
    int amount,
  ) =>
      msg('combat_item_use', {
        'user': user,
        'item': item,
        'target': target,
        'amount': amount,
      });
  String combatDeath(String name) => msg('combat_death', {'name': name});
  String combatStunned(String name) => msg('combat_stunned', {'name': name});
  String combatDefend(String name) => msg('combat_defend', {'name': name});
  String get combatFleeAttempt => this['combat_flee_attempt'];
  String get combatFleeSuccessRound => this['combat_flee_success_round'];

  String statusResist(String target, String effect) =>
      msg('status_resist', {'target': target, 'effect': effect});
  String statusApply(String target, String emoji, String effect) =>
      msg('status_apply', {'target': target, 'emoji': emoji, 'effect': effect});
  String statusCleanse(String target, String effect) =>
      msg('status_cleanse', {'target': target, 'effect': effect});
  String statusTickDamage(
    String name,
    String emoji,
    String effect,
    int damage,
  ) =>
      msg('status_tick_damage', {
        'name': name,
        'emoji': emoji,
        'effect': effect,
        'damage': damage,
      });
  String statusTickHeal(
    String name,
    String emoji,
    String effect,
    int amount,
  ) =>
      msg('status_tick_heal', {
        'name': name,
        'emoji': emoji,
        'effect': effect,
        'amount': amount,
      });
  String statusExpire(String name, String emoji, String effect) =>
      msg('status_expire', {
        'name': name,
        'emoji': emoji,
        'effect': effect,
      });

  String get turnCombatStarted => this['turn_combat_started'];
  String get meleeHpTooLow => this['melee_hp_too_low'];
  String get meleeCannotStart => this['melee_cannot_start'];
  String get meleeStarted => this['melee_started'];
  String get meleeStoppedLowHp => this['melee_stopped_low_hp'];
  String meleeRoundContinue(int round) =>
      msg('melee_round_continue', {'round': round});
  String combatRoundStart(int round) =>
      msg('combat_round_start', {'round': round});
}
