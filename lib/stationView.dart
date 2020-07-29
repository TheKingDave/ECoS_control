import 'network/stationObject.dart';

import 'network/parameter.dart';
import 'switches/switchDisplay.dart';
import 'switches/switch.dart' as sw;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'network/connection.dart';
import 'package:flutter/cupertino.dart';

import 'network/stationState.dart';
import 'station/station.dart';

class StationView extends StatefulWidget {
  final Station station;

  StationView(this.station);

  @override
  State<StatefulWidget> createState() => _StationViewState();
}

class _StationViewState extends State<StationView> {
  Connection _connection;
  StationState _state;

  @override
  void initState() {
    super.initState();
    _state = StationState();
    _connection =
        Connection(widget.station.address, widget.station.port, _state);
    _send();
  }

  @override
  void dispose() {
    _connection.dispose();
    super.dispose();
  }

  void _send() async {
    await _connection.connect();
    print(Parameter.parameterListFromString('state[0], name1["test,"""], name2["hallo"]'));
    _connection.sendCommand('get', 20020, [
      Parameter('state'),
      Parameter('addr'),
      Parameter('name1'),
      Parameter('name2'),
      Parameter('name3'),
      Parameter('mode'),
    ]);
    _connection.sendCommand('request', 20020, [Parameter('view')]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.name),
      ),
      body: ChangeNotifierProvider.value(
        value: _state,
        child: Consumer<StationState>(
          builder: (context, station, _) => ChangeNotifierProvider.value(
            value: station.getObject(20020),
            child: Consumer<StationObject>(
              builder: (context, so, _) {
                final _switch = so as sw.Switch;
                return SwitchDisplay(
                    _switch,
                    () => _connection.sendCommand('set', 20020,
                        [Parameter('state', _switch.getSwitchedState())]));
              },
            ),
          ),
        ),
      ),
    );
  }
}
