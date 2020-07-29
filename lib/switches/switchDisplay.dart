import 'package:flutter/material.dart';

import 'switch.dart' as sw;
import 'switchIcon.dart';

class SwitchDisplay extends StatelessWidget {
  final sw.Switch state;
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
                color: state.state ? Colors.red[800] : Colors.green[700],
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: switchFunction,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SwitchIcon(turned: state.state),
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
