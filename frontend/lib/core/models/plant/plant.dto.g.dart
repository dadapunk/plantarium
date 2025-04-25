// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantDTO _$PlantDTOFromJson(Map<String, dynamic> json) => PlantDTO(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      species: json['species'] as String,
      variety: json['variety'] as String?,
      description: json['description'] as String?,
      plantingDate: json['plantingDate'] == null
          ? null
          : DateTime.parse(json['plantingDate'] as String),
      harvestDate: json['harvestDate'] == null
          ? null
          : DateTime.parse(json['harvestDate'] as String),
      imageUrl: json['imageUrl'] as String?,
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => TaskDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlantDTOToJson(PlantDTO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'species': instance.species,
      'variety': instance.variety,
      'description': instance.description,
      'plantingDate': instance.plantingDate?.toIso8601String(),
      'harvestDate': instance.harvestDate?.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'tasks': instance.tasks,
    };
