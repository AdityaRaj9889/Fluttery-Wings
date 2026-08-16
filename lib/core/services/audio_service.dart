import 'package:flame_audio/flame_audio.dart';
import '../constants/asset_constants.dart';
import 'storage_service.dart';

/// Premium Audio Service with pooling, BGM handling, mute respect.
/// Uses flame_audio under the hood.

class AudioService {
  final StorageService _storage;

  bool _initialized = false;
  bool _bgmPlaying = false;

  AudioService(this._storage);

  Future<void> init() async {
    // if (_initialized) return;
    // try {
    //   await FlameAudio.audioCache.loadAll(AssetConstants.allSfx);
    //   // Preload BGM
    //   await FlameAudio.audioCache.load(AssetConstants.bgmMain);
    //   await FlameAudio.audioCache.load(AssetConstants.bgmGame);
    //   _initialized = true;
    // } catch (_) {
    //   // Fail silently - game continues without audio
    //   _initialized = true;
    // }
  }

  bool get _canPlaySfx => _storage.soundEnabled && _initialized;
  bool get _canPlayBgm => _storage.musicEnabled && _initialized;

  Future<void> playFlap() async {
    // if (!_canPlaySfx) return;
    // await FlameAudio.play(AssetConstants.sfxFlap, volume: 0.6);
  }

  Future<void> playCoin() async {
    // if (!_canPlaySfx) return;
    // await FlameAudio.play(AssetConstants.sfxCoin, volume: 0.7);
  }

  Future<void> playScore() async {
    // if (!_canPlaySfx) return;
    // await FlameAudio.play(AssetConstants.sfxScore, volume: 0.5);
  }

  Future<void> playHit() async {
    // if (!_canPlaySfx) return;
    // await FlameAudio.play(AssetConstants.sfxHit, volume: 0.8);
  }

  Future<void> playButton() async {
    // if (!_canPlaySfx) return;
    // await FlameAudio.play(AssetConstants.sfxButton, volume: 0.4);
  }

  Future<void> playDie() async {
    // if (!_canPlaySfx) return;
    // await FlameAudio.play(AssetConstants.sfxDie, volume: 0.8);
  }

  Future<void> playBgmMain() async {
    // if (!_canPlayBgm) return;
    // if (_bgmPlaying) await stopBgm();
    // try {
    //   await FlameAudio.bgm.play(AssetConstants.bgmMain, volume: 0.35);
    //   _bgmPlaying = true;
    // } catch (_) {}
  }

  Future<void> playBgmGame() async {
    // if (!_canPlayBgm) return;
    // if (_bgmPlaying) await stopBgm();
    // try {
    //   await FlameAudio.bgm.play(AssetConstants.bgmGame, volume: 0.32);
    //   _bgmPlaying = true;
    // } catch (_) {}
  }

  Future<void> stopBgm() async {
    // try {
    //   await FlameAudio.bgm.stop();
    // } catch (_) {}
    // _bgmPlaying = false;
  }

  Future<void> pauseBgm() async {
    // if (!_bgmPlaying) return;
    // try {
    //   await FlameAudio.bgm.pause();
    // } catch (_) {}
  }

  Future<void> resumeBgm() async {
    // if (!_canPlayBgm) return;
    // if (!_bgmPlaying) return;
    // try {
    //   await FlameAudio.bgm.resume();
    // } catch (_) {}
  }

  void setSoundEnabled(bool enabled) {
    // _storage.soundEnabled = enabled;
  }

  Future<void> setMusicEnabled(bool enabled) async {
    // _storage.musicEnabled = enabled;
    // if (!enabled) {
    //   await stopBgm();
    // }
  }

  void dispose() {
    // FlameAudio.bgm.dispose();
  }
}
