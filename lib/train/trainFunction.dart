import 'trainFunctionState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrainFunctionDisplay extends StatelessWidget {
  final TrainFunctionState state;
  final Function() switchFunction;

  TrainFunctionDisplay({this.state, this.switchFunction});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
            color: state.on
                ? Colors.yellow[800]
                : Theme.of(context).highlightColor,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: InkWell(
          onTap: switchFunction,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                FittedBox(
                    fit: BoxFit.fill,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(FunctionIcons.icons[state.description]),
                    )),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text('${state.number}'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FunctionIcons {
  static final icons = {
    2: Icons.functions,
    3: Icons.lightbulb_outline,
    4: Icons.lightbulb_outline,
    5: Icons.lightbulb_outline,
    7: Icons.music_note,
    8: Icons.surround_sound,
    36: Icons.notifications_active
  };
}
