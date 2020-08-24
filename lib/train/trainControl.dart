import 'trainState.dart';
import 'package:flutter/material.dart';

import '../network/stationManager.dart';

import 'trainControlDisplay.dart';
import 'package:provider/provider.dart';

class TrainControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<StationManager>(context);
    final train = context.watch<TrainState>();

    print(train);
    
    final onDirChange = (direction) {
      manager.setTrainDirection(train.id, direction);
    };

    final onSpeedChange = (speed) {
      manager.setTrainSpeed(train.id, speed);
    };

    return train == null ? Container() : TrainControlDisplay(train,
        onDirectionChange: onDirChange, onSpeedChange: onSpeedChange);
  }
}
