// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plot.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlotDTO _$PlotDTOFromJson(Map<String, dynamic> json) => PlotDTO(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      width: (json['width'] as num).toDouble(),
      length: (json['length'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      plants: (json['plants'] as List<dynamic>)
          .map((e) => PlantDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
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
