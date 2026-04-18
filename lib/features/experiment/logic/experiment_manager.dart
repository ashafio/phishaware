enum ExperimentMode {
  mlOnly,
  warningOnly,
  combined,
}

class ExperimentManager {
  ExperimentMode mode = ExperimentMode.combined;

  bool shouldShowWarning(double phishingScore) {
    switch (mode) {
      case ExperimentMode.mlOnly:
        return false;

      case ExperimentMode.warningOnly:
        return true;

      case ExperimentMode.combined:
        return phishingScore > 0.6;
    }
  }
}