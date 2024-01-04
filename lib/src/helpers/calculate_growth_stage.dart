class CalculateGrowthStage {
  static String getGrowthStage(int weeks) {
    switch (weeks) {
      case <= 12:
        return 'infancy';
      case > 12 && <= 16:
        return 'terribleTwos';
      case > 16 && <= 26:
        return 'adolescent';
      case > 26 && <= 39:
        return 'puberty';
      default:
        return 'teen';
    }
  }
}
