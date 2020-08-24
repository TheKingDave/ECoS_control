import '../train/trainState.dart';
import '../switches/switch.dart';

import 'package:flutter/foundation.dart';

import 'stationObject.dart';

class StationState with ChangeNotifier {
  final Map<int, StationObject> _objects;
  int selectedTrainId = 1007;

  List<Switch> get switches {
    return _objects.entries
        .where((e) => e.key >= 20000 && e.key < 30000)
        .map((e) => e.value as Switch)
        .toList();
  }

  TrainState get selectedTrain =>
      selectedTrainId < 0 ? null : _objects[selectedTrainId] as TrainState;

  List<TrainState> get trains {
    return _objects.entries
        .where((e) => e.key >= 1000 && e.key < 10000)
        .map((e) => e.value as TrainState)
        .toList();
  }

  StationState() : _objects = {};

  void createObjectWithId(int id) {
    if (_objects.containsKey(id)) return;
    if (id >= 30000) {
      // route
    } else if (id >= 20000) {
      _objects[id] = Switch(id);
    } else if (id >= 1000) {
      _objects[id] = TrainState(id);
      // train
    }
    notifyListeners();
  }

  StationObject getObject(int id) {
    if (!_objects.containsKey(id)) {
      createObjectWithId(id);
    }
    return _objects[id];
  }

  void setObjectOption(int id, String name, String value) {
    getObject(id).setOption(name, value);
  }

  String getObjectOption(int id, String name) {
    return getObject(id).getOption(name);
  }
}
