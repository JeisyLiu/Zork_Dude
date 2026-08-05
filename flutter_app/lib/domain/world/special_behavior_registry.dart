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

    rooms['ancient_ruins']!.onEnter = (session) {
      if (session.hasItem('rusty_key') && !session.flags.containsKey('ruins_open')) {
        session.room('ancient_ruins').exits[Direction.north] = 'hidden_passage';
        session.flags['ruins_open'] = true;
        return '你用生锈钥匙打开了石门！';
      }
      if (session.flags.containsKey('ruins_open')) return null;
      if (!session.hasItem('rusty_key')) return '石门紧锁，需要钥匙。';
      return null;
    };

    rooms['tower_base']!.onEnter = (session) {
      if (session.hasItem('silver_key') && !session.flags.containsKey('tower_unlocked')) {
        session.room('tower_base').exits[Direction.up] = 'tower_middle';
        session.flags['tower_unlocked'] = true;
        return '银钥匙打开了塔门！';
      }
      if (session.flags.containsKey('tower_unlocked')) return '门已经开了。';
      return null;
    };

    rooms['tower_top']!.onEnter = (session) {
      final m = session.monster('dragon_whelp');
      return m != null && m.alive
          ? '一股强大的龙威扑面而来……'
          : '幼龙已经被击败，宝石唾手可得。';
    };

    rooms['lake_shore']!.onEnter = (session) {
      if (!session.flags.containsKey('boat_taken')) {
        session.room('lake_shore').exits[Direction.east] = 'lake_island';
        session.flags['boat_taken'] = true;
        return '你登上小船划向湖心岛……';
      }
      return '船已经在对岸了。';
    };

    rooms['goblin_throne']!.onEnter = (_) => '哥布林王咆哮着站起来！地面都在震动！';

    rooms['haunted_graveyard']!.onEnter = (session) {
      if (session.hasItem('keycard_lvl2') && !session.flags.containsKey('grave_site_open')) {
        session.room('haunted_graveyard').exits[Direction.east] = 'scp_site_gate';
        session.flags['grave_site_open'] = true;
        return '你用二级钥匙卡刷开了藤蔓缠绕的石门，一条向下的通道显露出来……';
      }
      return null;
    };

    rooms['scp_breach_chamber']!.onEnter = (session) {
      final lines = <String>[];
      final core = session.monster('scp_breach_core');
      if (core != null && core.alive) {
        lines.add('收容失效的异常核心在房间中央脉动，空气扭曲……');
      }
      if (!session.hasItem('scp_goggles') && !session.flags.containsKey('cognitive_hit')) {
        session.flags['cognitive_hit'] = true;
        const dmg = 5;
        session.playerHp = (session.playerHp - dmg).clamp(1, session.playerMaxHp);
        lines.add('认知危害袭来！你失去 $dmg 点 HP。（佩戴护目镜可避免）');
      }
      return lines.isEmpty ? null : lines.join('\n');
    };

    if (rooms.containsKey('scp_012_cell')) {
      rooms['scp_012_cell']!.onEnter = (_) =>
          '乐谱上的音符在视线里扭动，有什么东西催促你把它「写完」。';
    }

    if (rooms.containsKey('scp_096_cell')) {
      rooms['scp_096_cell']!.onEnter = (session) {
        final m = session.monster('scp_096');
        if (m != null && m.alive) {
          return session.hasItem('scp_goggles')
              ? '护目镜过滤了危险轮廓。苍白的身影仍在角落轻颤。'
              : '警告：不要直视它的脸！';
        }
        return '单元空了，只剩抓痕。';
      };
    }

    if (rooms.containsKey('scp_173_cell')) {
      rooms['scp_173_cell']!.onEnter = (session) {
        final m = session.monster('scp_173');
        return m != null && m.alive ? '不要眨眼。雕塑就在那里——或者说，曾经在那里。' : null;
      };
    }

    if (rooms.containsKey('scp_002_room')) {
      rooms['scp_002_room']!.onEnter = (session) {
        if (!session.flags.containsKey('scp_002_hit')) {
          session.flags['scp_002_hit'] = true;
          const dmg = 8;
          session.playerHp = (session.playerHp - dmg).clamp(1, session.playerMaxHp);
          return '血肉墙壁收缩！你被挤伤了，失去 $dmg 点 HP。';
        }
        return '房间仍在缓慢脉动……';
      };
    }

    if (rooms.containsKey('scp_087_depth')) {
      rooms['scp_087_depth']!.onEnter = (session) {
        const dmg = 3;
        session.playerHp = (session.playerHp - dmg).clamp(1, session.playerMaxHp);
        return '越往下越冷。你失去 $dmg 点 HP。';
      };
    }

    if (rooms.containsKey('scp_895_cctv')) {
      rooms['scp_895_cctv']!.onEnter = (session) {
        if (!session.hasItem('scp_goggles') && !session.flags.containsKey('scp_895_hit')) {
          session.flags['scp_895_hit'] = true;
          const dmg = 6;
          session.playerHp = (session.playerHp - dmg).clamp(1, session.playerMaxHp);
          return '你盯着棺材画面太久……头痛欲裂，失去 $dmg 点 HP。';
        }
        return '你强迫自己只看屏幕边缘。';
      };
    }

    if (rooms.containsKey('scp_682_pit')) {
      rooms['scp_682_pit']!.onEnter = (session) {
        final m = session.monster('scp_682');
        if (m != null && m.alive) return '酸液翻涌。某种巨大的东西正抬头——它恨你。';
        session.room('scp_682_pit').exits[Direction.east] = 'scp_001_vault';
        final finalBoss = session.monster('scp_001');
        if (finalBoss != null && finalBoss.alive) {
          return '酸池暂时平静。东侧厚重金属门缓缓打开——通向001号终焉收容库。';
        }
        return '酸池平静。001号收容库的门仍开着。';
      };
    }

    if (rooms.containsKey('scp_001_vault')) {
      rooms['scp_001_vault']!.onEnter = (session) {
        final m = session.monster('scp_001');
        return m != null && m.alive
            ? '终焉的压力压得你喘不过气……'
            : '收容库空旷下来。勋章与残骸证明：站点威胁已被压制。';
      };
    }
  }

  static void _items(GameSessionRef g) {
    final gem = g.item('magic_gem');
    if (gem != null) {
      final original = gem.onUse;
      gem.onUse = (session) {
        if (session.won) {
          return '你已经找回记忆、打破迷雾了。可继续探索站点，或输入 ng+ 开启二周目。';
        }
        if (session.currentRoomId == 'tower_top') {
          final dragon = session.monster('dragon_whelp');
          if (dragon != null && !dragon.alive) {
            session.won = true;
            return '宝石嵌入书桌凹槽！书籍爆发出耀眼的光芒——\n所有记忆涌回你的脑海！你是被封印的守护者，\n迷雾是高塔的结界。现在，你自由了！\n（主线完成——可继续探索，或 ng+ 二周目）';
          }
          if (dragon != null && dragon.alive) return '幼龙还在！必须先击败它！';
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
      return '你用血在谱上补了几个音符……手掌剧痛，失去 $dmg 点 HP。乐章仍未完结。';
    });

    setUse('scp_035_mask', (session) {
      session.flags['mask_035'] = true;
      const dmg = 4;
      session.playerHp = (session.playerHp - dmg).clamp(1, session.playerMaxHp);
      return '面具贴合面颊。力量涌来，同时有什么在啃噬你的意志（-$dmg HP）。攻击已大幅提升。';
    });

    setUse('scp_113_rock', (session) {
      if (session.flags.containsKey('scp_113_used')) return '石头已经失去活性。';
      session.flags['scp_113_used'] = true;
      session.playerMaxHp += 5;
      session.playerHp = (session.playerHp + 5).clamp(0, session.playerMaxHp);
      session.invRemove('scp_113_rock');
      return '基因重组完成！最大 HP +5。';
    });

    setUse('scp_513_bell', (session) {
      session.flags['bell_rung'] = true;
      session.score += 2;
      return '铃铛余音不散。你感觉多了一个「跟班」——最好别回头。';
    });

    setUse('scp_701_script', (session) {
      session.score += 5;
      return '你读完最后一句。虚空里响起掌声与哭喊，随即沉寂。得分 +5。';
    });

    setUse('scp_1981_tape', (session) {
      session.score += 8;
      const dmg = 2;
      session.playerHp = (session.playerHp - dmg).clamp(1, session.playerMaxHp);
      return '录像提供了站点结构线索（+8 分），但画面令人不适（-$dmg HP）。';
    });

    setUse('amnesia_pill', (session) {
      if (session.inCombat) {
        session.inCombat = false;
        session.currentEnemy = '';
        session.invRemove('amnesia_pill');
        return '你吞下药片，敌人茫然地环顾四周——你趁机脱离了战斗！';
      }
      return '现在没有战斗，药片只是让你短暂头晕了一下。';
    });
  }
}
