import 'package:ecos_communicator/ecos_communicator.dart';

Set<Argument> argumentListFromStringList(List<String> list) {
  return list.map((e) => Argument.name(e)).toSet();
}