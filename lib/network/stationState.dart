import 'package:flutter/foundation.dart';

import '../switches/switch.dart' as sw;

import 'stationObject.dart';

class StationState with ChangeNotifier {
  final Map<int, StationObject> _objects;

  StationState() : _objects = {};

  void createObjectWithId(int id) {
    if (id >= 20000) {
      _objects[id] = sw.Switch();
    }
    if (id >= 1000) {
      // Train
    }
  }

  StationObject getObject(int id) {
    if (_objects[id] == null) {
      createObjectWithId(id);
    }
    return _objects[id];
  }

  void setObjectOption(int id, String name, String value) {
    getObject(id).setOption(name, value);
    //notifyListeners();
  }

  String getObjectOption(int id, String name) {
    return getObject(id).getOption(name);
  }
}
