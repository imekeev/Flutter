/// R9: sealed class. Любой switch по Countdown обязан покрыть все три случая.
sealed class Countdown {
  const Countdown();
}

class Upcoming extends Countdown {
  const Upcoming(this.left);
  final Duration left;
}

class Started extends Countdown {
  const Started(this.since);
  final Duration since;
}

class Ended extends Countdown {
  const Ended();
}