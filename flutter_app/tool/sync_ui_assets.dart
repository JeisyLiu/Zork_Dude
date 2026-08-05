// Sync root ui_pack/*.png into flutter_app/assets/ui/
// Run: dart run tool/sync_ui_assets.dart
import 'dart:io';

void main() {
  final script = File(Platform.script.toFilePath());
  final appRoot = script.parent.parent;
  final repoRoot = appRoot.parent;
  final src = Directory('${repoRoot.path}/ui_pack');
  final dest = Directory('${appRoot.path}/assets/ui');
  if (!src.existsSync()) {
    stderr.writeln('Source not found: ${src.path}');
    exit(1);
  }
  dest.createSync(recursive: true);
  var count = 0;
  for (final f in src.listSync().whereType<File>().where((f) => f.path.endsWith('.png'))) {
    final out = File('${dest.path}/${f.uri.pathSegments.last}');
    f.copySync(out.path);
    count++;
  }
  final licenseSrc = File('${repoRoot.path}/ui_pack/License.txt');
  final licenseDest = File('${dest.path}/License.txt');
  if (licenseSrc.existsSync()) {
    licenseSrc.copySync(licenseDest.path);
  } else {
  licenseDest.writeAsStringSync('''UI graphics: Kenney UI Pack Adventure
https://kenney.nl/assets/ui-pack-adventure
License: CC0 1.0 (public domain)
''');
  }
  stdout.writeln('Synced $count PNG files to assets/ui/');
  stdout.writeln('Done.');
}
