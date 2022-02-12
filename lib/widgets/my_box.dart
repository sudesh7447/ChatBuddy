import 'package:flutter/material.dart';

class MyBox extends StatelessWidget {
  const MyBox({
    Key? key,
    required this.color1,
    required this.icon,
    required this.color2,
    this.iconSize = 28,
  }) : super(key: key);
  final Color color1, color2;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: color1,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Icon(
        icon,
        color: color2,
        size: iconSize,
      ),
    );
  }
}
