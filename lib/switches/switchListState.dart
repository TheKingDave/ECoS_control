import 'dart:async';

import 'package:ecos_communicator/ecos_communicator.dart';
import 'package:flutter/foundation.dart';

import 'switchState.dart';

class SwitchListState with ChangeNotifier {
  final List<SwitchState> switches = [];
  final Connection _connection;
  final int id = 11;
  StreamSubscription _subscription;

  SwitchListState(this._connection);

  Future<void> initData() async {
    await _initSwitches();
    await _initSubscription();
  }

  Future<void> _initSwitches() async {
    final resp =
        await _connection.send(Request(command: 'queryObjects', id: id));
    final futures = <Future<void>>[];
    resp.entries.forEach((element) {
      final sw = SwitchState(element.id, _connection);
      switches.removeWhere((_sw) => _sw.id == sw.id);
      switches.add(sw);
      futures.add(sw.initData());
    });
    await Future.wait(futures);
  }

  Future<void> _initSubscription() async {
    _subscription = _connection.getEvents(id).listen((event) async {
      if (event.entries.length < 3) {
        return;
      }
      final first = event.entries.removeAt(0).argument;
      if (!(first.name == 'msg' && first.value == 'LIST_CHANGED')) {
        return;
      }
      final last = event.entries.removeLast().argument;

      await Future.wait(event.entries.map((e) => _updateList(e)));
      notifyListeners();

      final removeLength = int.parse(last.value);
      if (removeLength != switches.length) {
        print(
            'WARNING: list size differs, remote: $removeLength, local: ${switches.length}');
      }
    });
  }

  Future<void> destroy() async {
    await _subscription.cancel();
    await Future.wait(switches.map((e) => e.destroy()));
  }

  _updateList(ListEntry e) async {
    final id = e.id;
    final appended = e.argument.name == 'appended';
    if (appended) {
      final sw = SwitchState(id, _connection);
      await sw.initData();
      switches.add(sw);
    } else {
      final index = switches.indexWhere((sw) => sw.id == id);
      final sw = switches.removeAt(index);
      sw.destroy();
    }
  }
}
