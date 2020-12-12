import 'stationView.dart';

import 'station/stationDisplay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'station/addStationDialog.dart';
import 'station/station.dart';

class UnconnectedScreen extends StatefulWidget {
  _UnconnectedScreenState createState() => _UnconnectedScreenState();
}

class _UnconnectedScreenState extends State<UnconnectedScreen> {
  static const _stationsKey = 'stations';
  var _stations = <StationInfo>[];
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
    final s = <StationInfo>[];
    var couldLoadALl = true;
    list?.forEach((element) {
      try {
        s.add(StationInfo.fromString(element));
      } on Exception catch (e) {
        // Ignore, just dont use
        couldLoadALl = false;
        print(e);
      }
    });
    if (!couldLoadALl) {
      ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
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

  void _addStation(StationInfo station) async {
    setState(() {
      _stations.add(station);
    });
    _saveStations();
  }

  void _removeStation(StationInfo station) async {
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
                await Navigator.of(context).push<StationInfo>(MaterialPageRoute(
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
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StationView(station),
                        ));
                      },
                      onRemove: () => _removeStation(station),
                    ))
                .toList(),
          );
        }));
  }
}
