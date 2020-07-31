import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'networkEvent.dart';

class Connection {
  final String _address;
  final int _port;
  Function(IncomingMessage) onMessage;

  Stream<NetworkEvent> events;
  Socket _socket;
  IncomingMessage _incomingMessage;

  Connection(this._address, this._port, [this.onMessage]);

  void connect() async {
    _socket = await Socket.connect(_address, _port);
    final stringTransformer = StreamTransformer<Uint8List, String>.fromHandlers(
        handleData: (Uint8List data, EventSink sink) =>
            sink.add(String.fromCharCodes(data)));
    _socket
        .transform(stringTransformer)
        .transform(LineSplitter())
        .listen(_dataHandler, onError: errorHandler, onDone: dispose);
  }

  void send(String data) {
    _socket.write('$data\n');
  }

  void _dataHandler(String _in) {
    //print(_in);
    if (_incomingMessage == null) {
      _incomingMessage = IncomingMessage();
      _incomingMessage.header = _in;
    } else if (_in.startsWith("<")) {
      _incomingMessage.footer = _in;
      onMessage(_incomingMessage);
      _incomingMessage = null;
    } else {
      _incomingMessage.addLine(_in);
    }
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
