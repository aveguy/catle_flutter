class Castle {
  final String id;
  final String name;
  final String type; // "100" or "続100"
  final String prefecture;
  final double? lat;
  final double? lon;

  Castle({
    required this.id,
    required this.name,
    required this.type,
    required this.prefecture,
    this.lat,
    this.lon,
  });

  bool get is100 => type == "100";
}
