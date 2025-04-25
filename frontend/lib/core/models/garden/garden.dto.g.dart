// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GardenDTO _$GardenDTOFromJson(Map<String, dynamic> json) => GardenDTO(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      imageUrl: json['imageUrl'] as String?,
      plots: (json['plots'] as List<dynamic>)
          .map((e) => PlotDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      owner: UserDTO.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GardenDTOToJson(GardenDTO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'imageUrl': instance.imageUrl,
      'plots': instance.plots,
      'owner': instance.owner,
    };
