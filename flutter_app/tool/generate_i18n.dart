import 'dart:convert';
import 'dart:io';

/// Generates localized ARB files, GameMessages JSON, and world data JSON.
///
/// Usage: dart run tool/generate_i18n.dart
void main() async {
  final root = Directory.current;
  if (!File('pubspec.yaml').existsSync()) {
    stderr.writeln('Run from flutter_app directory');
    exit(1);
  }

  await _ensureZhHansData();
  await _generateMessageCatalogs();
  await _generateWorldData();
  await _generateUiArbs();
  stdout.writeln('i18n generation complete');
}

final _locales = [
  'zh_Hans',
  'zh_Hant',
  'en_US',
  'ja',
  'ko',
  'fr',
  'de',
  'it',
  'es_ES',
  'pt_BR',
];

final _dataFiles = [
  'items.json',
  'monsters.json',
  'npcs.json',
  'companions.json',
  'rooms.json',
  'status_effects.json',
];

Future<void> _ensureZhHansData() async {
  final src = Directory('assets/data');
  final dst = Directory('assets/data/l10n/zh_Hans');
  dst.createSync(recursive: true);
  for (final f in _dataFiles) {
    final legacy = File('assets/data/$f');
    final target = File('${dst.path}/$f');
    if (legacy.existsSync() && !target.existsSync()) {
      legacy.copySync(target.path);
    }
  }
}

Future<void> _generateMessageCatalogs() async {
  final srcFile = File('assets/l10n/messages/zh_Hans.json');
  if (!srcFile.existsSync()) {
    stderr.writeln('Missing ${srcFile.path} — create zh_Hans source first');
    exit(1);
  }
  final zhHans =
      (jsonDecode(srcFile.readAsStringSync()) as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, v as String),
      );

  for (final locale in _locales) {
    if (locale == 'zh_Hans') continue;
    final out = File('assets/l10n/messages/$locale.json');
    final translated = <String, String>{};
    for (final e in zhHans.entries) {
      translated[e.key] = _translateText(e.value, locale);
    }
    out.parent.createSync(recursive: true);
    out.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(translated),
    );
    stdout.writeln('messages: $locale (${translated.length} keys)');
  }
}

Future<void> _generateWorldData() async {
  final srcDir = Directory('assets/data/l10n/zh_Hans');
  for (final locale in _locales) {
    if (locale == 'zh_Hans') continue;
    final outDir = Directory('assets/data/l10n/$locale');
    outDir.createSync(recursive: true);
    for (final f in _dataFiles) {
      final src = File('${srcDir.path}/$f');
      if (!src.existsSync()) continue;
      final data = jsonDecode(src.readAsStringSync());
      final translated = _translateWorldJson(data, locale);
      File('${outDir.path}/$f').writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(translated),
      );
    }
    stdout.writeln('world data: $locale');
  }
}

Future<void> _generateUiArbs() async {
  final template = File('lib/l10n/app_zh_Hans.arb');
  final zh = jsonDecode(template.readAsStringSync()) as Map<String, dynamic>;
  final enFile = File('lib/l10n/app_en_US.arb');
  final en = jsonDecode(enFile.readAsStringSync()) as Map<String, dynamic>;

  final targets = {
    'ja': 'ja',
    'ko': 'ko',
    'fr': 'fr',
    'de': 'de',
    'it': 'it',
    'es': 'es',
    'es_ES': 'es_ES',
    'pt': 'pt',
    'pt_BR': 'pt_BR',
  };

  for (final entry in targets.entries) {
    final tag = entry.key;
    final locale = entry.value;
    final out = <String, dynamic>{'@@locale': locale};
    for (final key in zh.keys) {
      if (key.startsWith('@')) continue;
      if (key == '@@locale') continue;
      final meta = zh['@$key'];
      if (meta != null) out['@$key'] = meta;
      final source = zh[key] as String;
      out[key] = _translateText(source, tag);
    }
    File('lib/l10n/app_$tag.arb').writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(out),
    );
    stdout.writeln('arb: app_$tag.arb');
  }
}

dynamic _translateWorldJson(dynamic node, String locale) {
  if (node is Map<String, dynamic>) {
    final out = <String, dynamic>{};
    for (final e in node.entries) {
      if (_isTranslatableField(e.key) && e.value is String) {
        out[e.key] = _translateText(e.value as String, locale);
      } else if (e.key == 'dialogs' && e.value is Map) {
        out[e.key] = (e.value as Map).map(
          (k, v) => MapEntry(k, _translateText(v as String, locale)),
        );
      } else {
        out[e.key] = _translateWorldJson(e.value, locale);
      }
    }
    return out;
  }
  if (node is List) {
    return node.map((e) => _translateWorldJson(e, locale)).toList();
  }
  return node;
}

bool _isTranslatableField(String key) {
  return {
    'name',
    'desc',
    'title',
    'use_msg',
    'ability_desc',
    'recruit_msg',
    'taunt',
  }.contains(key);
}

String _translateText(String text, String locale) {
  if (locale == 'zh_Hans') return text;
  if (locale == 'zh_Hant') return _toTraditional(text);
  if (locale == 'en_US') return _toEnglish(text);
  return _toEnglish(text); // fallback: English until manual review
}

String _toTraditional(String s) {
  const map = {
    '雾': '霧', '岛': '島', '战': '戰', '斗': '鬥', '继续': '繼續', '加载': '載入',
    '进入': '進入', '设置': '設置', '隐私': '隱私', '馈赠': '饋贈', '召唤': '召喚',
    '观看': '觀看', '广告': '廣告', '金币': '金幣', '经验': '經驗', '背包': '背包',
    '丢弃': '丟棄', '装备': '裝備', '防御': '防禦', '攻击': '攻擊', '技能': '技能',
    '道具': '道具', '逃跑': '逃跑', '执行': '執行', '胜利': '勝利', '击败': '擊敗',
    '战利品': '戰利品', '收获': '收穫', '选择': '選擇', '目标': '目標', '回合': '回合',
    '进行': '進行', '敌人': '敵人', '队伍': '隊伍', '结束': '結束', '地图': '地圖',
    '探索': '探索', '已': '已', '无法': '無法', '移动': '移動', '前往': '前往',
    '连接': '連接', '游戏': '遊戲', '成就': '成就', '排行榜': '排行榜', '关闭': '關閉',
    '取消': '取消', '确认': '確認', '跳过': '跳過', '返回': '返回', '菜单': '選單',
    '开始': '開始', '旅程': '旅程', '覆盖': '覆蓋', '存档': '存檔', '是否': '是否',
    '退出': '退出', '战斗': '戰鬥', '标题': '標題', '冒险': '冒險', '损失': '損失',
    '返还': '返還', '分': '分', '幼龙': '幼龍', '陨落': '隕落', '魔法': '魔法',
    '宝石': '寶石', '记忆': '記憶', '消散': '消散', '站点': '站點', '行动': '行動',
    '完成': '完成', '倒下': '倒下', '醒来': '醒來', '地点': '地點', '传送': '傳送',
    '尚未': '尚未', '载入': '載入', '没有': '沒有', '使用': '使用', '类型': '類型',
    '重量': '重量', '价值': '價值', '治疗': '治療', '容量': '容量', '数量': '數量',
    '效果': '效果', '描述': '描述', '查看': '查看', '对话': '對話', '招募': '招募',
    '帮助': '幫助', '购买': '購買', '出售': '出售', '商品': '商品', '更多': '更多',
    '拿起': '拿起', '全部': '全部', '切换': '切換', '发送': '發送', '命令': '命令',
    '北': '北', '南': '南', '东': '東', '西': '西', '上': '上', '下': '下',
    '拖拽': '拖曳', '滚轮': '滾輪', '双指': '雙指', '缩放': '縮放', '点击': '點擊',
    '相邻': '相鄰', '节点': '節點', '全图': '全圖', '职员表': '職員表', '出品': '出品',
    '导演': '導演', '编剧': '編劇', '设计': '設計', '叙事': '敘事', '美术': '美術',
    '关卡': '關卡', '系统': '系統', '音效': '音效', '构想': '構想', '制作': '製作',
    '程序': '程式', '鸣谢': '鳴謝', '技术': '技術', '支持': '支援', '森林': '森林',
    '失去': '失去', '真相': '真相', '遇敌': '遇敵', '稍后': '稍後', '立即': '立即',
    '进度': '進度', '自动': '自動', '保存': '保存', '恢复': '恢復', '将': '將',
    '馈赠': '饋贈', '暂': '暫', '可用': '可用', '直接': '直接', '翻倍': '翻倍',
    '微光': '微光', '回应': '回應', '请': '請', '再试': '再試', '探险': '探險',
    '返程': '返程', '旅行': '旅行', '涌回': '湧回', '脑海': '腦海', '结界': '結界',
    '瓦解': '瓦解', '自由': '自由', '深处': '深處', '未竟': '未竟', '之事': '之事',
    '终焉': '終焉', '原型': '原型', '压制': '壓制', '收容': '收容', '库': '庫',
    '归于': '歸於', '沉寂': '沉寂', '漫长': '漫長', '旅途': '旅途', '迎来': '迎來',
    '尾声': '尾聲', '吞没': '吞沒', '身影': '身影', '上一处': '上一處', '得分': '得分',
    '不低于': '不低於', '不相邻': '不相鄰', '直达': '直達', '此处': '此處', '件': '件',
    '速度': '速度', '质检': '質檢',
  };
  var out = s;
  map.forEach((k, v) => out = out.replaceAll(k, v));
  return out;
}

String _toEnglish(String s) {
  // Minimal phrase map for common UI; full narrative uses en_US ARB/messages.
  const exact = {
    '迷雾之塔': 'Mist Tower',
    '加载中…': 'Loading…',
    '继续旅程': 'Continue',
    '进入迷雾': 'Enter the Mist',
    '成就': 'Achievements',
    '排行榜': 'Leaderboard',
    '关闭': 'Close',
    '取消': 'Cancel',
    '确认': 'Confirm',
    '跳过': 'Skip',
    '继续': 'Continue',
    '返回': 'Back',
    '菜单': 'Menu',
    '游戏已结束。': 'The game is over.',
    '输入 help。': 'Type help.',
    '未知地点。': 'Unknown location.',
    '背包': 'Bag',
    '你': 'You',
    '普通': 'Normal',
    '精英': 'Elite',
    '北': 'North',
    '南': 'South',
    '东': 'East',
    '西': 'West',
    '上': 'Up',
    '下': 'Down',
    '地表': 'Surface',
    '洞穴': 'Cave',
    '高塔': 'Tower',
    '设施': 'Site',
    '净化': 'Cleanse',
    '战斗胜利！': 'Victory!',
    '你逃跑了！': 'You fled!',
    '逃跑失败！': 'Flee failed!',
    '═══ 继续旅程 ═══': '═══ Continue ═══',
    '开发者模式：开': 'Developer mode: ON',
    '开发者模式：关': 'Developer mode: OFF',
    '已显示迷雾残页。': 'Mist map shown.',
    '已隐藏迷雾残页。': 'Mist map hidden.',
    'DEV · 全图': 'DEV · Full map',
    '不相邻，无法直达': 'Not adjacent — cannot travel directly',
    '（此处）': '(here)',
    '混战结束。': 'Melee ended.',
    '已取消混战。': 'Melee cancelled.',
    '战斗已结束': 'Combat ended',
  };
  if (exact.containsKey(s)) return exact[s]!;
  // Keep English tokens / numbers / emoji
  if (RegExp(r'^[A-Za-z0-9\s\.\,\!\?\:\;\-\+\→\(\)\[\]\/\\\*\@\#\$\%\&\=\|\_\{\}]+$')
      .hasMatch(s)) {
    return s;
  }
  return s; // untranslated — manual pass
}
