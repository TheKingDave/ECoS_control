import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'station.dart';

class StationDisplay extends StatelessWidget {
  final Station _station;
  final Function() onTap;
  final Function() onRemove;

  StationDisplay(this._station, {this.onTap, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_station.name),
      subtitle: Text('${_station.address}:${_station.port}'),
      onTap: onTap,
      onLongPress: onRemove,
    );
  }
}
