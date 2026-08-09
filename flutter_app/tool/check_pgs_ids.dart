import 'dart:io';

/// Fails if Play Games IDs are still placeholders.
///
/// Usage: dart run tool/check_pgs_ids.dart
void main() {
  if (!File('pubspec.yaml').existsSync()) {
    stderr.writeln('Run from flutter_app directory');
    exit(1);
  }

  final xml = File('android/app/src/main/res/values/games-ids.xml').readAsStringSync();
  final dart = File('lib/services/play_games/play_games_ids.dart').readAsStringSync();

  var failed = false;
  if (xml.contains('PLACEHOLDER') || xml.contains('000000000000')) {
    stderr.writeln('games-ids.xml still has placeholders');
    failed = true;
  }
  if (dart.contains('PLACEHOLDER')) {
    stderr.writeln('play_games_ids.dart still has placeholders');
    failed = true;
  }

  if (failed) {
    stderr.writeln('Run: paste Console games-ids.xml, then dart run tool/apply_pgs_ids.dart');
    exit(1);
  }

  stdout.writeln('check_pgs_ids: OK');
}
