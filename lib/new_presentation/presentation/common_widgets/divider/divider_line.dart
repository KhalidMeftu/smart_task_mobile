import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double thickness;
  final double indent;
  final double endIndent;
  final Color color;

  const CustomDivider({
    super.key,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }
}
