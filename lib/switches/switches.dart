import 'package:flutter/cupertino.dart';

import 'switch.dart';

class Switches extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SwitchesState();
}

class _SwitchesState extends State<Switches> {
  var _switches = <int, Switch>{
    0: Switch(number: 0, red: false, description: ["Links", "Weiche", "0"]),
    1: Switch(number: 1, red: true, description: ["Rechts", "", ""]),
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
          .map((e) => SwitchDisplay(e, switchFunction(e.number)))
          .toList(),
    );
  }
}
