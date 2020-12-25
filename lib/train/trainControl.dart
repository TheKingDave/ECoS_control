import 'trainState.dart';
import 'package:flutter/material.dart';

import 'trainControlDisplay.dart';
import 'package:provider/provider.dart';

class TrainControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final train = context.watch<TrainState>();

    return train == null
        ? Container()
        : TrainControlDisplay(train,
            onDirectionChange: train.setDirection,
            onSpeedChange: train.setSpeed);
  }
}
