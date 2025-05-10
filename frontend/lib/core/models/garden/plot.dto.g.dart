// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plot.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlotDTO _$PlotDTOFromJson(Map<String, dynamic> json) => PlotDTO(
      name: json['name'] as String,
      width: (json['width'] as num).toDouble(),
      length: (json['length'] as num).toDouble(),
      plants: (json['plants'] as List<dynamic>)
          .map((e) => PlantDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: (json['id'] as num?)?.toInt(),
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$PlotDTOToJson(PlotDTO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'width': instance.width,
      'length': instance.length,
      'imageUrl': instance.imageUrl,
      'plants': instance.plants,
    };
