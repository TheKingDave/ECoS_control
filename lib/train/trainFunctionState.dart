import 'package:flutter/cupertino.dart';

class TrainFunctionState with ChangeNotifier {
  int number;
  int description;
  bool moment;
  bool on;

  TrainFunctionState(this.number, this.description, this.moment, this.on);

  void update(String value) {
    
  }
  
  String get onStr {
    return on ? '1' : '0';
  }

  @override
  String toString() {
    return 'func[$number, $onStr]';
  }
}
