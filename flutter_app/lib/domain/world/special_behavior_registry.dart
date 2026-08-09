import 'package:zork_dude/domain/models/entities.dart';
import 'package:zork_dude/domain/models/enums.dart';

/// Registers room on_enter hooks and item on_use overrides from Python _apply_special_behaviors.
class SpecialBehaviorRegistry {
  static void apply(GameSessionRef g) {
    _rooms(g);
    _items(g);
  }

  static void _rooms(GameSessionRef g) {
    final rooms = g.rooms;
    final m = g.messages;

    rooms['ancient_ruins']!.onEnter = (session) {
      if (session.hasItem('rusty_key') && !session.flags.containsKey('ruins_open')) {
        session.room('ancient_ruins').exits[Direction.north] = 'hidden_passage';
        session.flags['ruins_open'] = true;
        return m.msg('room_ancient_ruins_key_opened');
      }
      if (session.flags.containsKey('ruins_open')) return null;
      if (!session.hasItem('rusty_key')) return m.msg('room_ancient_ruins_locked');
      return null;
    };

    rooms['tower_base']!.onEnter = (session) {
      if (session.hasItem('silver_key') && !session.flags.containsKey('tower_unlocked')) {
        session.room('tower_base').exits[Direction.up] = 'tower_foyer';
        session.flags['tower_unlocked'] = true;
        return m.msg('room_tower_base_unlocked');
      }
      if (session.flags.containsKey('tower_unlocked')) return m.msg('room_tower_base_already_open');
      if (!session.hasItem('silver_key')) return m.msg('room_tower_base_locked');
      return null;
    };

    if (rooms.containsKey('tower_ritual')) {
      rooms['tower_ritual']!.onEnter = (session) {
        if (session.hasItem('crystal_key') && !session.flags.containsKey('ritual_unlocked')) {
          session.room('tower_ritual').exits[Direction.up] = 'tower_top';
          session.flags['ritual_unlocked'] = true;
          return m.msg('room_tower_ritual_unlocked');
        }
        if (session.flags.containsKey('ritual_unlocked')) return null;
        if (!session.hasItem('crystal_key')) return m.msg('room_tower_ritual_locked');
        return null;
      };
    }

    rooms['tower_top']!.onEnter = (session) {
      final boss = session.monster('dragon_whelp');
      return boss != null && boss.alive
          ? m.msg('room_tower_top_dragon_alive')
          : m.msg('room_tower_top_dragon_dead');
    };

    rooms['goblin_throne']!.onEnter = (_) => m.msg('room_goblin_throne_enter');

    rooms['haunted_graveyard']!.onEnter = (session) {
      if (session.hasItem('magic_gem') && !session.flags.containsKey('grave_site_open')) {
        session.room('haunted_graveyard').exits[Direction.east] = 'scp_site_gate';
        session.flags['grave_site_open'] = true;
        return m.msg('room_haunted_graveyard_gate');
      }
      return null;
    };

    rooms['scp_breach_chamber']!.onEnter = (session) {
      final lines = <String>[];
      final core = session.monster('scp_breach_core');
      if (core != null && core.alive) {
        lines.add(m.msg('room_scp_breach_core_alive'));
      }
      if (!session.hasItem('scp_goggles') && !session.flags.containsKey('cognitive_hit')) {
        session.flags['cognitive_hit'] = true;
        const dmg = 5;
        session.playerHp = (session.playerHp - dmg).clamp(1, session.playerMaxHp);
        lines.add(m.msg('room_scp_breach_cognitive_hit', {'dmg': dmg}));
      }
      return lines.isEmpty ? null : lines.join('\n');
    };

    if (rooms.containsKey('scp_012_cell')) {
      rooms['scp_012_cell']!.onEnter = (_) => m.msg('room_scp_012_cell_enter');
    }

    if (rooms.containsKey('scp_096_cell')) {
      rooms['scp_096_cell']!.onEnter = (session) {
        final boss = session.monster('scp_096');
        if (boss != null && boss.alive) {
          return session.hasItem('scp_goggles')
              ? m.msg('room_scp_096_goggles')
              : m.msg('room_scp_096_warning');
        }
        return m.msg('room_scp_096_empty');
      };
    }

    if (rooms.containsKey('scp_173_cell')) {
      rooms['scp_173_cell']!.onEnter = (session) {
        final boss = session.monster('scp_173');
        return boss != null && boss.alive ? m.msg('room_scp_173_alive') : null;
      };
    }

    if (rooms.containsKey('scp_002_room')) {
      rooms['scp_002_room']!.onEnter = (session) {
        if (!session.flags.containsKey('scp_002_hit')) {
          session.flags['scp_002_hit'] = true;
          const dmg = 8;
          session.playerHp = (session.playerHp - dmg).clamp(1, session.playerMaxHp);
          return m.msg('room_scp_002_hit', {'dmg': dmg});
        }
        return m.msg('room_scp_002_pulse');
      };
    }

    if (rooms.containsKey('scp_087_depth')) {
      rooms['scp_087_depth']!.onEnter = (session) {
        const dmg = 3;
        session.playerHp = (session.playerHp - dmg).clamp(1, session.playerMaxHp);
        return m.msg('room_scp_087_depth', {'dmg': dmg});
      };
    }

    if (rooms.containsKey('scp_895_cctv')) {
      rooms['scp_895_cctv']!.onEnter = (session) {
        if (!session.hasItem('scp_goggles') && !session.flags.containsKey('scp_895_hit')) {
          session.flags['scp_895_hit'] = true;
          const dmg = 6;
          session.playerHp = (session.playerHp - dmg).clamp(1, session.playerMaxHp);
          return m.msg('room_scp_895_hit', {'dmg': dmg});
        }
        return m.msg('room_scp_895_edge');
      };
    }

    if (rooms.containsKey('scp_682_pit')) {
      rooms['scp_682_pit']!.onEnter = (session) {
        final boss = session.monster('scp_682');
        if (boss != null && boss.alive) return m.msg('room_scp_682_alive');
        session.room('scp_682_pit').exits[Direction.east] = 'scp_001_vault';
        final finalBoss = session.monster('scp_001');
        if (finalBoss != null && finalBoss.alive) {
          return m.msg('room_scp_682_gate_open');
        }
        return m.msg('room_scp_682_peaceful');
      };
    }

    if (rooms.containsKey('bandit_hideout')) {
      rooms['bandit_hideout']!.onEnter = (session) {
        final mimic = session.monster('mimic');
        if (mimic != null && !mimic.alive) {
          session.flags['bandit_cleared'] = true;
        }
        return null;
      };
    }

    if (rooms.containsKey('scp_001_vault')) {
      rooms['scp_001_vault']!.onEnter = (session) {
        final boss = session.monster('scp_001');
        return boss != null && boss.alive
            ? m.msg('room_scp_001_vault_alive')
            : m.msg('room_scp_001_vault_clear');
      };
    }
  }

  static void _items(GameSessionRef g) {
    final m = g.messages;
    final gem = g.item('magic_gem');
    if (gem != null) {
      final original = gem.onUse;
      gem.onUse = (session) {
        if (session.won) {
          return m.msg('item_magic_gem_already_won');
        }
        if (session.currentRoomId == 'tower_top') {
          final dragon = session.monster('dragon_whelp');
          if (dragon != null && !dragon.alive) {
            session.won = true;
            return m.msg('item_magic_gem_win');
          }
          if (dragon != null && dragon.alive) return m.msg('item_magic_gem_dragon_alive');
        }
        return original?.call(session) ?? gem.useMsg;
      };
    }

    void setUse(String id, ItemUseHandler handler) {
      final it = g.item(id);
      if (it != null) {
        it.usable = true;
        it.onUse = handler;
      }
    }

    setUse('scp_012_score', (session) {
      const dmg = 8;
      session.playerHp = (session.playerHp - dmg).clamp(1, session.playerMaxHp);
      session.score += 3;
      return m.msg('item_scp_012_score_use', {'dmg': dmg});
    });

    setUse('scp_035_mask', (session) {
      session.flags['mask_035'] = true;
      const dmg = 4;
      session.playerHp = (session.playerHp - dmg).clamp(1, session.playerMaxHp);
      return m.msg('item_scp_035_mask_use', {'dmg': dmg});
    });

    setUse('scp_113_rock', (session) {
      if (session.flags.containsKey('scp_113_used')) return m.msg('item_scp_113_used');
      session.flags['scp_113_used'] = true;
      session.playerMaxHp += 5;
      session.playerHp = (session.playerHp + 5).clamp(0, session.playerMaxHp);
      session.invRemove('scp_113_rock');
      return m.msg('item_scp_113_rock_use');
    });

    setUse('scp_513_bell', (session) {
      session.flags['bell_rung'] = true;
      session.score += 2;
      return m.msg('item_scp_513_bell_use');
    });

    setUse('scp_701_script', (session) {
      session.score += 5;
      return m.msg('item_scp_701_script_use');
    });

    setUse('scp_1981_tape', (session) {
      session.score += 8;
      const dmg = 2;
      session.playerHp = (session.playerHp - dmg).clamp(1, session.playerMaxHp);
      return m.msg('item_scp_1981_tape_use', {'dmg': dmg});
    });

    setUse('amnesia_pill', (session) {
      if (session.inCombat) {
        session.inCombat = false;
        session.currentEnemy = '';
        session.invRemove('amnesia_pill');
        return m.msg('item_amnesia_pill_combat');
      }
      return m.msg('item_amnesia_pill_idle');
    });

    setUse('fishing_rod', (session) {
      const waterRooms = {
        'lake_shore',
        'lake_island',
        'underground_river',
      };
      if (!waterRooms.contains(session.currentRoomId)) {
        return m.msg('item_fishing_rod_no_water');
      }
      if (session.item('fish') == null) {
        return m.msg('item_fishing_rod_no_bag');
      }
      session.invAdd('fish');
      session.score += 3;
      final place = session.rooms[session.currentRoomId]?.name ?? m.msg('item_fishing_rod_place_default');
      return m.msg('item_fishing_rod_success', {'place': place});
    });
  }
}
