import 'package:flutter/material.dart';
import 'package:zork_dude/state/game_controller.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key, required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final s = controller.session;
    if (s == null) return const SizedBox.shrink();
    final ratio = s.playerMaxHp > 0 ? s.playerHp / s.playerMaxHp : 0.0;
    final companions = s.companionList
        .map((c) => s.companions[c]?.name)
        .whereType<String>()
        .join(', ');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)]),
        border: Border.all(color: const Color(0xFF2A2A4A)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _stat('❤️', '${s.playerHp}/${s.playerMaxHp}', child: SizedBox(
            width: 56,
            height: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio.clamp(0, 1),
                backgroundColor: const Color(0xFF2D2D3A),
                color: Color.lerp(const Color(0xFFE74C3C), const Color(0xFF2ECC71), ratio),
              ),
            ),
          )),
          _stat('⚔️', '${s.totalAtk}'),
          _stat('🛡️', '${s.totalDef}'),
          _stat('💰', '${s.gold}'),
          _stat('🏆', '${s.score}'),
          _stat('🎒', '${s.totalWeight()}/${s.bagCapacity()}'),
          if (companions.isNotEmpty) _stat('👥', companions),
          TextButton(
            onPressed: controller.toggleMap,
            child: Text(
              controller.mapVisible ? '🗺️ 地图 map' : '🗺️ 地图·关 map',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String icon, String value, {Widget? child}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 3),
        if (child != null) child,
        if (child != null) const SizedBox(width: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}
