import 'station/stationDisplay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'station/AddStationDialog.dart';
import 'station/station.dart';

class UnconnectedScreen extends StatefulWidget {
  _UnconnectedScreenState createState() => _UnconnectedScreenState();
}

class _UnconnectedScreenState extends State<UnconnectedScreen> {
  static const _stationsKey = 'stations';
  var _stations = <Station>[];
  Future<SharedPreferences> _prefs;
  BuildContext _context;

  @override
  void initState() {
    super.initState();
    _prefs = SharedPreferences.getInstance();
    _getStations();
  }

  void _getStations() async {
    final list = await (await _prefs).getStringList(_stationsKey);
    final s = <Station>[];
    var couldLoadALl = true;
    list.forEach((element) {
      try {
        s.add(Station.fromString(element));
      } on Exception catch (e) {
        // Ignore, just dont use
        couldLoadALl = false;
        print(e);
      }
    });
    if (!couldLoadALl) {
      Scaffold.of(_context).showSnackBar(SnackBar(
        content: Text('Could not load all stations'),
        backgroundColor: Theme.of(_context).errorColor,
      ));
    }
    setState(() {
      _stations = s;
    });
  }

  void _saveStations() async {
    await (await _prefs).setStringList(
        _stationsKey, _stations.map((s) => s.toString()).toList());
  }

  void _addStation(Station station) async {
    setState(() {
      _stations.add(station);
    });
    _saveStations();
  }

  void _removeStation(Station station) async {
    setState(() {
      _stations.remove(station);
    });
    _saveStations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("ECoS Control")),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final station =
                await Navigator.of(context).push<Station>(MaterialPageRoute(
              builder: (context) => AddStationDialog(),
              fullscreenDialog: true,
            ));
            if (station != null) {
              _addStation(station);
            }
          },
        ),
        body: Builder(builder: (context) {
          _context = context;
          return ListView(
            children: _stations
                .map((station) => StationDisplay(
                      station,
                      onRemove: () => _removeStation(station),
                    ))
                .toList(),
          );
        }));
  }
}
