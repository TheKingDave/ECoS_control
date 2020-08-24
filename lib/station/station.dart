class StationInfo {
  static const int defaultPort = 15471;
  final String name;
  final String address;
  final int port;

  StationInfo({this.name, this.address, this.port = defaultPort});

  factory StationInfo.fromString(String str) {
    final split = str.split(RegExp('\n'));
    if (split.length != 3) {
      throw Exception('Could not derive station from string "$str"');
    }
    return StationInfo(
        name: split[0],
        address: split[1],
        port: int.parse(split[2]));
  }

  String toString() {
    return [name, address, port.toString()].join('\n');
  }

  StationInfo copyWith({
    String name,
    String address,
    int port,
  }) {
    if ((name == null || identical(name, this.name)) &&
        (address == null || identical(address, this.address)) &&
        (port == null || identical(port, this.port))) {
      return this;
    }

    return new StationInfo(
      name: name ?? this.name,
      address: address ?? this.address,
      port: port ?? this.port,
    );
  }
}
