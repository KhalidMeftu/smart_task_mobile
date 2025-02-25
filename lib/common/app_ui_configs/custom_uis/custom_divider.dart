import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final Color color;
  final double height;
  final double thickness;

  const CustomDivider({
    super.key,
    this.color = Colors.grey,
    this.height = 20.0,
    this.thickness = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      height: height,
      thickness: thickness,
    );
  }
}