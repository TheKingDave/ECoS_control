import 'package:ecos_control/switches/switchIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Switch {
  final int number;
  final List<String> description;
  final bool red;

  Switch({this.number, this.description, this.red});

  Switch switchs() {
    return copyWith(red: !red);
  }

  Switch copyWith({int number, List<String> description, bool red}) {
    return Switch(
        number: number ?? this.number,
        description: description ?? this.description,
        red: red ?? this.red);
  }
}

class SwitchDisplay extends StatelessWidget {
  final Switch state;
  final Function() switchFunction;

  SwitchDisplay(this.state, this.switchFunction);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
                color: state.red ? Colors.red[800] : Colors.green[700],
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: switchFunction,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SwitchIcon(turned: state.red),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(padding: EdgeInsets.only(bottom: 8)),
        Text(
          state.description.join('\n').trim(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
