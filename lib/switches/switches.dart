import '../network/stationState.dart';

import 'switch.dart';

import '../network/stationManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'switchDisplay.dart';

class Switches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<StationManager>(context, listen: false);
    final state = Provider.of<StationState>(context);

    return GridView.count(
      childAspectRatio: 59 / 100,
      crossAxisCount: 4,
      padding: EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: state.switches
          .map((s) => ChangeNotifierProvider.value(
              value: s,
              child: Consumer<Switch>(
                  builder: (context, sw, _) => SwitchDisplay(
                      sw,
                      () =>
                          {sm.setSwitchState(sw.id, sw.getSwitchedState())}))))
          .toList(),
    );
  }
}
