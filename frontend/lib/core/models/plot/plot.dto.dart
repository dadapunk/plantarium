import 'package:json_annotation/json_annotation.dart';
import '../plant/plant.dto.dart';

part 'plot.dto.g.dart';

@JsonSerializable()
class PlotDTO {
  final int? id;
  final String name;
  final String description;
  final double width;
  final double length;
  final String soilType;
  final String sunlightExposure;
  final List<PlantDTO> plants;

  PlotDTO({
    this.id,
    required this.name,
    required this.description,
    required this.width,
    required this.length,
    required this.soilType,
    required this.sunlightExposure,
    required this.plants,
  });

  factory PlotDTO.fromJson(Map<String, dynamic> json) =>
      _$PlotDTOFromJson(json);
  Map<String, dynamic> toJson() => _$PlotDTOToJson(this);

  double get area => length * width;
}
