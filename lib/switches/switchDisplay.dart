import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'switchState.dart';
import 'switchIcon.dart';

class SwitchDisplay extends StatelessWidget {
  SwitchDisplay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SwitchState>(context);

    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
                color: state.state == 1 ? Colors.red[500] : Colors.green[500],
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: FittedBox(
              fit: BoxFit.fill,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => state.setState(state.state == 1 ? 0 : 1),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SwitchIcon(symbol: state.symbol, state: state.state),
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
