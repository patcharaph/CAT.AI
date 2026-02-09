class BehaviorMemory {
  BehaviorMemory({
    required this.friendship,
    required this.energy,
    required this.stimulation,
    required this.moodPresetIndex,
    required this.lastEnergyTick,
    required this.lastStimulationTick,
    required this.lastInteractionAt,
    required this.lastExitAt,
  });

  int friendship;
  int energy;
  int stimulation;
  int moodPresetIndex;
  DateTime lastEnergyTick;
  DateTime lastStimulationTick;
  DateTime lastInteractionAt;
  DateTime? lastExitAt;

  factory BehaviorMemory.initial() {
    final DateTime now = DateTime.now();
    return BehaviorMemory(
      friendship: 50,
      energy: 100,
      stimulation: 40,
      moodPresetIndex: 0,
      lastEnergyTick: now,
      lastStimulationTick: now,
      lastInteractionAt: now,
      lastExitAt: now,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      "friendship": friendship,
      "energy": energy,
      "stimulation": stimulation,
      "moodPresetIndex": moodPresetIndex,
      "lastEnergyTickMs": lastEnergyTick.millisecondsSinceEpoch,
      "lastStimulationTickMs": lastStimulationTick.millisecondsSinceEpoch,
      "lastInteractionAtMs": lastInteractionAt.millisecondsSinceEpoch,
      "lastExitAtMs": lastExitAt?.millisecondsSinceEpoch,
    };
  }

  factory BehaviorMemory.fromJson(Map<String, Object?> json) {
    DateTime safeDate(
      Object? value, {
      required DateTime fallback,
    }) {
      if (value is num) {
        return DateTime.fromMillisecondsSinceEpoch(value.toInt());
      }
      return fallback;
    }

    final DateTime now = DateTime.now();
    return BehaviorMemory(
      friendship: (json["friendship"] as num?)?.toInt() ?? 50,
      energy: (json["energy"] as num?)?.toInt() ?? 100,
      stimulation: (json["stimulation"] as num?)?.toInt() ?? 40,
      moodPresetIndex: (json["moodPresetIndex"] as num?)?.toInt() ?? 0,
      lastEnergyTick: safeDate(json["lastEnergyTickMs"], fallback: now),
      lastStimulationTick: safeDate(
        json["lastStimulationTickMs"],
        fallback: now,
      ),
      lastInteractionAt: safeDate(json["lastInteractionAtMs"], fallback: now),
      lastExitAt: (json["lastExitAtMs"] as num?) == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              (json["lastExitAtMs"] as num).toInt(),
            ),
    );
  }
}
