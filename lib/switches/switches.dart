import 'package:flutter/cupertino.dart';

import 'switch.dart';
import 'switchDisplay.dart';

class Switches extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SwitchesState();
}

class _SwitchesState extends State<Switches> {
  var _switches = <int, Switch>{
    0: Switch(20000, address: 0, state: false, description: ["Links", "Weiche", "0"]),
    1: Switch(20001, address: 1, state: true, description: ["Rechts", "", ""]),
  };
  
  Function switchFunction(int index) {
    return () => {
          setState(() {
            _switches[index] = _switches[index].switchs();
          })
        };
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 59/100,
      crossAxisCount: 4,
      padding: EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: _switches.values
          .map((e) => SwitchDisplay(e, switchFunction(e.address)))
          .toList(),
    );
  }
}
