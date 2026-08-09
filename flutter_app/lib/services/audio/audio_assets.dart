/// Asset paths for BGM and SFX (OGG Vorbis). See assets/audio/sound_prompt.md.
abstract final class AudioAssets {
  static const bgmHome = 'assets/audio/bgm/home.ogg';
  static const bgmSurface = 'assets/audio/bgm/surface.ogg';
  static const bgmCave = 'assets/audio/bgm/cave.ogg';
  static const bgmTower = 'assets/audio/bgm/tower.ogg';
  static const bgmSite = 'assets/audio/bgm/site.ogg';
  static const bgmCombat = 'assets/audio/bgm/combat.ogg';
  static const bgmEnding = 'assets/audio/bgm/ending.ogg';

  static const sfxUiClick = 'assets/audio/sfx/ui/click.ogg';
  static const sfxUiOpenPanel = 'assets/audio/sfx/ui/open_panel.ogg';
  static const sfxUiClosePanel = 'assets/audio/sfx/ui/close_panel.ogg';
  static const sfxUiConfirm = 'assets/audio/sfx/ui/confirm.ogg';
  static const sfxUiCancel = 'assets/audio/sfx/ui/cancel.ogg';

  static const sfxExploreFootstep = 'assets/audio/sfx/explore/footstep.ogg';
  static const sfxExplorePickup = 'assets/audio/sfx/explore/pickup.ogg';
  static const sfxExploreDrop = 'assets/audio/sfx/explore/drop.ogg';
  static const sfxExploreUseItem = 'assets/audio/sfx/explore/use_item.ogg';
  static const sfxExploreTalk = 'assets/audio/sfx/explore/talk.ogg';
  static const sfxExploreMapOpen = 'assets/audio/sfx/explore/map_open.ogg';
  static const sfxExploreRoomEnter = 'assets/audio/sfx/explore/room_enter.ogg';

  static const sfxCombatBattleStart = 'assets/audio/sfx/combat/battle_start.ogg';
  static const sfxCombatAttack = 'assets/audio/sfx/combat/attack.ogg';
  static const sfxCombatHit = 'assets/audio/sfx/combat/hit.ogg';
  static const sfxCombatHeal = 'assets/audio/sfx/combat/heal.ogg';
  static const sfxCombatSkill = 'assets/audio/sfx/combat/skill.ogg';
  static const sfxCombatMiss = 'assets/audio/sfx/combat/miss.ogg';
  static const sfxCombatFlee = 'assets/audio/sfx/combat/flee.ogg';
  static const sfxCombatVictory = 'assets/audio/sfx/combat/victory.ogg';
  static const sfxCombatDefeat = 'assets/audio/sfx/combat/defeat.ogg';
  static const sfxCombatStatus = 'assets/audio/sfx/combat/status.ogg';
}

enum GameSfx {
  uiClick(AudioAssets.sfxUiClick),
  uiOpenPanel(AudioAssets.sfxUiOpenPanel),
  uiClosePanel(AudioAssets.sfxUiClosePanel),
  uiConfirm(AudioAssets.sfxUiConfirm),
  uiCancel(AudioAssets.sfxUiCancel),
  exploreFootstep(AudioAssets.sfxExploreFootstep),
  explorePickup(AudioAssets.sfxExplorePickup),
  exploreDrop(AudioAssets.sfxExploreDrop),
  exploreUseItem(AudioAssets.sfxExploreUseItem),
  exploreTalk(AudioAssets.sfxExploreTalk),
  exploreMapOpen(AudioAssets.sfxExploreMapOpen),
  exploreRoomEnter(AudioAssets.sfxExploreRoomEnter),
  combatBattleStart(AudioAssets.sfxCombatBattleStart),
  combatAttack(AudioAssets.sfxCombatAttack),
  combatHit(AudioAssets.sfxCombatHit),
  combatHeal(AudioAssets.sfxCombatHeal),
  combatSkill(AudioAssets.sfxCombatSkill),
  combatMiss(AudioAssets.sfxCombatMiss),
  combatFlee(AudioAssets.sfxCombatFlee),
  combatVictory(AudioAssets.sfxCombatVictory),
  combatDefeat(AudioAssets.sfxCombatDefeat),
  combatStatus(AudioAssets.sfxCombatStatus);

  const GameSfx(this.path);
  final String path;
}
