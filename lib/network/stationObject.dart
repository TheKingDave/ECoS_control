import 'package:flutter/foundation.dart';

abstract class StationObject with ChangeNotifier {
  int get id;
  List<String> get options;
  void setOption(String name, String value);
  String getOption(String name);
}