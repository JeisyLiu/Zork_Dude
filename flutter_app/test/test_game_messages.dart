import 'package:zork_dude/l10n/game_messages.dart';

/// Chinese copy for widget/unit tests until message JSON assets are bundled.
GameMessages testGameMessages() => GameMessages({
      'help_text': '命令列表',
      'combat_cannot_take': '战斗中不能拾取',
      'item_fishing_rod_success': '钓到了一条鱼',
      'item_fishing_rod_no_water': '没法钓鱼',
      'scroll_pick_destination': '已探索',
      'scroll_teleport_success': '传送',
      'map_layer_surface': '地表',
      'map_layer_cave': '洞穴',
      'map_layer_tower': '高塔',
      'map_layer_site': '设施',
      'grave_gate_opened': '魔法宝石',
      'room_haunted_graveyard_gate': '魔法宝石',
      'take_picked_up': '拾起了 {name}。{extra}',
      'combat_defeated_enemy': '击败了 {name}！',
      'inventory_header': '🎒',
    });
