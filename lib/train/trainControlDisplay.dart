import '../consts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainControlDisplay extends StatelessWidget {
  final int number;
  final String protocol;
  final String name;
  final int speed;
  final int maxSpeed;
  final Direction direction;
  final Function(int) onSpeedChange;
  final Function(Direction) onDirectionChange;

  TrainControlDisplay(
      {this.number,
      this.protocol,
      this.name,
      this.speed,
      this.maxSpeed,
      this.direction,
      this.onSpeedChange,
      this.onDirectionChange});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color disabledColor = theme.disabledColor;
    Color enabledColor = theme.primaryColor;

    Color dirColor(Direction expectedDirection) =>
        direction == expectedDirection ? enabledColor : disabledColor;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                iconSize: 50,
                onPressed: () => onDirectionChange(Direction.backward),
                icon: Icon(Icons.arrow_back_ios,
                    color: dirColor(Direction.backward)),
              ),
              Expanded(
                  child: Image.asset('assets/images/schnelli.jpg', height: 50)),
              IconButton(
                iconSize: 50,
                onPressed: () => onDirectionChange(Direction.forward),
                icon: Icon(Icons.arrow_forward_ios,
                    color: dirColor(Direction.forward)),
              ),
            ],
          ),
        ),
        Slider(
          onChanged: (speed) => onSpeedChange(speed.toInt()),
          value: speed.toDouble(),
          min: 0,
          max: maxSpeed.toDouble(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: TrainInfo(
            number: number,
            protocol: protocol,
            name: name,
            speed: speed,
            maxSpeed: maxSpeed,
          ),
        )
      ],
    );
  }
}

class TrainInfo extends StatelessWidget {
  final int number;
  final String protocol;
  final String name;
  final int speed;
  final int maxSpeed;

  TrainInfo({this.number, this.protocol, this.name, this.speed, this.maxSpeed});

  final trainNumberFormat = NumberFormat("[0000]");

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Text('${trainNumberFormat.format(number)}'),
              Text(' $protocol', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Align(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(name, style: TextStyle(fontSize: 24))),
                alignment: Alignment.center),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text('$speed', style: TextStyle(fontSize: 24)),
              Text('/$maxSpeed', style: TextStyle(color: Colors.grey))
            ],
          ),
        ),
      ],
    );
  }
}
