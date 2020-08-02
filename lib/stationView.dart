import 'connectedScreen.dart';
import 'network/stationManager.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _station),
        ChangeNotifierProvider.value(value: _station.state),
      ],
      child: ConnectedScreen(widget.station.name),
    );
  }
}
