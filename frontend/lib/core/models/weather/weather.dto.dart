import 'package:json_annotation/json_annotation.dart';

part 'weather.dto.g.dart';

@JsonSerializable()
class WeatherDTO {
  final int? id;
  final DateTime timestamp;
  final double temperature;
  final double humidity;
  final double precipitation;
  final double windSpeed;
  final String condition;
  final String? location;

  WeatherDTO({
    this.id,
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    required this.precipitation,
    required this.windSpeed,
    required this.condition,
    this.location,
  });

  factory WeatherDTO.fromJson(Map<String, dynamic> json) =>
      _$WeatherDTOFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDTOToJson(this);
}
