import 'trainFunctionState.dart';

import '../consts.dart';
import '../network/stationObject.dart';

class TrainState extends StationObject {
  final int id;
  int address;
  String protocol;
  String name;
  int speed;
  int maxSpeed;
  Direction direction;
  List<TrainFunctionState> trainFunctions = [];

  TrainState(this.id,
      {this.address,
      this.protocol,
      this.name,
      this.speed,
      this.maxSpeed,
      this.direction});

  final List<String> options = [
    'addr',
    'name',
    'protocol',
    'speedstep',
    'dir',
    'func',
    'funcdesc',
  ];

  static const protocolMaxSpeedMap = <String, int>{
    'DCC28': 28,
    'DCC128': 126,
  };

  static paramToDir(String param) =>
      param == '0' ? Direction.forward : Direction.backward;

  static dirToParam(Direction dir) => dir == Direction.forward ? '0' : '1';

  static final _funcRegex = RegExp('^func\\[(\\d+)\\]\$');

  TrainFunctionState getFunction(int id) {
    return trainFunctions.firstWhere((e) => e.number == id, orElse: () {
      final _add = TrainFunctionState(id);
      trainFunctions.add(_add);
      return _add;
    });
  }

  @override
  String getOption(String name) {
    if (name.startsWith('func')) {
      final matches = _funcRegex.firstMatch(name);
      if (matches == null) {
        throw Exception('Could not match func "$name"');
      }
      int id = int.parse(matches.group(1));
      return trainFunctions.firstWhere((f) => f.number == id).toString();
    }
    switch (name) {
      case 'addr':
        return address.toString();
      case 'name':
        return this.name;
      case 'protocol':
        return protocol;
      case 'speedstep':
        return speed.toString();
      case 'dir':
        return dirToParam(direction);
    }
    return null;
  }

  static final _setFuncRegex = RegExp('^(\\d+),(\\d+)\$');

  @override
  void setOption(String name, String value) {
    switch (name.toLowerCase()) {
      case 'addr':
        address = int.parse(value);
        break;
      case 'name':
        this.name = value;
        break;
      case 'protocol':
        protocol = value;
        maxSpeed = protocolMaxSpeedMap[value];
        break;
      case 'speedstep':
        speed = int.parse(value);
        break;
      case 'dir':
        direction = paramToDir(value);
        break;
      case 'func':
        final matches = _setFuncRegex.firstMatch(value);
        if (matches == null) {
          throw Exception('Could not match func "$name[$value]"');
        }
        int id = int.parse(matches.group(1));
        String on = matches.group(2);
        getFunction(id).updateOn(on);
        break;
      case 'funcdesc':
        final matches = _setFuncRegex.firstMatch(value);
        if (matches == null) {
          throw Exception('Could not match func "$name[$value]"');
        }
        int id = int.parse(matches.group(1));
        String desc = matches.group(2);
        getFunction(id).updateDescription(desc);
        break;
    }
    if (options.contains(name)) {
      notifyListeners();
    }
  }

  @override
  String toString() {
    return 'TrainState{id: $id, address: $address, protocol: $protocol, name: '
        '$name, speed: $speed, maxSpeed: $maxSpeed, direction: $direction, '
        'trainFunctions: $trainFunctions}';
  }
}
