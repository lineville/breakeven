class GameState {
  final int count;
  final String action;

  GameState({this.count = 0, this.action = "..."});

  GameState copyWith({count, action}) {
    return new GameState(
        count: count ?? this.count,
        action: action ?? this.action
    );
  }

}