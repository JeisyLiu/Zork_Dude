// Sync root data/*.json into flutter_app/assets/data/
// Run: dart run tool/sync_game_data.dart
import 'dart:io';

void main() {
  final script = File(Platform.script.toFilePath());
  final appRoot = script.parent.parent;
  final repoRoot = appRoot.parent;
  final src = Directory('${repoRoot.path}/data');
  final dest = Directory('${appRoot.path}/assets/data');
  if (!src.existsSync()) {
    stderr.writeln('Source not found: ${src.path}');
    exit(1);
  }
  dest.createSync(recursive: true);
  for (final f in src.listSync().whereType<File>().where((f) => f.path.endsWith('.json'))) {
    final out = File('${dest.path}/${f.uri.pathSegments.last}');
    f.copySync(out.path);
    stdout.writeln('Synced ${f.uri.pathSegments.last}');
  }
  stdout.writeln('Done.');
}
