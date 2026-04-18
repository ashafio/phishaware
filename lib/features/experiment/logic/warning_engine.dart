class WarningEngine {
  static String getWarning(double score) {
    if (score > 0.8) {
      return "⚠️ HIGH RISK: This website looks dangerous!";
    } else if (score > 0.5) {
      return "⚠️ Suspicious website detected. Proceed carefully.";
    } else {
      return "✓ Website seems safe, but stay alert.";
    }
  }
}