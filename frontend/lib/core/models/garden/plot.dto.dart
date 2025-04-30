import 'package:json_annotation/json_annotation.dart';
import 'package:plantarium/core/models/plant/plant.dto.dart';

part 'plot.dto.g.dart';

@JsonSerializable()
class PlotDTO {
  PlotDTO({
    this.id,
    required this.name,
    this.description,
    required this.width,
    required this.length,
    this.imageUrl,
    required this.plants,
  });

  factory PlotDTO.fromJson(Map<String, dynamic> json) =>
      _$PlotDTOFromJson(json);
  final int? id;
  final String name;
  final String? description;
  final double width;
  final double length;
  final String? imageUrl;
  final List<PlantDTO> plants;
  Map<String, dynamic> toJson() => _$PlotDTOToJson(this);
}
