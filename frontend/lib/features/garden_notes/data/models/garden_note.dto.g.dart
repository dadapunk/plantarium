// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_note.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GardenNoteDTO _$GardenNoteDTOFromJson(Map<String, dynamic> json) =>
    GardenNoteDTO(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      note: json['note'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$GardenNoteDTOToJson(GardenNoteDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'note': instance.note,
      'date': instance.date.toIso8601String(),
    };
