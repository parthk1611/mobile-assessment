class RouteOption {
  final String mode;
  final double distanceKm;
  final int timeMin;
  final int co2g;
  final double score;

  RouteOption({
    required this.mode,
    required this.distanceKm,
    required this.timeMin,
    required this.co2g,
    required this.score,
  });

  factory RouteOption.fromJson(Map<String, dynamic> json) => RouteOption(
        mode: json['mode'],
        distanceKm: (json['distance_km'] as num).toDouble(),
        timeMin: (json['time_min'] as num).toInt(),
        co2g: (json['co2_g'] as num).toInt(),
        score: (json['score'] as num).toDouble(),
      );
}