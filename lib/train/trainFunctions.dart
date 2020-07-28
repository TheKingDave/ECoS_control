import 'trainFunction.dart';
import 'package:flutter/cupertino.dart';

class TrainFunctions extends StatefulWidget {
  @override
  _TrainFunctionState createState() => _TrainFunctionState();
}

class _TrainFunctionState extends State<TrainFunctions> {
  var _states = <int, TrainFunction>{
    0: TrainFunction(number: 0, description: 3, on: true),
    1: TrainFunction(number: 1, description: 4),
    2: TrainFunction(number: 2, description: 5),
    3: TrainFunction(number: 3, description: 7),
    4: TrainFunction(number: 4, description: 8),
    5: TrainFunction(number: 5, description: 36),
  };

  Function switchFunction(int index) {
    return () => {
          setState(() {
            _states[index] = _states[index].switchOn();
          })
        };
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(16),
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: _states.values
            .map((fun) => TrainFunctionDisplay(
                  state: fun,
                  switchFunction: switchFunction(fun.number),
                ))
            .toList());
  }
}
