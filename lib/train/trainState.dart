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
  final List<TrainFunctionState> trainFunctions;

  TrainState(
      {this.id,
        this.address,
      this.protocol,
      this.name,
      this.speed,
      this.maxSpeed,
      this.direction,
      this.trainFunctions = const []});
  
  final List<String> options = [
    'addr',
    'name',
    'protocol',
    'speedstep',
    'dir',
  ];

  static final _funcRegex = RegExp('^func\\[(\\d+)\\]\$');

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
        return name;
      case 'protocol':
        return protocol;
      case 'speedstep':
        return speed.toString();
      case 'dir':
        return direction == Direction.forward ? '0' : '1';
    }
    return null;
  }

  @override
  void setOption(String name, String value) {
    if(name.startsWith('func')) {
      final matches = _funcRegex.firstMatch(name);
      if (matches == null) {
        throw Exception('Could not match func "$name"');
      }
      int id = int.parse(matches.group(1));
      trainFunctions.firstWhere((f) => f.number == id).update(value);
      return;
    }
    switch(name) {
      case 'addr':
        address = int.parse(value);
        break;
      case 'name':
        name = value;
        break;
      case 'protocol':
        protocol = value;
        break;
      case 'speedstep':
        speed = int.parse(value);
        break;
      case 'dir':
        direction = value == '0' ? Direction.forward : Direction.backward;
        break;
    }
    if(options.contains(name)) {
      notifyListeners();
    }
  }

}
