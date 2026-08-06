import 'package:flutter/material.dart';
import 'package:zork_dude/screens/exploration_screen.dart';
import 'package:zork_dude/state/game_controller.dart';
import 'package:zork_dude/ui/components/game_button.dart';
import 'package:zork_dude/ui/components/game_outlined_text.dart';
import 'package:zork_dude/ui/components/landscape_scaffold.dart';
import 'package:zork_dude/ui/game_skin_scope.dart';
import 'package:zork_dude/ui/game_ui_theme.dart';
import 'package:zork_dude/ui/home/home_ambient_background.dart';
import 'package:zork_dude/ui/home/home_constants.dart';
import 'package:zork_dude/ui/home/home_enter_transition.dart';
import 'package:zork_dude/ui/home/home_hero_art.dart';
import 'package:zork_dude/ui/layout/landscape_layout.dart';
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

  void _enterGame(BuildContext context) {
    if (_entering || _controller.loading) return;
    setState(() => _entering = true);
  }

  void _pushExploration(BuildContext context) {
    if (!mounted) return;
    Navigator.of(context).push(
      LandscapePageRoute.of<void>(
        context,
        ExplorationScreen(controller: _controller),
      ),
    ).then((_) {
      if (mounted) setState(() => _entering = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameSkinScope(
      skin: GameUiSkin.fantasy,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerHover: (e) => _setPointer(e.localPosition),
        onPointerMove: (e) => _setPointer(e.localPosition),
        onPointerDown: (e) => _setPointer(e.localPosition, down: true),
        onPointerUp: (_) => _clearPointer(),
        onPointerCancel: (_) => _clearPointer(),
        child: LandscapeScaffold(
        backgroundColor: HomeConstants.bgMid,
        background: HomeAmbientBackground(pointerListenable: _pointer),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screen = MediaQuery.sizeOf(context);
            final heroSize = HomeConstants.heroSizeFor(screen);
            final short = LandscapeLayout.isShort(screen);
            final tight = screen.height < 520;
            final gapL = short ? 6.0 : (tight ? 10.0 : 16.0);
            final gapM = short ? 4.0 : (tight ? 8.0 : 12.0);
            final gapS = short ? 3.0 : (tight ? 6.0 : 10.0);
            final btnW = short ? HomeConstants.buttonWidthShort : HomeConstants.buttonWidth;
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
                        vertical: short ? 8 : 12,
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
                              fontSize: short ? 22 : (tight ? 26 : 30),
                              fontWeight: FontWeight.w700,
                              color: HomeConstants.titleColor,
                              strokeWidth: 0,
                              letterSpacing: 2,
                              shadowColor: Colors.black.withValues(alpha: 0.45),
                              shadowOffset: const Offset(0, 2),
                              shadowBlurRadius: 3,
                            ),
                            SizedBox(height: gapS),
                            GameOutlinedText(
                              'MIST TOWER',
                              fontSize: short ? 10 : (tight ? 11 : 12),
                              fontWeight: FontWeight.w500,
                              color: HomeConstants.subtitleColor,
                              strokeWidth: 0,
                              letterSpacing: 4,
                            ),
                            SizedBox(height: gapM),
                            const _PixelDivider(),
                            SizedBox(height: gapM),
                            GameOutlinedText(
                              short
                                  ? '探索、收集、对话、战斗——找回失落的真相。'
                                  : '你从迷雾森林中醒来，失去记忆。\n探索、收集、对话、战斗——找回失落的真相。',
                              textAlign: TextAlign.center,
                              fontSize: short ? 12 : (tight ? 13 : 14),
                              fontWeight: FontWeight.w500,
                              color: HomeConstants.bodyColor,
                              strokeWidth: 0,
                              height: 1.45,
                            ),
                            SizedBox(height: gapL),
                            GameButton(
                              width: btnW,
                              height: btnH,
                              compact: true,
                              useOutline: false,
                              nineSlice: false,
                              asset: HomeConstants.enterButtonAsset,
                              labelColor: HomeConstants.buttonLabelColor,
                              subLabelColor: HomeConstants.buttonSubLabelColor,
                              label: _controller.loading ? '加载中…' : '进入迷雾',
                              subLabel: 'enter',
                              enabled: !_controller.loading && !_entering,
                              onPressed: _controller.loading || _entering
                                  ? null
                                  : () => _enterGame(context),
                              semanticLabel: '进入迷雾',
                            ),
                            SizedBox(height: gapM),
                            GameOutlinedText(
                              '指令探索 · 迷雾地图 · 遇敌进入回合战斗',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: HomeConstants.hintColor,
                              strokeWidth: 0,
                            ),
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
      child: CustomPaint(
        painter: _PixelDividerPainter(),
      ),
    );
  }
}

class _PixelDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = HomeConstants.subtitleColor.withValues(alpha: 0.55);
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
