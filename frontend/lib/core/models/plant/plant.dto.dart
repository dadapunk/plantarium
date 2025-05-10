import 'package:json_annotation/json_annotation.dart';
import 'package:plantarium/core/models/task/task.dto.dart';

part 'plant.dto.g.dart';

@JsonSerializable()
class PlantDTO {
  PlantDTO({
    this.id,
    required this.name,
    required this.species,
    this.variety,
    this.description,
    this.plantingDate,
    this.harvestDate,
    this.imageUrl,
    required this.tasks,
  });

  factory PlantDTO.fromJson(Map<String, dynamic> json) =>
      _$PlantDTOFromJson(json);
  final int? id;
  final String name;
  final String species;
  final String? variety;
  final String? description;
  final DateTime? plantingDate;
  final DateTime? harvestDate;
  final String? imageUrl;
  final List<TaskDTO> tasks;
  Map<String, dynamic> toJson() => _$PlantDTOToJson(this);
}
