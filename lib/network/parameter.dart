class Parameter {
  final String name;
  final String value;

  Parameter(this.name, [this.value]);

  static final _parameterRegex = RegExp('^(\\w+)(\\[(.+)\\])?\$');
  factory Parameter.fromString(String str) {
    final matches = _parameterRegex.firstMatch(str);
    if (matches == null) {
      throw Exception('Could not match command "$str"');
    }
    if(matches.groupCount == 2) {
      return Parameter(matches.group(1));
    }
    return Parameter(matches.group(1), matches.group(3));
  }
  
  static List<Parameter> parameterListFromString(String str) {
    List<Parameter> split = [];

    int lastSplit = 0;
    bool inQuotes = false;
    int quoteCount = 0;
    for (int i = 0; i < str.length; i++) {
      String char = str[i];
      if (char == '"') quoteCount++;
      if (char != '"' && quoteCount > 0) {
        if (quoteCount % 2 != 0) inQuotes = !inQuotes;
        quoteCount = 0;
      }
      if(char == ',' && !inQuotes) {
        split.add(Parameter.fromString(str.substring(lastSplit, i).trim()));
        lastSplit = i+1;
      }
    }
    split.add(Parameter.fromString(str.substring(lastSplit, str.length).trim()));
    return split;
  }

  String toString() => value == null ? name : '$name[$value]';

  Parameter copyWith({
    String name,
    String value,
  }) {
    if ((name == null || identical(name, this.name)) &&
        (value == null || identical(value, this.value))) {
      return this;
    }

    return new Parameter(
      name ?? this.name,
      value ?? this.value,
    );
  }
}
