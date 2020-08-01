import 'stationManager.dart';
import 'connection.dart';

import 'command.dart';
import 'parameter.dart';

class MessageHandler {
  final StationManager _station;
  
  MessageHandler(this._station);
  
  static final _dataRegex = RegExp('^(\\d+) (\\w+)\\[(.+)]\$');
  void onMessage(IncomingMessage message) {
    if (message.status != 0) {
      print(
          'Message has non 0 zero staus: ${message.status} ${message.statusMessage}');
      return;
    }

    if (message.type == 'REPLY' &&
        message.furtherInfo.startsWith('queryObjects')) {
      final cmd = Command.fromString(message.furtherInfo);
      if (cmd.id == 11) {
        message.lines.forEach((s) {
          int id = int.parse(s.trim());
          if (id >= 30000) return;
          _station.sendCommand(Command(type: 'get', id: id, parameters: [
            Parameter('addr'),
            Parameter('name1'),
            Parameter('name2'),
            Parameter('name3'),
            Parameter('state'),
            Parameter('mode'),
          ]));
          _station.sendCommand(Command(
              type: 'request', id: id, parameters: [Parameter('view')]));
        });
      }
      return;
    }

    if (message.type == 'REPLY' && message.furtherInfo.startsWith('set')) {
      final cmd = Command.fromString(message.furtherInfo);
      cmd.parameters
          .forEach((p) => _station.state.setObjectOption(cmd.id, p.name, p.value));
      return;
    }

    message.lines.forEach((line) {
      final matches = _dataRegex.firstMatch(line);
      if (matches == null) {
        print('Could not find matches for "$line"');
        return;
      }
      _station.state.setObjectOption(
          int.parse(matches.group(1)), matches.group(2), matches.group(3));
    });
  }
  
}