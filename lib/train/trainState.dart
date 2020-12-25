import 'dart:async';

import 'package:ecos_communicator/ecos_communicator.dart';
import '../network/argumentList.dart';

import '../network/stationObject.dart';

import 'trainFunctionState.dart';

import '../consts.dart';

class TrainState extends StationObject {
  final Connection _connection;
  final int id;

  int address;
  String protocol;
  String name;
  int speed;
  int maxSpeed;
  Direction direction;
  List<TrainFunctionState> trainFunctions = [];

  StreamSubscription _subscription;

  TrainState(this.id, this._connection);

  Future<void> initData() async {
    final resp = await _connection.send(Request(
        command: 'get',
        id: id,
        arguments: argumentListFromStringList(options)));
    resp.entries.forEach((entry) {
      setOptionArgument(entry.argument);
    });
    _subscription = _connection.getEvents(id).listen((event) {
      setOptionArgument(event.argument);
    });
  }

  Future<void> destroy() async {
    await _subscription?.cancel();
  }

  final List<String> options = [
    'addr',
    'name',
    'protocol',
    'speedstep',
    'dir',
    'func',
    'funcdesc',
  ];

  static final _funcRegex = RegExp('^func\\[(\\d+)\\]\$');

  Future<void> setDirection(Direction dir) async {
    final arg = Argument.native('dir', dir.number.toString());
    await _connection.send(Request(command: 'set', id: id, arguments: {arg}));
    setOptionArgument(arg);
  }

  Future<void> setSpeed(int speed) async {
    final arg = Argument.native('speedstep', speed.toString());
    setOptionArgument(arg);
    await _connection.send(Request(command: 'set', id: id, arguments: {arg}));
  }

  Future<void> switchFunction(TrainFunctionState fs) async {
    final arg = Argument.native('func', '${fs.number},${fs.notOnStr}');
    await _connection.send(Request(command: 'set', id: id, arguments: {arg}));
    setOptionArgument(arg);
  }

  TrainFunctionState getFunction(int id, {addIfNotPresent = false}) {
    return trainFunctions.firstWhere((e) => e.number == id, orElse: () {
      if (!addIfNotPresent) return null;
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
        return direction.number.toString();
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
        direction = Direction.fromString(value);
        break;
      case 'func':
        final matches = _setFuncRegex.firstMatch(value);
        if (matches == null) {
          throw Exception('Could not match func "$name[$value]"');
        }
        int id = int.parse(matches.group(1));
        String on = matches.group(2);
        getFunction(id, addIfNotPresent: true).updateOn(on);
        break;
      case 'funcdesc':
        final matches = _setFuncRegex.firstMatch(value);
        if (matches == null) {
          throw Exception('Could not match func "$name[$value]"');
        }
        int id = int.parse(matches.group(1));
        String desc = matches.group(2);
        getFunction(id)?.updateDescription(desc);
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
