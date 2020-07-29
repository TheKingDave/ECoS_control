import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ecos_control/network/command.dart';

import 'parameter.dart';
import 'stationState.dart';

import 'networkEvent.dart';

class Connection {
  final StationState _state;
  final String _address;
  final int _port;

  Stream<NetworkEvent> events;
  Socket _socket;
  IncomingMessage _incomingMessage;

  Connection(this._address, this._port, this._state);

  void connect() async {
    _socket = await Socket.connect(_address, _port);
    _socket.listen(_rawDataHandler, onError: errorHandler, onDone: dispose);
  }

  void sendCommand(String command, int id,
      [List<Parameter> parameters = const []]) {
    var paramString = parameters.map((p) => p.toString()).join(',');
    paramString = paramString.isEmpty ? '' : ', $paramString';
    send('$command($id$paramString)');
  }

  void send(String data) {
    _socket.write('$data\n');
  }

  void _rawDataHandler(Uint8List data) {
    final _data = String.fromCharCodes(data).trim();
    final lines = _data.split('\r\n');
    lines.forEach((l) => _dataHandler(l));
  }

  void _dataHandler(String _in) {
    print(_in);
    if (_incomingMessage == null) {
      _incomingMessage = IncomingMessage();
      _incomingMessage.header = _in;
    } else if (_in.startsWith("<")) {
      _incomingMessage.footer = _in;
      _handleMessage(_incomingMessage);
      _incomingMessage = null;
    } else {
      _incomingMessage.addLine(_in);
    }
  }

  static final _dataRegex = RegExp('^(\\d+) (\\w+)\\[(.+)]\$');

  void _handleMessage(IncomingMessage message) {
    if (message.status != 0) {
      print(
          'Message has non 0 zero staus: ${message.status} ${message.statusMessage}');
      return;
    }

    if (message.type == 'REPLY' && message.furtherInfo.startsWith('set')) {
      final cmd = Command.fromString(message.furtherInfo);
      cmd.parameters.forEach((p) => _state.setObjectOption(cmd.id, p.name, p.value));
      return;
    }

    message.lines.forEach((line) {
      final matches = _dataRegex.firstMatch(line);
      if (matches == null) {
        print('Could not find matches for "$line"');
        return;
      }
      _state.setObjectOption(
          int.parse(matches.group(1)), matches.group(2), matches.group(3));
    });
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void dispose() {
    _socket.destroy();
  }
}

class IncomingMessage {
  String type;
  String furtherInfo;

  List<String> lines;

  int status;
  String statusMessage;

  IncomingMessage() : lines = [];

  void addLine(String line) {
    lines.add(line);
  }

  static final _headerRegex = RegExp('^<(\\w+) (.+)>\$');

  void set header(String str) {
    final matches = _headerRegex.firstMatch(str);
    if (matches == null) {
      throw Exception('Could not match header "$str"');
    }
    type = matches.group(1);
    furtherInfo = matches.group(2);
  }

  static final _footerRegex = RegExp('^<END (\\d+) \\((.+)\\)>\$');

  void set footer(String str) {
    final matches = _footerRegex.firstMatch(str);
    if (matches == null) {
      throw Exception('Could not parse footer "$str"');
    }
    status = int.parse(matches.group(1));
    statusMessage = matches.group(2);
  }

  @override
  String toString() {
    return '';
  }
}
