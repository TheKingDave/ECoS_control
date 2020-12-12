import 'trainState.dart';

import 'trainFunctions.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final train = context.watch<TrainState>();

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).highlightColor, width: 2))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                train?.name ?? 'Select Train',
                style: TextStyle(fontSize: 24),
              ),
              Icon(
                Icons.arrow_drop_down,
                size: 24,
              ),
            ],
          ),
        ),
        Expanded(child: TrainFunctions()),
      ],
    );
  }
}
