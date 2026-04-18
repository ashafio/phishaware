import 'dart:math';

class ExperimentService {
  static String? _group;
  static String? _warningStyle;

  // =========================
  // GROUP ASSIGNMENT (A/B TEST)
  // =========================
  static String getGroup() {
    if (_group != null) return _group!;

    final random = Random().nextBool();
    _group = random ? "group_a" : "group_b";

    print("🧪 Experiment Group: $_group");

    return _group!;
  }

  static bool isWarningEnabled() {
    return getGroup() == "group_b";
  }

  // =========================
  // WARNING STYLE (CONSISTENT)
  // =========================
  static String getWarningStyle() {
    if (_warningStyle != null) return _warningStyle!;

    final styles = ["simple", "scary", "educational"];
    _warningStyle = styles[Random().nextInt(styles.length)];

    print("🎨 Warning Style: $_warningStyle");

    return _warningStyle!;
  }
}