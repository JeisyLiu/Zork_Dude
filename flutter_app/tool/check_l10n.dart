import 'dart:convert';
import 'dart:io';

/// Validates that all locale catalogs share the same keys and entity ids.
///
/// Usage: dart run tool/check_l10n.dart
void main() {
  final root = Directory.current;
  if (!File('pubspec.yaml').existsSync()) {
    stderr.writeln('Run from flutter_app directory');
    exit(1);
  }

  const locales = [
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

  const dataFiles = [
    'items.json',
    'monsters.json',
    'npcs.json',
    'companions.json',
    'rooms.json',
    'status_effects.json',
  ];

  var failed = false;

  final zhMessages = _readStringMap('assets/l10n/messages/zh_Hans.json');
  for (final locale in locales) {
    if (locale == 'zh_Hans') continue;
    final path = 'assets/l10n/messages/$locale.json';
    if (!File(path).existsSync()) {
      stderr.writeln('MISSING messages: $path');
      failed = true;
      continue;
    }
    final keys = _readStringMap(path).keys.toSet();
    final missing = zhMessages.keys.toSet().difference(keys);
    final extra = keys.difference(zhMessages.keys.toSet());
    if (missing.isNotEmpty || extra.isNotEmpty) {
      failed = true;
      stderr.writeln('messages/$locale: missing=$missing extra=$extra');
    }
  }

  for (final file in dataFiles) {
    final zhIds = _collectIds('assets/data/l10n/zh_Hans/$file');
    for (final locale in locales) {
      if (locale == 'zh_Hans') continue;
      final path = 'assets/data/l10n/$locale/$file';
      if (!File(path).existsSync()) {
        stderr.writeln('MISSING world data: $path');
        failed = true;
        continue;
      }
      final ids = _collectIds(path);
      final missing = zhIds.difference(ids);
      final extra = ids.difference(zhIds);
      if (missing.isNotEmpty || extra.isNotEmpty) {
        failed = true;
        stderr.writeln('$locale/$file: missing=$missing extra=$extra');
      }
    }
  }

  final zhArb = _readArbKeys('lib/l10n/app_zh_Hans.arb');
  const arbLocales = [
    'zh_Hant',
    'en_US',
    'ja',
    'ko',
    'fr',
    'de',
    'it',
    'es',
    'es_ES',
    'pt',
    'pt_BR',
  ];
  for (final tag in arbLocales) {
    final path = 'lib/l10n/app_$tag.arb';
    if (!File(path).existsSync()) {
      stderr.writeln('MISSING arb: $path');
      failed = true;
      continue;
    }
    final keys = _readArbKeys(path);
    final missing = zhArb.difference(keys);
    final extra = keys.difference(zhArb);
    if (missing.isNotEmpty || extra.isNotEmpty) {
      failed = true;
      stderr.writeln('arb/$tag: missing=$missing extra=$extra');
    }
  }

  if (failed) {
    stderr.writeln('check_l10n: FAILED');
    exit(1);
  }
  stdout.writeln('check_l10n: OK (${locales.length} locales)');
}

Map<String, String> _readStringMap(String path) {
  final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  return raw.map((k, v) => MapEntry(k, v as String));
}

Set<String> _readArbKeys(String path) {
  final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  return raw.keys
      .where((k) => !k.startsWith('@') && k != '@@locale')
      .toSet();
}

Set<String> _collectIds(String path) {
  final data = jsonDecode(File(path).readAsStringSync());
  final ids = <String>{};
  void walk(dynamic node) {
    if (node is Map<String, dynamic>) {
      final id = node['id'];
      if (id is String) ids.add(id);
      for (final v in node.values) {
        walk(v);
      }
    } else if (node is List) {
      for (final v in node) {
        walk(v);
      }
    }
  }

  walk(data);
  return ids;
}
