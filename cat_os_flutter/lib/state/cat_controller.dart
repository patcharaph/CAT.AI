import "dart:async";
import "dart:math";

import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../models/behavior_memory.dart";
import "../models/emotion.dart";
import "../models/mood_preset.dart";
import "../services/memory_storage.dart";

class CatController extends ChangeNotifier with WidgetsBindingObserver {
  CatController({required this.storage}) {
    WidgetsBinding.instance.addObserver(this);
    unawaited(_bootstrap());
  }

  final MemoryStorage storage;
  final Random _random = Random();

  BehaviorMemory _memory = BehaviorMemory.initial();
  Emotion _emotion = Emotion.neutral;
  Offset _gaze = Offset.zero;
  double _blinkScale = 1.0;
  String? _microIcon;
  bool _isReady = false;

  Timer? _blinkTimer;
  Timer? _energyTimer;
  Timer? _stimulationTimer;
  Timer? _microIconTimer;

  Emotion get emotion => _emotion;
  Offset get gaze => _gaze;
  double get blinkScale => _blinkScale;
  String? get microIcon => _microIcon;
  bool get isReady => _isReady;
  int get friendship => _memory.friendship;
  int get energy => _memory.energy;
  int get stimulation => _memory.stimulation;
  MoodPreset get moodPreset {
    return MoodPreset
        .presets[_memory.moodPresetIndex % MoodPreset.presets.length];
  }

  Future<void> _bootstrap() async {
    _memory = await storage.load();
    _memory.friendship = _memory.friendship.clamp(0, 100).toInt();
    _memory.energy = _memory.energy.clamp(0, 100).toInt();
    _memory.stimulation = _memory.stimulation.clamp(0, 100).toInt();

    final DateTime now = DateTime.now();
    _applyOfflineDecay(now);
    _emotion = _resolveDefaultEmotion(now);
    _isReady = true;
    _startTimers();
    unawaited(_persist());
    notifyListeners();
  }

  void handleTap() {
    if (!_isReady) {
      return;
    }
    _registerInteraction(stimulationBoost: 8);
    HapticFeedback.lightImpact();

    if (_memory.energy < 20) {
      _setEmotion(Emotion.sleepy);
      _showMicroIcon("\u{1F4A4}");
      _notifyAndPersist();
      return;
    }

    final Emotion rolled = _rollTapEmotion();
    _setEmotion(rolled);
    _showMicroIcon(_iconForEmotion(rolled));
    _notifyAndPersist();
  }

  void handleLongPress() {
    if (!_isReady) {
      return;
    }
    _registerInteraction(stimulationBoost: 14);
    HapticFeedback.mediumImpact();

    if (_memory.energy < 20) {
      _setEmotion(Emotion.sleepy);
      _showMicroIcon("\u{1F4A4}");
    } else {
      _setEmotion(Emotion.excited);
      _showMicroIcon("\u{2728}");
    }
    _notifyAndPersist();
  }

  void handleSwipe(int direction) {
    if (!_isReady) {
      return;
    }
    _registerInteraction(stimulationBoost: 3);
    HapticFeedback.selectionClick();

    final int count = MoodPreset.presets.length;
    final int next = (_memory.moodPresetIndex + direction) % count;
    _memory.moodPresetIndex = next < 0 ? next + count : next;
    _showMicroIcon("\u{1F3A8}");
    _notifyAndPersist();
  }

  void updateGaze({
    required Offset localPosition,
    required Size bounds,
  }) {
    if (bounds.width <= 0 || bounds.height <= 0) {
      return;
    }

    final Offset center = bounds.center(Offset.zero);
    final double normalizedX =
        ((localPosition.dx - center.dx) / (bounds.width * 0.5))
            .clamp(-1.0, 1.0);
    final double normalizedY =
        ((localPosition.dy - center.dy) / (bounds.height * 0.5))
            .clamp(-1.0, 1.0);
    _gaze = Offset(normalizedX, normalizedY);
    notifyListeners();
  }

  void resetGaze() {
    _gaze = Offset.zero;
    notifyListeners();
  }

  void _setEmotion(Emotion value) {
    if (_memory.energy < 20) {
      _emotion = Emotion.sleepy;
      return;
    }
    _emotion = value;
  }

  Emotion _rollTapEmotion() {
    final double trustRatio = _memory.friendship / 100.0;
    final double happyWeight = 0.20 + (0.60 * trustRatio);
    final double angryWeight = 0.55 - (0.50 * trustRatio);
    const double neutralWeight = 0.25;

    final double total = happyWeight + angryWeight + neutralWeight;
    final double seed = _random.nextDouble() * total;

    if (seed <= happyWeight) {
      return Emotion.happy;
    }
    if (seed <= happyWeight + angryWeight) {
      return Emotion.angry;
    }
    return Emotion.neutral;
  }

  void _registerInteraction({required int stimulationBoost}) {
    final DateTime now = DateTime.now();
    _memory.friendship = min(100, _memory.friendship + 1);
    _memory.stimulation = min(100, _memory.stimulation + stimulationBoost);
    _memory.lastInteractionAt = now;
    _memory.lastStimulationTick = now;
  }

  String _iconForEmotion(Emotion emotion) {
    switch (emotion) {
      case Emotion.happy:
        return "\u{2764}";
      case Emotion.angry:
        return "\u{26A1}";
      case Emotion.sad:
        return "\u{1F622}";
      case Emotion.sleepy:
        return "\u{1F4A4}";
      case Emotion.excited:
        return "\u{2728}";
      case Emotion.neutral:
        return "\u{25CF}";
    }
  }

  void _showMicroIcon(String icon) {
    _microIconTimer?.cancel();
    _microIcon = icon;
    notifyListeners();

    _microIconTimer = Timer(const Duration(milliseconds: 800), () {
      _microIcon = null;
      notifyListeners();
    });
  }

  Emotion _resolveDefaultEmotion(DateTime now) {
    if (_memory.energy < 20) {
      return Emotion.sleepy;
    }
    if (_memory.stimulation == 0 &&
        now.difference(_memory.lastInteractionAt) >=
            const Duration(minutes: 30)) {
      return Emotion.sad;
    }
    return Emotion.neutral;
  }

  void _applyOfflineDecay(DateTime now) {
    final DateTime? lastExit = _memory.lastExitAt;
    if (lastExit != null) {
      final Duration awayDuration = now.difference(lastExit);
      if (awayDuration.inHours > 0) {
        _memory.energy = max(0, _memory.energy - (awayDuration.inHours * 5));
      }
      if (awayDuration.inHours >= 24) {
        final int friendshipDrop = awayDuration.inHours ~/ 24;
        _memory.friendship = max(0, _memory.friendship - friendshipDrop);
      }
    }

    final int stimulationDecaySteps =
        now.difference(_memory.lastStimulationTick).inMinutes ~/ 5;
    if (stimulationDecaySteps > 0) {
      _memory.stimulation = max(0, _memory.stimulation - stimulationDecaySteps);
      _memory.lastStimulationTick = _memory.lastStimulationTick.add(
        Duration(minutes: stimulationDecaySteps * 5),
      );
    }

    _memory.lastEnergyTick = now;
    _memory.lastExitAt = now;
  }

  void _startTimers() {
    _scheduleBlink();
    _energyTimer?.cancel();
    _stimulationTimer?.cancel();

    _energyTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _applyEnergyDecayTick();
    });

    _stimulationTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _applyStimulationDecayTick();
    });
  }

  void _scheduleBlink() {
    _blinkTimer?.cancel();
    final int seconds = 5 + _random.nextInt(6);
    _blinkTimer = Timer(Duration(seconds: seconds), () {
      _blinkScale = 0.08;
      notifyListeners();

      Future<void>.delayed(const Duration(milliseconds: 120), () {
        _blinkScale = 1.0;
        notifyListeners();
        _scheduleBlink();
      });
    });
  }

  void _applyEnergyDecayTick() {
    final DateTime now = DateTime.now();
    final int elapsedHours = now.difference(_memory.lastEnergyTick).inHours;
    if (elapsedHours <= 0) {
      return;
    }

    _memory.energy = max(0, _memory.energy - (elapsedHours * 5));
    _memory.lastEnergyTick = _memory.lastEnergyTick.add(
      Duration(hours: elapsedHours),
    );
    if (_memory.energy < 20) {
      _emotion = Emotion.sleepy;
    }
    _notifyAndPersist();
  }

  void _applyStimulationDecayTick() {
    final DateTime now = DateTime.now();
    final int elapsedSteps =
        now.difference(_memory.lastStimulationTick).inMinutes ~/ 5;

    bool hasChanges = false;
    if (elapsedSteps > 0) {
      _memory.stimulation = max(0, _memory.stimulation - elapsedSteps);
      _memory.lastStimulationTick = _memory.lastStimulationTick.add(
        Duration(minutes: elapsedSteps * 5),
      );
      hasChanges = true;
    }

    final bool idleTooLong = now.difference(_memory.lastInteractionAt) >=
        const Duration(minutes: 30);
    if (_memory.stimulation == 0 && idleTooLong && _memory.energy >= 20) {
      if (_emotion != Emotion.sad) {
        _emotion = Emotion.sad;
        hasChanges = true;
      }
    }

    if (hasChanges) {
      _notifyAndPersist();
    }
  }

  Future<void> _persist() async {
    await storage.save(_memory);
  }

  void _notifyAndPersist() {
    notifyListeners();
    unawaited(_persist());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isReady) {
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _memory.lastExitAt = DateTime.now();
      unawaited(_persist());
    }

    if (state == AppLifecycleState.resumed) {
      final DateTime now = DateTime.now();
      _applyOfflineDecay(now);
      _emotion = _resolveDefaultEmotion(now);
      _notifyAndPersist();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _blinkTimer?.cancel();
    _energyTimer?.cancel();
    _stimulationTimer?.cancel();
    _microIconTimer?.cancel();
    super.dispose();
  }
}
