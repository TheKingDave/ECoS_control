import 'parameter.dart';

class Command {
  final String type;
  final int id;
  final List<Parameter> parameters;

  Command({this.type, this.id, this.parameters = const []});

  static final _commandRegex = RegExp('^(\\w+)\\((\\d+)(?:, (.*))?\\)\$');

  factory Command.fromString(String str) {
    final matches = _commandRegex.firstMatch(str);
    if (matches == null) {
      throw Exception('Could not match command "$str"');
    }

    List<Parameter> parameters = [];
    if (matches.groupCount == 3) {
      parameters = Parameter.parameterListFromString(matches.group(3));
    }

    return Command(
      type: matches.group(1),
      id: int.parse(matches.group(2)),
      parameters: parameters,
    );
  }
  
  @override
  String toString() {
    var paramString = parameters.map((p) => p.toString()).join(',');
    paramString = paramString.isEmpty ? '' : ', $paramString';
    return '$type($id$paramString)';
  }

  Command copyWith({
    String type,
    int id,
    List<Parameter> parameters,
  }) {
    if ((type == null || identical(type, this.type)) &&
        (id == null || identical(id, this.id)) &&
        (parameters == null || identical(parameters, this.parameters))) {
      return this;
    }

    return new Command(
      type: type ?? this.type,
      id: id ?? this.id,
      parameters: parameters ?? this.parameters,
    );
  }
}
