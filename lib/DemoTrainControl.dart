import 'package:ecos_control/trainControlDisplay.dart';
import 'package:flutter/cupertino.dart';
import 'consts.dart';

class DemoTrainControl extends StatefulWidget {
  final int number;
  final String protocol;
  final String name;
  final int speed;
  final int maxSpeed;
  final Direction direction;

  DemoTrainControl(
      {this.number,
        this.protocol,
        this.name,
        this.speed,
        this.maxSpeed,
        this.direction});
  
  @override
  _DemoTrainControlState createState() => _DemoTrainControlState(speed, direction);
  
}

class _DemoTrainControlState extends State<DemoTrainControl> {
  int _speed;
  Direction _direction;
  
  _DemoTrainControlState(this._speed, this._direction);
  
  void _onSpeedChange(int value) {
    setState(() {
      this._speed = value;
    });
  }
  
  void _onDirectionChange(Direction direction) {
    setState(() {
      this._direction = direction;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return TrainControlDisplay(
      speed: _speed,
      maxSpeed: widget.maxSpeed,
      name: widget.name,
      protocol: widget.protocol,
      number: widget.number,
      direction: _direction,
      onSpeedChange: _onSpeedChange,
      onDirectionChange: _onDirectionChange,
    );
  }
  
}