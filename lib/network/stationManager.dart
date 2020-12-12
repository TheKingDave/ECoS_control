import '../train/trainState.dart';

import '../consts.dart';
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

  void setSwitchState(int id, String state) {
    sendCommand(
        Command(type: 'set', id: id, parameters: [Parameter('state', state)]));
  }

  void setTrainDirection(int id, Direction direction) {
    sendCommand(Command(
        type: 'set',
        id: id,
        parameters: [Parameter('dir', TrainState.dirToParam(direction))]));
  }

  void setTrainSpeed(int id, int speed) {
    sendCommand(Command(
        type: 'set',
        id: id,
        parameters: [Parameter('speedstep', speed.toString())]));
  }
  
  void setTrainFunctionState(int id, int function, String state) {
    sendCommand(Command(
      type: 'set',
      id: id,
      parameters: [Parameter('func', '$function,$state')],
    ));
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
    sendCommand(Command(type: 'set', id: 1007, parameters: [
      Parameter('addr', '3'),
      Parameter('protocol', 'DCC128'),
      Parameter('name', 'Taurus ÖBB'),
      Parameter('symbol', '30'),
      Parameter('dir', '1'),
      Parameter('speedstep', '12'),
    ]));
    
    sendCommand(Command(type: 'set', id: 1007, parameters: [
      Parameter('func', '0,0'),
      Parameter('funcdesc', '0,3'),
      Parameter('func', '1,0'),
      Parameter('funcdesc', '1,32'),
    ]));
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
    print('sendCommand($command)');
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
