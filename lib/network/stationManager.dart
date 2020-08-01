import 'parameter.dart';
import 'package:flutter/foundation.dart';

import 'command.dart';
import 'connection.dart';
import 'messageHandler.dart';
import 'stationState.dart';

class StationManager with ChangeNotifier {
  final StationState state;
  final Connection connection;

  StationManager(this.state, this.connection);

  void initData() async {
    connection.onMessage = MessageHandler(this).onMessage;
    await connection.connect();
    sendCommand(Command(id: 11, type: 'queryObjects'));
  }

  void sendCommand(Command command) {
    connection.send(command.toString());
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }
}

class DebugStationManager extends StationManager {
  DebugStationManager(StationState state) : super(state, null);

  @override
  void initData() {
    for (int i = 0; i < 10; i++) {
      sendCommand(_createDebugSwitch(i));
    }
  }

  Command _createDebugSwitch(int addr) {
    return Command(type: 'set', id: 20000 + addr, parameters: [
      Parameter('state', '0'),
      Parameter('addr', (addr + 1).toString()),
      Parameter('name1', '"Debug"'),
      Parameter('name2', '"Switch"'),
      Parameter('name3', '"${addr + 1}"'),
    ]);
  }

  @override
  void sendCommand(Command command) {
    if (command.type == 'set') {
      for (Parameter p in command.parameters) {
        state.setObjectOption(command.id, p.name, p.value);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
