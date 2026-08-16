import 'package:flutter/services.dart';
import 'storage_service.dart';

/// Haptics wrapper respecting user settings.
/// Premium feel on all interactions.

class HapticService {
  final StorageService _storage;
  HapticService(this._storage);

  bool get _enabled => _storage.hapticsEnabled;

  Future<void> light() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
  }

  Future<void> medium() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
  }

  Future<void> heavy() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
  }

  Future<void> selection() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }

  Future<void> vibrate() async {
    if (!_enabled) return;
    await HapticFeedback.vibrate();
  }
}
