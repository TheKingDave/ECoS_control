class Direction {
  final String string;
  final int number;

  const Direction._(this.string, this.number);

  Direction changed() {
    if(this == forward) return backward;
    return forward;
  }

  factory Direction.fromString(String str) => str == '0' ? forward : backward;

  static const forward = Direction._('forward', 0);
  static const backward = Direction._('backward', 1);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Direction &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => string.hashCode ^ number.hashCode;
}

const protocolMaxSpeedMap = <String, int>{
  'DCC28': 28,
  'DCC128': 126,
};