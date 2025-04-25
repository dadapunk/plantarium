// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherDTO _$WeatherDTOFromJson(Map<String, dynamic> json) => WeatherDTO(
      id: (json['id'] as num?)?.toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      condition: json['condition'] as String,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$WeatherDTOToJson(WeatherDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'precipitation': instance.precipitation,
      'windSpeed': instance.windSpeed,
      'condition': instance.condition,
      'location': instance.location,
    };
