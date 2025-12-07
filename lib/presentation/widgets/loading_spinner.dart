import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_new_shapes/material_new_shapes.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({
    super.key,
    this.color,
    this.size = 40.0,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final Color? color;
  final double size;
  final String? semanticsLabel;
  final String? semanticsValue;

  @override
  Widget build(final BuildContext context) => ExpressiveLoadingIndicator(
    color: color ?? Theme.of(context).colorScheme.primary,
    constraints: BoxConstraints(
      minWidth: size,
      minHeight: size,
      maxWidth: size,
      maxHeight: size,
    ),
    polygons: [
      MaterialShapes.softBurst,
      MaterialShapes.pentagon,
      MaterialShapes.pill,
    ],
    semanticsLabel: semanticsLabel ?? 'Loading',
    semanticsValue: semanticsValue ?? 'In progress',
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color))
      ..add(DoubleProperty('size', size))
      ..add(StringProperty('semanticsLabel', semanticsLabel))
      ..add(StringProperty('semanticsValue', semanticsValue));
  }
}
