import 'package:flutter/cupertino.dart';

import '../network/stationObject.dart';
import 'package:enum_to_string/enum_to_string.dart';

enum SwitchMode {
  SWITCH,
  PULSE,
}

class Switch extends StationObject {
  final int id;
  int address;
  List<String> description;
  bool state;
  SwitchMode mode;

  Switch(this.id,
      {this.address = -1,
      List<String> description,
      this.state = false,
      this.mode = SwitchMode.SWITCH})
      : description = description ?? List(3);

  Switch switchs() {
    return copyWith(state: !state);
  }

  String getSwitchedState() {
    return _boolToString(!state);
  }

  Switch copyWith(
      {int address, List<String> description, bool state, SwitchMode mode}) {
    return Switch(id,
        address: address ?? this.address,
        description: description ?? this.description,
        state: state ?? this.state,
        mode: mode ?? this.mode);
  }

  String _boolToString(bool _bool) {
    return (_bool ? 1 : 0).toString();
  }

  @override
  List<String> get options =>
      ['state', 'addr', 'name1', 'name2', 'name3', 'mode'];

  @override
  String getOption(String name) {
    if (name.startsWith('name')) {
      final index = int.parse(name.substring(name.length - 1));
      return description[index];
    }
    switch (name) {
      case 'state':
        return _boolToString(state);
      case 'addr':
        return address.toString();
      case 'mode':
        return EnumToString.parse(mode);
    }
    return null;
  }

  @override
  void setOption(String name, String value) {
    if (name.startsWith('name')) {
      final index = int.parse(name.substring(name.length - 1)) - 1;
      description[index] = value.substring(1, value.length - 1);
    }
    switch (name) {
      case 'state':
        state = int.parse(value) == 1;
        break;
      case 'addr':
        address = int.parse(value);
        break;
      case 'mode':
        mode = EnumToString.fromString(SwitchMode.values, value);
        break;
    }
    notifyListeners();
  }
}
