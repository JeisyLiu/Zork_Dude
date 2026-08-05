/// Layout breakpoints and sizing for the exploration play screen.
abstract final class ExplorationLayoutConstants {
  static const double wideBreakpoint = 900;
  static const double directionPadWidth = 112;
  static const double commandDockMaxHeightWide = 280;
  static const double commandDockMaxHeightNarrow = 296;
  static const double chipHeight = 44;
  static const double chipSpacing = 8;

  static int chipColumnsFor(double width) {
    if (width >= 520) return 4;
    if (width >= 400) return 3;
    return 3;
  }
}
