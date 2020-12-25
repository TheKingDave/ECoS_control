import 'package:ecos_communicator/ecos_communicator.dart';
import 'package:flutter/foundation.dart';

abstract class StationObject with ChangeNotifier {
  int get id;
  List<String> get options;
  void setOption(String name, String value);
  String getOption(String name);

  void setOptionArgument(Argument argument) {
    setOption(argument.name, argument.value);
  }
}