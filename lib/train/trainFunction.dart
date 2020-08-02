import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrainFunction {
  final int id;
  final int description;
  final bool moment;
  final bool on;

  TrainFunction({this.id, this.description, this.moment = false, this.on = false});
  
  TrainFunction switchOn() {
    return copyWith(on: !on);
  }
  
  TrainFunction copyWith({int number, int description, bool moment, bool on}) {
    return TrainFunction(
      id: number ?? this.id,
      description: description ?? this.description,
      moment: moment ?? this.moment,
      on: on ?? this.on,
    );
  }
}

class TrainFunctionDisplay extends StatelessWidget {
  final TrainFunction state;
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
                  child: Text('${state.id}'),
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
