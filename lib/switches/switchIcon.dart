import 'package:flutter/material.dart';
import 'dart:math' as math;

class SwitchIcon extends StatelessWidget {
  final turned;
  
  const SwitchIcon({this.turned = false});
  
  @override
  Widget build(BuildContext context) {
    final icon = Icon(Icons.call_split);
    if(!turned) {
      return icon;
    } else {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: icon,
      );
    }
  }
  
}