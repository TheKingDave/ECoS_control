import 'trainFunctionState.dart';

import 'trainState.dart';
import 'package:flutter/material.dart';

import 'trainFunction.dart';
import 'package:provider/provider.dart';

class TrainFunctions extends StatefulWidget {
  @override
  _TrainFunctionState createState() => _TrainFunctionState();
}

class _TrainFunctionState extends State<TrainFunctions> {
  @override
  Widget build(BuildContext context) {
    final train = context.watch<TrainState>();

    if (train == null) {
      return Container();
    }

    return GridView.count(
        padding: EdgeInsets.all(16),
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: train.trainFunctions
            .map((fun) => TrainFunctionDisplay(
                  state: fun,
                  switchFunction: () => train.switchFunction(fun),
                ))
            .toList());
  }
}
