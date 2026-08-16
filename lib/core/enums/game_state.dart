enum GameState {
  initializing,
  ready,
  playing,
  paused,
  frozen, // NEW: screen freezed after ad / resume click, tap to show TAP TO FLAP
  gameOver,
  reviving,
}

extension GameStateX on GameState {
  bool get isPlaying => this == GameState.playing;
  bool get isGameOver => this == GameState.gameOver;
  bool get isFrozen => this == GameState.frozen;
  bool get canFlap => this == GameState.playing;
  bool get canRestart =>
      this == GameState.gameOver ||
      this == GameState.ready ||
      this == GameState.frozen;
}
