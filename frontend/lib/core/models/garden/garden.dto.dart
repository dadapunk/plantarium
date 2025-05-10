import 'package:json_annotation/json_annotation.dart';
import 'package:plantarium/core/models/plot/plot.dto.dart';
import 'package:plantarium/core/models/user/user.dto.dart';

part 'garden.dto.g.dart';

@JsonSerializable()
class GardenDTO {
  GardenDTO({
    required this.name,
    required this.plots,
    required this.owner,
    this.id,
    this.description,
    this.location,
    this.imageUrl,
  });

  factory GardenDTO.fromJson(final Map<String, dynamic> json) =>
      _$GardenDTOFromJson(json);
  final int? id;
  final String name;
  final String? description;
  final String? location;
  final String? imageUrl;
  final List<PlotDTO> plots;
  final UserDTO owner;
  Map<String, dynamic> toJson() => _$GardenDTOToJson(this);
}
