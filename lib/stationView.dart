import 'network/messageHandler.dart';

import 'network/command.dart';
import 'network/parameter.dart';
import 'network/stationManager.dart';
import 'switches/switchDisplay.dart';
import 'switches/switch.dart' as sw;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'network/connection.dart';
import 'package:flutter/cupertino.dart';

import 'network/stationState.dart';
import 'station/station.dart';

class StationView extends StatefulWidget {
  final StationInfo station;

  StationView(this.station);

  @override
  State<StatefulWidget> createState() => _StationViewState();
}

class _StationViewState extends State<StationView> {
  StationManager _station;

  @override
  void initState() {
    super.initState();
    final _state = StationState();
    if (widget.station.address == 'debug' && widget.station.port == 45227) {
      _station = DebugStationManager(_state);
    } else {
      final _connection =
          Connection(widget.station.address, widget.station.port);
      _station = StationManager(_state, _connection);
    }

    _station.initData();
  }

  @override
  void dispose() {
    _station.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.name),
      ),
      body: ChangeNotifierProvider.value(
        value: _station.state,
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
                                () => _station.sendCommand(Command(
                                        type: 'set',
                                        id: _switch.id,
                                        parameters: [
                                          Parameter('state',
                                              _switch.getSwitchedState())
                                        ]))),
                          )))
                      .toList(),
                )),
      ),
    );
  }
}
