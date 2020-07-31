import 'package:flutter/foundation.dart';

import 'command.dart';
import 'connection.dart';
import 'stationState.dart';

class Station with ChangeNotifier {
  final StationState state;
  final Connection connection;

  Station(this.state, this.connection);

  void initData() async {
    await connection.connect();
    sendCommand(Command(id: 11, type: 'queryObjects'));
  }

  void sendCommand(Command command) {
    connection.send(command.toString());
  }

  @override
  void dispose() {
    connection.dispose();
    super.dispose();
  }
}
