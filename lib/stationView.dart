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
    await _connection.initData();
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
            builder: (context, station, _) => GridView.count(
                  padding: EdgeInsets.all(16),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 59 / 100,
                  crossAxisCount: 4,
                  children: station.switches
                      .map((s) => ChangeNotifierProvider.value(
                          value: s,
                          child: Consumer<sw.Switch>(
                            builder: (context, _switch, _) => SwitchDisplay(
                                _switch,
                                () => _connection.sendCommand(
                                        'set', _switch.id, [
                                      Parameter(
                                          'state', _switch.getSwitchedState())
                                    ])),
                          )))
                      .toList(),
                )),
      ),
    );
  }
}
