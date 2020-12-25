import 'package:ecos_communicator/ecos_communicator.dart';
import 'package:ecos_control/train/trainState.dart';
import 'switches/switchListState.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'connectedScreen.dart';
import 'station/station.dart';

class StationView extends StatefulWidget {
  final StationInfo station;

  StationView(this.station);

  @override
  State<StatefulWidget> createState() => _StationViewState();
}

class _StationViewState extends State<StationView> {
  Connection _connection;
  SwitchListState _switchListState;
  TrainState _trainState;

  @override
  void initState() {
    super.initState();

    _connection = Connection(ConnectionSettings(
        address: widget.station.address, port: widget.station.port));
    _switchListState = SwitchListState(_connection);
    _trainState = TrainState(1002, _connection);
  }

  @override
  void dispose() {
    _connection.close();
    _switchListState.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_switchListState.initData(), _trainState.initData()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }
        return MultiProvider(
          providers: [
            Provider.value(value: _connection),
            ChangeNotifierProvider.value(value: _switchListState),
            ChangeNotifierProvider.value(value: _trainState)
          ],
          child: ConnectedScreen(widget.station.name),
        );
      },
    );
  }
}
