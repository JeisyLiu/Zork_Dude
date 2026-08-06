import 'package:flutter/material.dart';
import 'package:zork_dude/screens/exploration_screen.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/ads/offpack_banner.dart';
import 'package:zork_dude/ui/components/game_confirm_dialog.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/landscape_scaffold.dart';
import 'package:zork_dude/ui/components/save_slot_picker.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/home/home_ambient_background.dart';
import 'package:zork_dude/ui/home/home_constants.dart';
import 'package:zork_dude/ui/home/home_enter_transition.dart';
import 'package:zork_dude/ui/home/home_hero_art.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';
import 'package:zork_dude/ui/navigation/game_exit.dart';
import 'package:zork_dude/ui/navigation/landscape_page_route.dart';

/// Launch screen before entering the Zork exploration world.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = GameController();
  final _pointer = ValueNotifier<HomePointerSample?>(null);
  bool _entering = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _controller.init();
  }

  void _onControllerChanged() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _pointer.dispose();
    super.dispose();
  }

  void _setPointer(Offset local, {bool down = false}) {
    if (MediaQuery.disableAnimationsOf(context)) return;
    _pointer.value = HomePointerSample(position: local, down: down);
  }

  void _clearPointer() {
    _pointer.value = null;
  }

  Future<void> _enterGame(BuildContext context) async {
    if (_entering || _controller.loading) return;
    if (_controller.occupiedCount == 0) {
      final slot = _controller.firstEmptyIndex ?? 0;
      await _startNewGameAndEnter(context, slot);
      return;
    }
    final picked = await SaveSlotPicker.show(
      context: context,
      mode: SaveSlotPickerMode.write,
      slots: _controller.slots,
    );
    if (!mounted || picked == null) return;
    if (_controller.slots[picked] != null) {
      final confirmed = await GameConfirmDialog.show(
        context: context,
        title: '开始新旅程？',
        message: '该槽位已有进度，开始新游戏将覆盖此存档，是否继续？',
        confirmLabel: '覆盖并开始',
        confirmSubLabel: 'overwrite',
        skin: GameUiSkin.fantasy,
      );
      if (!confirmed || !mounted) return;
    }
    await _startNewGameAndEnter(context, picked);
  }

  Future<void> _startNewGameAndEnter(BuildContext context, int slot) async {
    await _controller.startNewGame(slot: slot);
    if (!mounted || _controller.error != null) return;
    setState(() => _entering = true);
  }

  Future<void> _continueGame(BuildContext context) async {
    if (_entering || _controller.loading) return;
    final sole = _controller.soleOccupiedIndex;
    if (sole != null) {
      await _loadSlotAndEnter(context, sole);
      return;
    }
    final picked = await SaveSlotPicker.show(
      context: context,
      mode: SaveSlotPickerMode.read,
      slots: _controller.slots,
    );
    if (!mounted || picked == null) return;
    if (_controller.slots[picked] == null) return;
    await _loadSlotAndEnter(context, picked);
  }

  Future<void> _loadSlotAndEnter(BuildContext context, int slot) async {
    await _controller.continueGame(slot: slot);
    if (!mounted || _controller.error != null) return;
    setState(() => _entering = true);
  }

  void _pushExploration(BuildContext context) {
    if (!mounted) return;
    Navigator.of(context)
        .push(
          LandscapePageRoute.of<void>(
            context,
            ExplorationScreen(controller: _controller),
          ),
        )
        .then((_) async {
          if (mounted) {
            await _controller.refreshSlots();
            setState(() => _entering = false);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !GameExit.isDesktop,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final ok = await GameExit.confirmQuitApp(context);
        if (ok) GameExit.quitApp();
      },
      child: GameSkinScope(
        skin: GameUiSkin.fantasy,
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerHover: (e) => _setPointer(e.localPosition),
          onPointerMove: (e) => _setPointer(e.localPosition),
          onPointerDown: (e) => _setPointer(e.localPosition, down: true),
          onPointerUp: (_) => _clearPointer(),
          onPointerCancel: (_) => _clearPointer(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              LandscapeScaffold(
                backgroundColor: HomeConstants.bgMid,
                background: HomeAmbientBackground(pointerListenable: _pointer),
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    final screen = MediaQuery.sizeOf(context);
                    final padding = MediaQuery.paddingOf(context);
                    final short = LandscapeLayout.isShortPlayContext(context);
                    final phoneShort = LandscapeLayout.isPhoneShortPlayContext(
                      context,
                    );
                    final usableH = LandscapeLayout.playUsableHeightOf(context);
                    final heroSize = HomeConstants.heroSizeFor(
                      screen,
                      padding: padding,
                    );
                    final tight = usableH < 520;
                    final gapL = phoneShort
                        ? 4.0
                        : (short ? 6.0 : (tight ? 10.0 : 16.0));
                    final gapM = phoneShort
                        ? 3.0
                        : (short ? 4.0 : (tight ? 8.0 : 12.0));
                    final gapS = phoneShort
                        ? 2.0
                        : (short ? 3.0 : (tight ? 6.0 : 10.0));
                    final btnW = HomeConstants.buttonWidthFor(
                      short: short,
                      phoneShort: phoneShort,
                    );
                    final btnH = HomeConstants.buttonHeightFor(btnW);

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: LandscapeLayout.maxContentWidth,
                            ),
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: phoneShort ? 6 : (short ? 8 : 12),
                              ),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: HomeConstants.maxContentWidth,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    HomeHeroArt(size: heroSize),
                                    SizedBox(height: gapL),
                                    GameOutlinedText(
                                      '迷雾之塔',
                                      fontSize: phoneShort
                                          ? 20
                                          : (short ? 22 : (tight ? 26 : 30)),
                                      fontWeight: FontWeight.w700,
                                      color: HomeConstants.titleColor,
                                      strokeWidth: 0,
                                      letterSpacing: 2,
                                      shadowColor: Colors.black.withValues(
                                        alpha: 0.45,
                                      ),
                                      shadowOffset: const Offset(0, 2),
                                      shadowBlurRadius: 3,
                                    ),
                                    SizedBox(height: gapS),
                                    GameOutlinedText(
                                      'MIST TOWER',
                                      fontSize: phoneShort
                                          ? 9
                                          : (short ? 10 : (tight ? 11 : 12)),
                                      fontWeight: FontWeight.w500,
                                      color: HomeConstants.subtitleColor,
                                      strokeWidth: 0,
                                      letterSpacing: 4,
                                    ),
                                    SizedBox(height: gapM),
                                    const _PixelDivider(),
                                    SizedBox(height: gapM),
                                    GameOutlinedText(
                                      short || phoneShort
                                          ? '探索、收集、对话、战斗——找回失落的真相。'
                                          : '你从迷雾森林中醒来，失去记忆。\n探索、收集、对话、战斗——找回失落的真相。',
                                      textAlign: TextAlign.center,
                                      fontSize: phoneShort
                                          ? 11
                                          : (short ? 12 : (tight ? 13 : 14)),
                                      fontWeight: FontWeight.w500,
                                      color: HomeConstants.bodyColor,
                                      strokeWidth: 0,
                                      height: 1.45,
                                    ),
                                    SizedBox(height: gapL),
                                    if (_controller.hasSave) ...[
                                      GameButton(
                                        width: btnW,
                                        height: btnH,
                                        compact: true,
                                        useOutline: false,
                                        nineSlice: false,
                                        asset: HomeConstants.enterButtonAsset,
                                        labelColor:
                                            HomeConstants.buttonLabelColor,
                                        subLabelColor:
                                            HomeConstants.buttonSubLabelColor,
                                        label: _controller.loading
                                            ? '加载中…'
                                            : '继续旅程',
                                        subLabel: 'continue',
                                        enabled:
                                            !_controller.loading && !_entering,
                                        onPressed:
                                            _controller.loading || _entering
                                            ? null
                                            : () => _continueGame(context),
                                        semanticLabel: '继续旅程',
                                      ),
                                      SizedBox(height: gapS),
                                    ],
                                    GameButton(
                                      width: btnW,
                                      height: btnH,
                                      compact: true,
                                      useOutline: false,
                                      nineSlice: false,
                                      asset: HomeConstants.enterButtonAsset,
                                      labelColor:
                                          HomeConstants.buttonLabelColor,
                                      subLabelColor:
                                          HomeConstants.buttonSubLabelColor,
                                      label: _controller.loading
                                          ? '加载中…'
                                          : '进入迷雾',
                                      subLabel: 'enter',
                                      enabled:
                                          !_controller.loading && !_entering,
                                      onPressed:
                                          _controller.loading || _entering
                                          ? null
                                          : () => _enterGame(context),
                                      semanticLabel: '进入迷雾',
                                    ),
                                    SizedBox(height: gapM),
                                    if (GameExit.isDesktop) ...[
                                      TextButton(
                                        onPressed:
                                            _controller.loading || _entering
                                            ? null
                                            : () async {
                                                final ok =
                                                    await GameExit.confirmQuitApp(
                                                      context,
                                                    );
                                                if (ok) GameExit.quitApp();
                                              },
                                        child: GameOutlinedText(
                                          '退出游戏',
                                          fontSize: short ? 11 : 12,
                                          fontWeight: FontWeight.w500,
                                          color: HomeConstants.hintColor,
                                          strokeWidth: 0,
                                        ),
                                      ),
                                      SizedBox(height: gapS),
                                    ],
                                    GameOutlinedText(
                                      '指令探索 · 迷雾地图 · 遇敌进入回合战斗',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: HomeConstants.hintColor,
                                      strokeWidth: 0,
                                    ),
                                    if (!short) ...[
                                      const SizedBox(height: 8),
                                      const OffpackHomeBanner(),
                                    ],
                                    const OffpackPrivacyButton(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (_entering)
                          HomeEnterTransition(
                            onCompleted: () => _pushExploration(context),
                          ),
                      ],
                    );
                  },
                ),
              ),
              if (!_entering)
                IgnorePointer(
                  child: HomePointerFxOverlay(pointerListenable: _pointer),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PixelDivider extends StatelessWidget {
  const _PixelDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 3,
      child: CustomPaint(painter: _PixelDividerPainter()),
    );
  }
}

class _PixelDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = HomeConstants.subtitleColor.withValues(alpha: 0.55);
    final mid = size.height / 2;
    canvas.drawRect(Rect.fromLTWH(0, mid, size.width * 0.38, 1), paint);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.42, mid - 1, size.width * 0.16, 3),
      Paint()..color = HomeConstants.titleColor.withValues(alpha: 0.7),
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.62, mid, size.width * 0.38, 1),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
