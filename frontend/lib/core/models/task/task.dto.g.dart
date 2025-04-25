// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDTO _$TaskDTOFromJson(Map<String, dynamic> json) => TaskDTO(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      isCompleted: json['isCompleted'] as bool,
      notes: json['notes'] as String?,
      plant: json['plant'] == null
          ? null
          : PlantDTO.fromJson(json['plant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskDTOToJson(TaskDTO instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dueDate': instance.dueDate.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'notes': instance.notes,
      'plant': instance.plant,
    };
