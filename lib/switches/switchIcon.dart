import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/svg.dart';

class SwitchIcon extends StatelessWidget {
  final int symbol;
  final int state;
  
  SwitchIcon({this.symbol, this.state});

  static const String _straight = 'assets/images/switchStraight.svg';
  static const String _bent = 'assets/images/switchBent.svg';

  static const _defaultSymbol = 0;
  static const _defaultState = 0;
  final _iconMap = <int, Map<int, Widget>>{
    0: {
      0: SvgPicture.asset(_straight),
      1: SvgPicture.asset(_bent),
    },
    1: {
      0: Transform(alignment: Alignment.center, transform: Matrix4.rotationY(math.pi), child: SvgPicture.asset(_straight)),
      1: Transform(alignment: Alignment.center, transform: Matrix4.rotationY(math.pi), child: SvgPicture.asset(_bent)),
    },
    9: {
      0: SvgPicture.asset('assets/images/signal2Green.svg'),
      1: SvgPicture.asset('assets/images/signal2Red.svg'),
    },
    10: {
      0: SvgPicture.asset('assets/images/signal4Yellow.svg'),
      1: SvgPicture.asset('assets/images/signal4Red.svg'),
    },
    11: {
      0: SvgPicture.asset('assets/images/signal4Green.svg'),
      1: SvgPicture.asset('assets/images/signal4Red.svg'),
      2: SvgPicture.asset('assets/images/signal4Yellow.svg'),
    },
  };

  @override
  Widget build(BuildContext context) {
    final _symbol = _iconMap.containsKey(symbol) ? symbol : _defaultSymbol;
    final _state = _iconMap[_symbol].containsKey(state) ? state : _defaultState;

    return _iconMap[_symbol][_state];
  }
  
}