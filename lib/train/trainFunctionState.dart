import 'package:flutter/cupertino.dart';

class TrainFunctionState with ChangeNotifier {
  int number;
  int description;
  bool moment;
  bool on;

  TrainFunctionState(this.number, {this.description, this.moment, this.on});

  void updateOn(String on) {
    this.on = on == '1';
    this.notifyListeners();
  }

  void updateDescription(String desc) {
    this.description = int.parse(desc);
    this.notifyListeners();
  }

  String get onStr {
    return on ? '1' : '0';
  }
  
  String get notOnStr {
    return on ? '0' : '1';
  }

  @override
  String toString() {
    return 'TrainFunctionState{number: $number, description: $description, moment: $moment, on: $on}';
  }
}
