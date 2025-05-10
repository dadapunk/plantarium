import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlantPlot extends StatelessWidget {
  const PlantPlot({Key? key, required this.name, required this.color})
    : super(key: key);
  final String name;
  final Color color;

  @override
  Widget build(final BuildContext context) => Center(
    child: Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('name', name));
    properties.add(ColorProperty('color', color));
  }
}
