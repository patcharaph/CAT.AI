import "dart:convert";

import "package:shared_preferences/shared_preferences.dart";

import "../models/behavior_memory.dart";

class MemoryStorage {
  static const String _memoryKey = "cat_os_behavior_memory_v1";

  Future<BehaviorMemory> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_memoryKey);
    if (raw == null) {
      return BehaviorMemory.initial();
    }

    try {
      final Map<String, Object?> decoded =
          jsonDecode(raw) as Map<String, Object?>;
      return BehaviorMemory.fromJson(decoded);
    } catch (_) {
      return BehaviorMemory.initial();
    }
  }

  Future<void> save(BehaviorMemory memory) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_memoryKey, jsonEncode(memory.toJson()));
  }
}
