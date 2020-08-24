import 'trainState.dart';

import '../consts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainControlDisplay extends StatelessWidget {
  final TrainState _trainState;
  final Function(int) onSpeedChange;
  final Function(Direction) onDirectionChange;

  TrainControlDisplay(this._trainState,
      {this.onSpeedChange, this.onDirectionChange});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color disabledColor = theme.disabledColor;
    Color enabledColor = theme.primaryColor;

    Color dirColor(Direction expectedDirection) =>
        _trainState.direction == expectedDirection ? enabledColor : disabledColor;

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
          value: _trainState.speed.toDouble(),
          min: 0,
          max: _trainState.maxSpeed.toDouble(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: TrainInfo(
            address: _trainState.address,
            protocol: _trainState.protocol,
            speed: _trainState.speed,
            maxSpeed: _trainState.maxSpeed,
          ),
        )
      ],
    );
  }
}

class TrainInfo extends StatelessWidget {
  final int address;
  final String protocol;
  final int speed;
  final int maxSpeed;

  TrainInfo({this.address, this.protocol, this.speed, this.maxSpeed});

  final trainNumberFormat = NumberFormat("[0000]");

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('${trainNumberFormat.format(address)}'),
            Text(' $protocol', style: TextStyle(color: Colors.grey)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Text('$speed', style: TextStyle(fontSize: 24)),
            Text('/$maxSpeed', style: TextStyle(color: Colors.grey))
          ],
        ),
      ],
    );
  }
}
