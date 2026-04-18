class FeatureGenerator {
  static List<double> generate(String url) {
    final uri = Uri.parse(url);

    final hostname = uri.host;
    final path = uri.path;
    final query = uri.query;

    final features = [
      url.length.toDouble(),
      hostname.length.toDouble(),
      path.length.toDouble(),
      query.length.toDouble(),
      hostname.split(".").length.toDouble(),
      path.split("/").length.toDouble(),
      _count(url, "."),
      _count(url, "-"),
      _count(url, "@"),
      _count(url, "?"),
      _count(url, "&"),
      _count(url, "="),
      _count(url, "_"),
      _count(url, "/"),
      _digits(url),
      _letters(url),
      _special(url),
      _digits(url) / (url.length == 0 ? 1 : url.length),
      _letters(url) / (url.length == 0 ? 1 : url.length),
      url.startsWith("https") ? 1 : 0,
      _isIp(hostname),
      url.toLowerCase().contains("login") ? 1 : 0,
    ];

    return features.map((e) => e.toDouble()).toList();
  }

  static double _count(String s, String char) =>
      char.allMatches(s).length.toDouble();

  static double _digits(String s) =>
      s.split('').where((c) => RegExp(r'[0-9]').hasMatch(c)).length.toDouble();

  static double _letters(String s) =>
      s.split('').where((c) => RegExp(r'[a-zA-Z]').hasMatch(c)).length.toDouble();

  static double _special(String s) =>
      s.split('').where((c) => RegExp(r'[^a-zA-Z0-9]').hasMatch(c)).length.toDouble();

  static double _isIp(String host) =>
      RegExp(r'^\d+\.\d+\.\d+\.\d+$').hasMatch(host) ? 1 : 0;
}