import 'dart:async';

import 'package:ecos_communicator/ecos_communicator.dart';
import '../network/argumentList.dart';

import '../network/stationObject.dart';
import 'package:enum_to_string/enum_to_string.dart';

enum SwitchMode {
  SWITCH,
  PULSE,
}

class SwitchState extends StationObject {
  final Connection _connection;
  final int id;

  int address;
  List<String> description;
  int state;
  SwitchMode mode;
  int symbol;
  StreamSubscription _subscription;

  SwitchState(this.id, this._connection) : description = List(3);

  Future<void> initData() async {
    final resp =
        await _connection.send(Request(command: 'get', id: id, arguments: argumentListFromStringList(options)));
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

  Future<void> setState(int state) async {
    final arg = Argument.native('state', state.toString());
    await _connection.send(Request(command: 'set', id: id, arguments: {
      arg,
    }));
    setOptionArgument(arg);
  }

  @override
  List<String> get options =>
      ['state', 'addr', 'name1', 'name2', 'name3', 'mode', 'symbol'];

  @override
  String getOption(String name) {
    if (name.startsWith('name')) {
      final index = int.parse(name.substring(name.length - 1));
      return description[index];
    }
    switch (name) {
      case 'state':
        return state.toString();
      case 'addr':
        return address.toString();
      case 'mode':
        return EnumToString.convertToString(mode);
      case 'symbol':
        return symbol.toString();
    }
    return null;
  }

  @override
  void setOption(String name, String value) {
    if (name.startsWith('name')) {
      final index = int.parse(name.substring(name.length - 1)) - 1;
      description[index] = value;
    }
    switch (name) {
      case 'state':
        state = int.parse(value);
        break;
      case 'addr':
        address = int.parse(value);
        break;
      case 'mode':
        mode = EnumToString.fromString(SwitchMode.values, value);
        break;
      case 'symbol':
        symbol = int.parse(value);
        break;
    }
    notifyListeners();
  }
}
