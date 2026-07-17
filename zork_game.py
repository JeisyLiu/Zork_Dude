#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
===================
  迷雾之塔 · 完整版
  类 Zork 文字冒险游戏
===================
你从迷雾森林中醒来，失去记忆。
探索、收集、对话、招募、战斗、解谜。

数据驱动设计：所有实体定义（道具/怪物/NPC/队友/房间）
存放在 data/*.json 中，修改数据不需要动代码。
"""


import sys
import time
import random
import json
from pathlib import Path
from enum import Enum
from typing import Optional, Callable

# ── 辅助 ──

def print_slow(text: str, delay: float = 0.03):
    for ch in text:
        sys.stdout.write(ch)
        sys.stdout.flush()
        time.sleep(delay)
    print()

def input_prompt() -> str:
    try:
        cmd = input("\n> ").strip().lower()
    except (EOFError, KeyboardInterrupt):
        print("\n\n游戏结束。")
        sys.exit(0)
    return cmd

def roll_dice(sides: int = 6, times: int = 1) -> int:
    return sum(random.randint(1, sides) for _ in range(times))


# ══════════════════════════════════════════════
#  枚举
# ══════════════════════════════════════════════

class Direction(Enum):
    NORTH = "north"; SOUTH = "south"; EAST = "east"
    WEST = "west"; UP = "up"; DOWN = "down"
    @classmethod
    def from_str(cls, s: str) -> Optional["Direction"]:
        for d in cls:
            if d.value == s or d.value[0] == s: return d
        return None

class ItemType(Enum):
    KEY, WEAPON, ARMOR, POTION = "key","weapon","armor","potion"
    TREASURE, TOOL, LIGHT, SCROLL = "treasure","tool","light","scroll"
    FOOD, QUEST, MATERIAL, BOOK, RING = "food","quest","material","book","ring"
    AMULET, MINERAL = "amulet", "mineral"

class NpcType(Enum):
    MERCHANT, QUEST, WISEMAN = "merchant","quest","wiseman"
    HEALER, BEGGAR, GUARDIAN, WANDERER = "healer","beggar","guardian","wanderer"
    INNKEEPER, BLACKSMITH, HUNTER, PRIESTESS = "innkeeper","blacksmith","hunter","priestess"

class CompanionRole(Enum):
    WARRIOR, ROGUE, MAGE, HEALER, SCOUT = "warrior","rogue","mage","healer","scout"

class MonsterRank(Enum):
    NORMAL, ELITE, BOSS = "普通","精英","BOSS"


# ══════════════════════════════════════════════
#  物品类
# ══════════════════════════════════════════════

class Item:
    def __init__(self, iid: str, name: str, desc: str,
                 itype: ItemType = ItemType.TREASURE,
                 usable=False, takeable=True, use_msg="",
                 weight=1, value=0, heal=0,
                 dmg_bonus=0, def_bonus=0, emoji: str = ""):
        self.id = iid; self.name = name; self.desc = desc
        self.item_type = itype; self.usable = usable
        self.takeable = takeable; self.use_msg = use_msg
        self.weight = weight; self.value = value
        self.heal = heal; self.damage_bonus = dmg_bonus
        self.defense_bonus = def_bonus
        self.emoji = emoji or ""

    def __str__(self): return f"{self.emoji} {self.name}" if self.emoji else self.name

    @property
    def stackable(self) -> bool:
        return self.item_type in (ItemType.FOOD, ItemType.TREASURE, ItemType.MATERIAL)

    def on_use(self, game) -> str:
        if self.heal > 0:
            game.player_hp = min(game.player_max_hp, game.player_hp + self.heal)
            if self.use_msg:
                return self.use_msg
            return f"恢复了 {self.heal} 点生命值！"
        return self.use_msg or f"使用了 {self.name}。"


# ══════════════════════════════════════════════
#  怪物类
# ══════════════════════════════════════════════

class Monster:
    def __init__(self, mid: str, name: str, desc: str,
                 hp: int, atk: int, defense: int = 0,
                 rank: MonsterRank = MonsterRank.NORMAL,
                 loot: list = None, exp: int = 10, gold: int = 0,
                 hostile: bool = True, dialog: dict = None, emoji: str = ""):
        self.id = mid; self.name = name; self.desc = desc
        self.max_hp = hp; self.hp = hp
        self.attack = atk; self.defense = defense
        self.rank = rank; self.loot = loot or []
        self.exp = exp; self.gold = gold
        self.hostile = hostile; self.dialog = dialog or {}
        self.alive = True
        self.emoji = emoji or ""

    @property
    def hp_status(self) -> str:
        p = self.hp / self.max_hp * 100
        if p > 75: return "状态完好"
        if p > 50: return "受了些伤"
        if p > 25: return "伤势严重"
        if p > 0:  return "奄奄一息"
        return "已死亡"

    def take_damage(self, dmg: int) -> int:
        actual = max(0, dmg - self.defense)
        self.hp = max(0, self.hp - actual)
        if self.hp <= 0: self.alive = False
        return actual

    def attack_damage(self) -> dict:
        base = max(1, self.attack + roll_dice(4) - 3)
        return {"dmg": base, "msg": f"{self.name} 向你攻击！"}


# ══════════════════════════════════════════════
#  NPC 类
# ══════════════════════════════════════════════

class NPC:
    def __init__(self, nid: str, name: str, title: str, desc: str,
                 npc_type: NpcType = NpcType.WANDERER,
                 dialogs: dict = None,
                 trade_items: list = None, buys_types: list = None,
                 quest_item: str = None, quest_reward: str = None,
                 quest_score: int = 30, give_item: str = None, emoji: str = ""):
        self.id = nid; self.name = name; self.title = title; self.desc = desc
        self.npc_type = npc_type; self.dialogs = dialogs or {}
        self.trade_items = trade_items or []; self.buys_types = buys_types or []
        self.quest_item = quest_item; self.quest_reward = quest_reward
        self.quest_score = quest_score; self.give_item = give_item
        self.quest_done = False; self.met_before = False
        self.emoji = emoji or ""

    def on_talk(self, game) -> str:
        lines = [f"[{self.name} · {self.title}]", self.desc]
        d = self.dialogs
        if not self.met_before:
            self.met_before = True
            lines.append(f"\n{self.name}：「{d.get('greet','你好。')}」")
            if self.give_item and self.give_item in game.items and self.give_item not in game.inventory:
                game._inv_add(self.give_item)
                lines.append(f"\n{self.name} 给了你 {game.items[self.give_item].name}！")
                game.score += 5
        else:
            lines.append(f"\n{self.name}：「{d.get('extra',d.get('farewell','还有什么事？'))}」")

        # 任务
        if self.quest_item and not self.quest_done:
            if self.quest_item in game.inventory:
                game._inv_remove(self.quest_item)
                if self.quest_reward:
                    game._inv_add(self.quest_reward)
                    lines.append(f"\n✨ 提交任务！获得 {game.items[self.quest_reward].name}！")
                else:
                    lines.append(f"\n✨ {self.name} 感谢你！")
                game.score += self.quest_score
                self.quest_done = True
            else:
                qi = game.items.get(self.quest_item)
                if qi:
                    lines.append(f"\n💬 {self.name}：{d.get('quest',f'帮我找 {qi.name} 好吗？')}")

        if self.npc_type == NpcType.MERCHANT:
            lines.append(f"\n🛒 输入 trade / buy <物品> / sell <物品>")
        if self.npc_type == NpcType.HEALER:
            lines.append(f"\n💚 我可以为你治疗 (输入 heal)")

        return "\n".join(lines)

    def on_trade(self, game) -> str:
        if self.npc_type != NpcType.MERCHANT or not self.trade_items:
            return f"{self.name} 没有商品。"
        lines = [f"\n🛒 {self.name} 的商品："]
        for idx, (iid, price) in enumerate(self.trade_items, 1):
            it = game.items.get(iid)
            if it: lines.append(f"  ({idx}) {it.name} —— {price} 金币")
        lines.append(f"💰 你有 {game.gold} 金币")
        return "\n".join(lines)

    def on_buy(self, game, name: str) -> str:
        if self.npc_type != NpcType.MERCHANT: return f"{self.name} 不是商人。"
        # 支持数字序号
        try:
            idx = int(name)
            if 1 <= idx <= len(self.trade_items):
                iid, price = self.trade_items[idx - 1]
                it = game.items.get(iid)
                if game.gold >= price:
                    game.gold -= price; game._inv_add(iid)
                    return f"购买了 {it.name}！花费 {price} 金币。"
                return f"需要 {price} 金币，你只有 {game.gold}。"
        except ValueError:
            pass
        for iid, price in self.trade_items:
            it = game.items.get(iid)
            if it and (name == it.name.lower() or name == it.id.lower()):
                if game.gold >= price:
                    game.gold -= price; game._inv_add(iid)
                    return f"购买了 {it.name}！花费 {price} 金币。"
                return f"需要 {price} 金币，你只有 {game.gold}。"
        return f"没有 '{name}'。"

    def on_sell(self, game, name: str) -> str:
        if self.npc_type != NpcType.MERCHANT: return f"{self.name} 不是商人。"
        # 支持数字序号（引用背包物品）
        try:
            idx = int(name)
            inv_list = list(game.inventory)
            if 1 <= idx <= len(inv_list):
                iid = inv_list[idx - 1]
                it = game.items.get(iid)
                if it and it.item_type in self.buys_types:
                    price = max(2, it.value // 2)
                    game._inv_remove(iid); game.gold += price
                    return f"卖了 {it.name}，获得 {price} 金币。"
                return "不收这种物品。"
        except ValueError:
            pass
        for iid in list(game.inventory):
            it = game.items.get(iid)
            if it and (name == it.name.lower() or name == it.id.lower()):
                if it.item_type in self.buys_types:
                    price = max(2, it.value // 2)
                    game._inv_remove(iid); game.gold += price
                    return f"卖了 {it.name}，获得 {price} 金币。"
                return f"不收这种物品。"
        return f"没有 '{name}'。"

    def on_heal(self, game) -> str:
        if self.npc_type != NpcType.HEALER:
            return f"{self.name} 不会治疗。"
        cost = 10
        if game.gold < cost: return f"治疗需要 {cost} 金币。"
        game.gold -= cost
        heal_amt = roll_dice(6, 3)
        game.player_hp = min(game.player_max_hp, game.player_hp + heal_amt)
        return f"{self.name} 为你治疗，恢复了 {heal_amt} 点HP！花费 {cost} 金币。"


# ══════════════════════════════════════════════
#  队友类
# ══════════════════════════════════════════════

class Companion:
    def __init__(self, cid: str, name: str, desc: str,
                 role: CompanionRole = CompanionRole.WARRIOR,
                 hp: int = 50, atk: int = 8, defense: int = 2,
                 ability_desc: str = "", recruit_item: str = None,
                 recruit_msg: str = "加入了你的队伍！", emoji: str = ""):
        self.id = cid; self.name = name; self.desc = desc
        self.role = role; self.max_hp = hp; self.hp = hp
        self.attack = atk; self.defense = defense
        self.ability_desc = ability_desc
        self.recruit_item = recruit_item; self.recruit_msg = recruit_msg
        self.recruited = False
        self.emoji = emoji or ""

    def get_bonus(self) -> dict:
        return {
            CompanionRole.WARRIOR: {"dmg": 3, "def": 2, "hp": 10},
            CompanionRole.ROGUE:   {"dmg": 2, "def": 0, "hp": 5},
            CompanionRole.MAGE:    {"dmg": 5, "def": -1, "hp": 0},
            CompanionRole.HEALER:  {"dmg": 0, "def": 1, "hp": 15},
            CompanionRole.SCOUT:   {"dmg": 1, "def": 0, "hp": 5},
        }.get(self.role, {"dmg": 0, "def": 0, "hp": 0})

    def combat_assist(self, game) -> str:
        if self.role == CompanionRole.MAGE:
            return f"{self.name} 释放魔法箭！额外 3 伤害！"
        if self.role == CompanionRole.HEALER:
            h = roll_dice(6, 2)
            game.player_hp = min(game.player_max_hp, game.player_hp + h)
            return f"{self.name} 为你恢复 {h} 点HP！"
        if self.role == CompanionRole.ROGUE and random.random() < 0.4:
            return f"{self.name} 偷袭！额外 4 伤害！"
        return f"{self.name} 正在奋战！"

    def banter(self) -> str:
        msgs = {
            CompanionRole.WARRIOR: "哼，这点小伤不算什么。",
            CompanionRole.ROGUE: "嘿，前面可能有陷阱。",
            CompanionRole.MAGE: "我能感觉到魔法的波动……",
            CompanionRole.HEALER: "大家注意安全。",
            CompanionRole.SCOUT: "我去前面探探路。",
        }
        return f"[{self.name}] {msgs.get(self.role, '…')}"


# ══════════════════════════════════════════════
#  房间
# ══════════════════════════════════════════════

class Room:
    def __init__(self, rid: str, name: str, desc: str,
                 exits: dict = None, items: list = None,
                 dark: bool = False,
                 npc_id: str = None, monster_id: str = None,
                 on_enter: Callable = None, on_look: Callable = None,
                 emoji: str = ""):
        self.id = rid; self.name = name; self.desc = desc
        self.exits = exits or {}; self.items = items or []
        self.dark = dark; self.npc_id = npc_id; self.monster_id = monster_id
        self.visited = False
        self.on_enter = on_enter; self.on_look = on_look
        self.emoji = emoji or ""

    def description(self, game) -> str:
        if self.dark and not game.has_light():
            return "🌑 一片漆黑！你需要光源。"
        title = f"{self.emoji} {self.name}" if self.emoji else self.name
        text = f"[{title}]\n"
        text += self.desc if not self.visited else self.desc.split("\n")[0]

        # 物品（加数字序号）
        its = [game.items[i] for i in self.items if i in game.items]
        if its:
            numbered = ', '.join(
                f"({i}) {getattr(it, 'emoji', '') + ' ' if getattr(it, 'emoji', '') else ''}{it.name}"
                for i, it in enumerate(its, 1)
            )
            text += f"\n\n可见物品：{numbered}"

        # NPC
        if self.npc_id and self.npc_id in game.npcs:
            n = game.npcs[self.npc_id]
            nemoji = getattr(n, "emoji", "") or "👤"
            text += f"\n{nemoji} {n.name}（{n.title}）"

        # 怪物
        if self.monster_id and self.monster_id in game.monsters:
            m = game.monsters[self.monster_id]
            if m.alive:
                tag = f"[{m.rank.value}]" if m.rank != MonsterRank.NORMAL else ""
                memoji = getattr(m, "emoji", "")
                mname = f"{memoji} {m.name}" if memoji else m.name
                text += f"\n⚠️ {tag} {mname}（{m.hp_status}）"

        text += f"\n出口：{', '.join(d.value for d in self.exits)}"
        return text


# ══════════════════════════════════════════════
#  游戏主类
# ══════════════════════════════════════════════

class Game:
    def __init__(self):
        self.rooms: dict[str, Room] = {}
        self.items: dict[str, Item] = {}
        self.npcs: dict[str, NPC] = {}
        self.monsters: dict[str, Monster] = {}
        self.companions: dict[str, Companion] = {}
        self.inventory: dict[str, int] = {}  # item_id → 数量（可叠加物品>1）
        self.companion_list: list[str] = []
        self.current_room_id = ""
        self.turns = 0; self.score = 0; self.gold = 30
        self.player_hp = 60; self.player_max_hp = 60
        self.player_atk_bonus = 0; self.player_def_bonus = 0
        self.game_over = False; self.won = False
        self.flags: dict = {}
        self.in_combat = False; self.current_enemy = ""

    # ── 背包辅助方法（叠加支持）──

    def _inv_add(self, iid: str, count: int = 1):
        """向背包添加物品，可叠加物品自动合并"""
        it = self.items.get(iid)
        if it and it.stackable:
            new = self.inventory.get(iid, 0) + count
            self.inventory[iid] = min(new, 999)  # 上限999
        else:
            # 非叠加物品：已有则不重复添加，没有则置1
            if iid not in self.inventory:
                self.inventory[iid] = count

    def _inv_remove(self, iid: str, count: int = 1):
        """从背包移除物品，可叠加物品支持部分移除"""
        it = self.items.get(iid)
        cur = self.inventory.get(iid, 0)
        if cur <= 0:
            return
        if it and it.stackable:
            if cur <= count:
                del self.inventory[iid]
            else:
                self.inventory[iid] -= count
        else:
            if iid in self.inventory:
                del self.inventory[iid]

    def _inv_count(self, iid: str) -> int:
        """获取物品数量（非叠加物品返回0或1）"""
        return self.inventory.get(iid, 0)

    @property
    def total_atk(self) -> int:
        b = self.player_atk_bonus
        for iid in self.inventory:
            it = self.items.get(iid)
            if it: b += it.damage_bonus
        for cid in self.companion_list:
            c = self.companions.get(cid)
            if c: b += c.get_bonus()["dmg"]
        return b

    @property
    def total_def(self) -> int:
        b = self.player_def_bonus
        for iid in self.inventory:
            it = self.items.get(iid)
            if it: b += it.defense_bonus
        for cid in self.companion_list:
            c = self.companions.get(cid)
            if c: b += c.get_bonus()["def"]
        return b

    def has_light(self) -> bool:
        if self.current_room_id in ("tower_top",): return True
        for iid in self.inventory:
            it = self.items.get(iid)
            if it and it.item_type == ItemType.LIGHT: return True
        for cid in self.companion_list:
            c = self.companions.get(cid)
            if c and c.role == CompanionRole.MAGE: return True
        return False

    def has_item(self, iid: str) -> bool:
        return iid in self.inventory

    def _total_weight(self) -> int:
        """总负重：可叠加物品只算一次重量，非叠加物品每个都算"""
        total = 0
        for iid, cnt in self.inventory.items():
            it = self.items.get(iid)
            if it:
                if it.stackable:
                    total += it.weight  # 叠加物品只算一次
                else:
                    total += it.weight * cnt
        return total

    # ── 移动 ──

    def do_go(self, dstr: str) -> str:
        if self.in_combat: return "战斗中！(attack/flee)"
        d = Direction.from_str(dstr)
        if not d: return f"不能往 {dstr}。"
        room = self.rooms[self.current_room_id]
        if d not in room.exits: return f"不能往 {d.value}。"
        if room.dark and not self.has_light(): return "🌑 太黑了不敢走。"
        nid = room.exits[d]
        self.current_room_id = nid
        nr = self.rooms[nid]
        extra = ""
        if nr.on_enter:
            r = nr.on_enter(self)
            if r: extra = f"\n\n{r}"
        if not nr.visited:
            nr.visited = True; self.score += 10
        combat = self._check_combat()
        if combat: extra += f"\n\n{combat}"
        return f"{nr.description(self)}{extra}"

    def _check_combat(self) -> str:
        room = self.rooms[self.current_room_id]
        if room.monster_id and room.monster_id in self.monsters:
            m = self.monsters[room.monster_id]
            if m.alive and m.hostile and not self.in_combat:
                self.in_combat = True; self.current_enemy = m.id
                return f"⚔️ {m.name} 出现了！"

    # ── 探索 ──

    def do_look(self, args) -> str:
        rm = self.rooms[self.current_room_id]
        rm.visited = False
        desc = rm.description(self)
        if rm.on_look:
            r = rm.on_look(self)
            if r: desc += f"\n\n{r}"
        return desc

    # ── 物品 ──

    def _resolve_item_ref(self, ref: str, candidates) -> str:
        """
        通用物品引用解析：支持 数字序号 / 物品名 / 物品id
        candidates: item_id 的可迭代对象（list 或 dict keys）
        返回匹配的 item_id，未找到返回 None
        """
        # 尝试数字序号（1-based）
        try:
            idx = int(ref)
            cand_list = list(candidates)
            if 1 <= idx <= len(cand_list):
                return cand_list[idx - 1]
        except ValueError:
            pass
        # 按名称或 id 模糊匹配
        t = ref.lower().strip()
        for iid in candidates:
            it = self.items.get(iid)
            if it and (t == it.name.lower() or t == it.id.lower() or t in it.name.lower()):
                return iid
        return None

    def do_inventory(self, args) -> str:
        total_items = sum(self.inventory.values())  # 实际物品总件数
        lines = [f"🎒 背包 (重量 {self._total_weight()}/{12} · 共 {total_items} 件)"]
        if self.inventory:
            for idx, (iid, cnt) in enumerate(self.inventory.items(), 1):
                it = self.items.get(iid)
                if it:
                    label = f"  ({idx}) {it.name}"
                    if it.stackable and cnt > 1:
                        label += f" x{cnt}"
                    label += f" ({it.item_type.value})"
                    lines.append(label)
        else: lines.append("  (空)")
        lines.append(f"\n❤️ HP: {self.player_hp}/{self.player_max_hp}")
        lines.append(f"💰 金币: {self.gold} | 🏆 得分: {self.score}")
        if self.companion_list:
            lines.append("👥 队友：")
            for cid in self.companion_list:
                c = self.companions.get(cid)
                if c: lines.append(f"  · {c.name} [{c.role.value}] HP:{c.hp}/{c.max_hp}")
        return "\n".join(lines)

    def do_take(self, args) -> str:
        if not args: return "拿什么？ 用 take all 拿全部，或用序号 take 1"
        t = " ".join(args)
        if self.in_combat: return "战斗中不能拾取！"
        rm = self.rooms[self.current_room_id]

        # take all → 拾取全部
        if t == "all":
            taken = []
            for iid in list(rm.items):
                it = self.items.get(iid)
                if it and it.takeable:
                    already_had = iid in self.inventory
                    if not already_had and self._total_weight() + it.weight > 12:
                        continue  # 放不下了
                    rm.items.remove(iid)
                    self._inv_add(iid)
                    self.score += 5
                    taken.append(it.name)
            if not taken:
                return "这里没有能拿的东西。"
            return f"拾取了：{'、'.join(taken)}。"

        # 按序号/名称/id 拾取
        found = self._resolve_item_ref(t, rm.items)
        if not found: return f"没有 {t}。"
        it = self.items[found]
        if not it.takeable: return f"拿不起 {it.name}。"
        # 重量检查：非叠加物品首次拿取、叠加物品首次拿取时需要检查
        already_had = found in self.inventory
        if not already_had and self._total_weight() + it.weight > 12:
            return "负重满了（12）。"
        rm.items.remove(found)
        self._inv_add(found)
        self.score += 5
        return f"拾起了 {it.name}。"

    def do_drop(self, args) -> str:
        if not args: return "丢什么？ 用序号 drop 1"
        t = " ".join(args)
        if self.in_combat: return "战斗中不能丢弃！"
        found = self._resolve_item_ref(t, self.inventory)
        if not found: return f"没有 {t}。"
        self._inv_remove(found)
        self.rooms[self.current_room_id].items.append(found)
        it = self.items[found]
        return f"丢下了 {it.name}。"

    def do_use(self, args) -> str:
        if not args: return "用什么？ 用序号 use 1"
        t = " ".join(args)
        found = self._resolve_item_ref(t, self.inventory)
        if not found: return f"没有 {t}。"
        it = self.items[found]
        if not it.usable: return f"{it.name} 不能用。"
        msg = it.on_use(self)
        if it.item_type in (ItemType.POTION, ItemType.FOOD):
            self._inv_remove(found)  # 消耗一个
        self.score += 2
        return msg or f"使用了 {it.name}。"

    # ── NPC ──

    def do_talk(self, args) -> str:
        rm = self.rooms[self.current_room_id]
        if not rm.npc_id or rm.npc_id not in self.npcs: return "这里没有可对话的人。"
        return self.npcs[rm.npc_id].on_talk(self)

    def do_trade(self, args) -> str:
        rm = self.rooms[self.current_room_id]
        if not rm.npc_id or rm.npc_id not in self.npcs: return "没有商人。"
        return self.npcs[rm.npc_id].on_trade(self)

    def do_buy(self, args) -> str:
        if not args: return "买什么？"
        rm = self.rooms[self.current_room_id]
        if not rm.npc_id or rm.npc_id not in self.npcs: return "没有商人。"
        return self.npcs[rm.npc_id].on_buy(self, " ".join(args))

    def do_sell(self, args) -> str:
        if not args: return "卖什么？"
        rm = self.rooms[self.current_room_id]
        if not rm.npc_id or rm.npc_id not in self.npcs: return "没有商人。"
        return self.npcs[rm.npc_id].on_sell(self, " ".join(args))

    def do_heal(self, args) -> str:
        rm = self.rooms[self.current_room_id]
        if not rm.npc_id or rm.npc_id not in self.npcs: return "没有治疗者。"
        return self.npcs[rm.npc_id].on_heal(self)

    # ── 战斗 ──

    def do_attack(self, args) -> str:
        if not self.in_combat: return "没有敌人。"
        m = self.monsters.get(self.current_enemy)
        if not m or not m.alive: self.in_combat = False; return "敌人已死。"
        dmg = roll_dice(6) + self.total_atk
        actual = m.take_damage(dmg)
        lines = [f"你攻击 {m.name}！造成 {actual} 点伤害。"]
        if not m.alive:
            lines.append(f"\n🎉 击败了 {m.name}！")
            for li in m.loot:
                if li in self.items:
                    self._inv_add(li)
                    lines.append(f"🏆 战利品：{self.items[li].name}")
            self.gold += m.gold; self.score += m.exp
            lines.append(f"💰 +{m.gold}金币 +{m.exp}经验")
            self.in_combat = False; self.current_enemy = ""
            if m.rank == MonsterRank.BOSS:
                lines.append(f"\n💀 BOSS【{m.name}】被击败！")
            if self.companion_list:
                c = self.companions.get(self.companion_list[0])
                if c: lines.append(f"\n{c.banter()}")
            return "\n".join(lines)
        # 反击
        ma = m.attack_damage()
        rd = max(0, ma["dmg"] - self.total_def)
        self.player_hp -= rd
        lines.append(f"{m.name} 反击！造成 {rd} 点伤害。")
        if self.companion_list:
            c = self.companions.get(self.companion_list[0])
            if c: lines.append(f"\n{c.combat_assist(self)}")
        if self.player_hp <= 0:
            lines.append(f"\n💀 你被 {m.name} 击败了……")
            self.game_over = True
            return "\n".join(lines)
        lines.append(f"\n{m.name}: {m.hp}/{m.max_hp} | 你的HP: {self.player_hp}/{self.player_max_hp}")
        return "\n".join(lines)

    def do_flee(self, args) -> str:
        if not self.in_combat: return "没有战斗。"
        if random.random() < 0.5:
            self.in_combat = False; self.current_enemy = ""
            return "你逃跑了！"
        m = self.monsters.get(self.current_enemy)
        return f"逃跑失败！{m.name if m else '敌人'} 挡住了路。"

    # ── 队友 ──

    def do_recruit(self, args) -> str:
        rm = self.rooms[self.current_room_id]
        if not rm.npc_id: return "这里没有可招募的人。"
        npc = self.npcs.get(rm.npc_id)
        if not npc: return "没有可招募的目标。"

        # 检查是否有对应的队友定义
        cid_map = {
            "old_hermit": "companion_warrior",
            "wandering_rogue": "companion_rogue",
            "priestess": "companion_healer",
            "hunter": "companion_scout",
            "bounty_hunter": "companion_archer",
        }
        cid = cid_map.get(rm.npc_id)
        if not cid or cid not in self.companions:
            return f"{npc.name} 看起来不想加入你。"

        c = self.companions[cid]
        if c.recruited: return f"{c.name} 已经是你的队友了。"

        # 检查招募条件
        if c.recruit_item and c.recruit_item not in self.inventory:
            needed = self.items.get(c.recruit_item)
            return f"招募 {c.name} 需要 {needed.name if needed else c.recruit_item}。"

        if c.recruit_item and c.recruit_item in self.inventory:
            self._inv_remove(c.recruit_item)

        c.recruited = True
        self.companion_list.append(cid)
        rm.npc_id = None  # NPC离开
        self.score += 20
        return f"✨ {c.name} {c.recruit_msg}"

    def do_party(self, args) -> str:
        if not self.companion_list: return "你目前没有队友。"
        lines = ["👥 你的队友："]
        for cid in self.companion_list:
            c = self.companions.get(cid)
            if c:
                b = c.get_bonus()
                lines.append(f"  {c.name} [{c.role.value}] HP:{c.hp}/{c.max_hp}")
                lines.append(f"  攻击+{b['dmg']} 防御+{b['def']}")
                lines.append(f"  能力：{c.ability_desc}")
        return "\n".join(lines)

    # ── 系统 ──

    def do_help(self, args) -> str: return HELP_TEXT
    def do_score(self, args) -> str:
        return f"🏆 {self.score}分 | 💰 {self.gold}金币 | 🎯 {self.turns}回合 | ❤️ {self.player_hp}/{self.player_max_hp}HP"
    def do_quit(self, args) -> str: self.game_over = True; return "再见！"

    COMMANDS = {
        "look":("探索",do_look,"查看"), "l":("探索",do_look,""),
        "north":("移动",lambda s,a:s.do_go("north"),""), "n":("",lambda s,a:s.do_go("north"),""),
        "south":("移动",lambda s,a:s.do_go("south"),""), "s":("",lambda s,a:s.do_go("south"),""),
        "east":("移动",lambda s,a:s.do_go("east"),""), "e":("",lambda s,a:s.do_go("east"),""),
        "west":("移动",lambda s,a:s.do_go("west"),""), "w":("",lambda s,a:s.do_go("west"),""),
        "up":("移动",lambda s,a:s.do_go("up"),""), "u":("",lambda s,a:s.do_go("up"),""),
        "down":("移动",lambda s,a:s.do_go("down"),""), "d":("",lambda s,a:s.do_go("down"),""),
        "take":("物品",do_take,"拾取"), "get":("物品",do_take,""),
        "drop":("物品",do_drop,"丢弃"),
        "inventory":("物品",do_inventory,"背包"), "i":("物品",do_inventory,""),
        "use":("物品",do_use,"使用"),
        "attack":("战斗",do_attack,"攻击"), "fight":("战斗",do_attack,""),
        "flee":("战斗",do_flee,"逃跑"),
        "talk":("社交",do_talk,"对话"), "say":("社交",do_talk,""),
        "trade":("社交",do_trade,"交易"),
        "buy":("社交",do_buy,"购买"), "sell":("社交",do_sell,"出售"),
        "heal":("社交",do_heal,"治疗"),
        "recruit":("队友",do_recruit,"招募"),
        "party":("队友",do_party,"队友状态"), "companions":("队友",do_party,""),
        "help":("系统",do_help,"帮助"), "h":("系统",do_help,""),
        "score":("系统",do_score,"状态"), "status":("系统",do_score,""),
        "quit":("系统",do_quit,"退出"), "exit":("系统",do_quit,""),
    }

    def process_command(self, raw: str) -> str:
        self.turns += 1
        if not raw.strip(): return "输入 help。"
        parts = raw.split(); cmd = parts[0]; args = parts[1:]
        if cmd in self.COMMANDS:
            _, func, _ = self.COMMANDS[cmd]
            return func(self, args)
        for key in self.COMMANDS:
            if key.startswith(cmd):
                _, func, _ = self.COMMANDS[key]
                return func(self, args)
        return f"不懂 '{cmd}'。输入 help。"

    def run(self):
        print_slow(WELCOME_TEXT, 0.02)
        input("\n按 Enter 开始冒险……")
        while not self.game_over:
            rm = self.rooms[self.current_room_id]
            if not rm.visited:
                rm.visited = True
                print_slow(f"\n{rm.description(self)}", 0.025)
                if self.in_combat: print_slow("\n⚔️ 战斗开始！attack/flee", 0.02)
            else:
                print(f"\n{rm.description(self)}")
                if self.in_combat: print("⚔️ 战斗中！")
            cmd = input_prompt()
            result = self.process_command(cmd)
            print_slow(f"\n{result}", 0.02)
            if self.won:
                print_slow(f"\n{'='*50}")
                print_slow("🎉 你找回了所有记忆，打破了迷雾诅咒！")
                print_slow(f"得分：{self.score}  回合：{self.turns}")
                print_slow(f"{'='*50}"); break
            if self.player_hp <= 0:
                print_slow(f"\n💀 你死了……得分：{self.score}"); break
        if self.game_over and not self.won and self.player_hp > 0:
            print(f"\n游戏结束。得分：{self.score}")



# ══════════════════════════════════════════════
#  世界构建
# ══════════════════════════════════════════════

DATA_DIR = Path(__file__).parent / "data"

def _load_json(filename: str):
    with open(DATA_DIR / filename, "r", encoding="utf-8") as f:
        return json.load(f)

def _parse_item_type(s: str) -> ItemType:
    return ItemType[s]

def _parse_npc_type(s: str) -> NpcType:
    return NpcType[s]

def _parse_monster_rank(s: str) -> MonsterRank:
    return MonsterRank[s]

def _parse_companion_role(s: str) -> CompanionRole:
    return CompanionRole[s]

def build_world() -> Game:
    g = Game()

    # ── 道具定义（从 data/items.json 加载）──
    items = _load_json("items.json")
    for d in items:
        it = Item(
            iid=d["id"], name=d["name"], desc=d["desc"],
            itype=_parse_item_type(d["type"]),
            usable=d.get("usable", False), takeable=d.get("takeable", True),
            use_msg=d.get("use_msg", ""),
            weight=d.get("weight", 1), value=d.get("value", 0),
            heal=d.get("heal", 0),
            dmg_bonus=d.get("dmg_bonus", 0), def_bonus=d.get("def_bonus", 0),
            emoji=d.get("emoji", "")
        )
        g.items[it.id] = it


    # ── 怪物定义（从 data/monsters.json 加载）──
    monsters_data = _load_json("monsters.json")
    for d in monsters_data:
        m = Monster(
            mid=d["id"], name=d["name"], desc=d["desc"],
            hp=d["hp"], atk=d["atk"], defense=d.get("defense", 0),
            rank=_parse_monster_rank(d["rank"]) if "rank" in d else MonsterRank.NORMAL,
            loot=d.get("loot", []), exp=d.get("exp", 10), gold=d.get("gold", 0),
            hostile=d.get("hostile", True), dialog=d.get("dialog"),
            emoji=d.get("emoji", "")
        )
        g.monsters[m.id] = m

    # ── NPC定义（从 data/npcs.json 加载）──
    npcs_data = _load_json("npcs.json")
    for d in npcs_data:
        # 交易商品列表：[ ["item_id", price], ... ]
        trade = d.get("trade_items")
        if trade:
            trade = [(pair[0], pair[1]) for pair in trade]
        # 收购类型
        buys = d.get("buys_types")
        if buys:
            buys = [_parse_item_type(t) for t in buys]
        n = NPC(
            nid=d["id"], name=d["name"], title=d.get("title",""),
            desc=d.get("desc",""),
            npc_type=_parse_npc_type(d["type"]) if "type" in d else NpcType.WANDERER,
            dialogs=d.get("dialogs"),
            trade_items=trade, buys_types=buys,
            quest_item=d.get("quest_item"), quest_reward=d.get("quest_reward"),
            quest_score=d.get("quest_score", 30), give_item=d.get("give_item"),
            emoji=d.get("emoji", "")
        )
        g.npcs[n.id] = n

    # ── 队友定义（从 data/companions.json 加载）──
    companions_data = _load_json("companions.json")
    for d in companions_data:
        c = Companion(
            cid=d["id"], name=d["name"], desc=d.get("desc",""),
            role=_parse_companion_role(d["role"]) if "role" in d else CompanionRole.WARRIOR,
            hp=d.get("hp", 50), atk=d.get("atk", 8), defense=d.get("defense", 2),
            ability_desc=d.get("ability_desc", ""),
            recruit_item=d.get("recruit_item"), recruit_msg=d.get("recruit_msg","加入了你的队伍！"),
            emoji=d.get("emoji", "")
        )
        g.companions[c.id] = c

    # ── 房间定义（从 data/rooms.json 加载 + 特殊行为补丁）──
    rooms_data = _load_json("rooms.json")
    for d in rooms_data:
        exits_raw = d.get("exits", {})
        r = Room(
            rid=d["id"], name=d["name"], desc=d.get("desc",""),
            exits=exits_raw,  # 后面统一转换
            dark=d.get("dark", False),
            items=d.get("items", []),
            npc_id=d.get("npc_id"), monster_id=d.get("monster_id"),
            on_enter=None,  # 特殊行为下面单独绑定
            emoji=d.get("emoji", "")
        )
        g.rooms[r.id] = r

    # 补全房间出口映射（字符串 -> Direction）
    dir_map = {"north":Direction.NORTH,"south":Direction.SOUTH,
               "east":Direction.EAST,"west":Direction.WEST,
               "up":Direction.UP,"down":Direction.DOWN}
    for r in g.rooms.values():
        converted = {}
        for k, v in r.exits.items():
            d = dir_map.get(k)
            if d: converted[d] = v
        r.exits = converted

    # ── 特殊房间行为（on_enter lambdas — 代码逻辑，不能放在 JSON 中）──
    # 远古遗迹：用生锈钥匙开门
    g.rooms["ancient_ruins"].on_enter = lambda g: (
        (g.rooms["ancient_ruins"].exits.__setitem__(Direction.NORTH, "hidden_passage"),
         "你用生锈钥匙打开了石门！")[1]
        if g.has_item("rusty_key") and "ruins_open" not in g.flags
        else (g.flags.__setitem__("ruins_open",True), None)[1]
        if "ruins_open" in g.flags else "石门紧锁，需要钥匙。" if not g.has_item("rusty_key") else None
        or None
    )

    # 高塔底部：银钥匙解锁
    g.rooms["tower_base"].on_enter = lambda g: (
        (g.rooms["tower_base"].exits.__setitem__(Direction.UP, "tower_middle"),
         "银钥匙打开了塔门！")[1]
        if g.has_item("silver_key") and "tower_unlocked" not in g.flags
        else (g.flags.__setitem__("tower_unlocked",True), "门已经开了。")[1]
        if "tower_unlocked" in g.flags else None
    )

    # 高塔顶层：BOSS 提示
    g.rooms["tower_top"].on_enter = lambda g: (
        "一股强大的龙威扑面而来……" if g.monsters["dragon_whelp"].alive
        else "幼龙已经被击败，宝石唾手可得。"
    )

    # 湖边：乘船到湖心岛
    g.rooms["lake_shore"].on_enter = lambda g: (
        (g.rooms["lake_shore"].exits.__setitem__(Direction.EAST, "lake_island"),
         "你登上小船划向湖心岛……")[1]
        if "boat_taken" not in g.flags
        else (g.flags.__setitem__("boat_taken",True), "船已经在对岸了。")[1]
        if "boat_taken" in g.flags else None
    )

    # 哥布林王座：BOSS 咆哮
    g.rooms["goblin_throne"].on_enter = lambda g: "哥布林王咆哮着站起来！地面都在震动！"



    # ── 胜利条件 ──
    original_gem_use = g.items["magic_gem"].on_use
    def gem_victory(self):
        msg = original_gem_use(self)
        if self.current_room_id == "tower_top" and not self.monsters["dragon_whelp"].alive:
            self.won = True
            return "宝石嵌入书桌凹槽！书籍爆发出耀眼的光芒——\n所有记忆涌回你的脑海！你是被封印的守护者，\n迷雾是高塔的结界。现在，你自由了！"
        if self.current_room_id == "tower_top" and self.monsters["dragon_whelp"].alive:
            return "幼龙还在！必须先击败它！"
        return msg
    g.items["magic_gem"].on_use = gem_victory.__get__(g, Game)

    # ── 设置起始位置 ──
    g.current_room_id = "forest_entrance"
    g.rooms["forest_entrance"].visited = True
    # 给玩家初始物品（叠加物品直接使用 _inv_add）
    g._inv_add("lesser_potion")
    g._inv_add("bread")
    return g


# ══════════════════════════════════════════════
#  文本资源
# ══════════════════════════════════════════════

WELCOME_TEXT = r"""
╔══════════════════════════════════════════╗
║       🌫  迷雾之塔 · 完整版  🌫          ║
║         类 Zork 文字冒险游戏              ║
╚══════════════════════════════════════════╝

迷雾笼罩着古老的森林。你从古树下醒来——
什么都不记得了。远处的高塔在呼唤着你……

特色：
  🗺️ 25+ 场景 · 👾 20 种怪物 · 👥 12 位 NPC
  🤝 7 位可招募队友 · 🎒 50+ 种道具（可叠加）
  ⚔️ 战斗系统 · 💬 对话系统 · 🛒 交易系统
  🎯 任务系统 · 🏆 得分系统

💡 食物/宝藏/材料可以叠加存放，上限 999 个。

输入 help 查看命令列表。
"""

HELP_TEXT = """
╔══════════════ 命令列表 ══════════════╗

  🚶  移动
    n/s/e/w/u/d —— 方向移动

  👀  探索
    look / l       —— 查看当前场景
    take / get <名/序号>  —— 拾取物品
    take all / get all    —— 拾取全部物品
    drop <名/序号>  —— 丢弃物品
    use <名/序号>   —— 使用物品
    inventory / i   —— 查看背包（带序号）

  💬  社交
    talk / say  —— 对话
    trade       —— 交易查看
    buy/sell    —— 买卖物品
    heal        —— 治疗

  ⚔️  战斗
    attack/fight—— 攻击
    flee        —— 逃跑

  🤝  队友
    recruit     —— 招募
    party/companions —— 队友状态

  📋  系统
    help / h    —— 帮助
    score/status—— 状态
    quit / exit —— 退出

💡 提示：场景物品和背包物品都带有数字序号 (1)(2)...
   可以直接用序号操作，如 take 1、use 2、drop 3
   也可以用名称，如 take sword

   🥪 食物/宝藏/材料类物品可叠加存放（上限 999）
     背包中显示为「面包 x5」「金币 x20」
"""

# ══════════════════════════════════════════════
#  入口
# ══════════════════════════════════════════════

def main():
    game = build_world()
    try:
        game.run()
    except KeyboardInterrupt:
        print("\n\n👋 下次再见！")

if __name__ == "__main__":
    main()
