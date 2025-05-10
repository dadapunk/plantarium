import 'package:json_annotation/json_annotation.dart';
import 'package:plantarium/core/models/plant/plant.dto.dart';

part 'task.dto.g.dart';

@JsonSerializable()
class TaskDTO {
  TaskDTO({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    this.notes,
    this.plant,
  });

  factory TaskDTO.fromJson(Map<String, dynamic> json) =>
      _$TaskDTOFromJson(json);
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final String? notes;
  final PlantDTO? plant;
  Map<String, dynamic> toJson() => _$TaskDTOToJson(this);
}
