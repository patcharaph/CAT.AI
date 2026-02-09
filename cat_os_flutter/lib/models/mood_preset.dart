import "package:flutter/material.dart";

class MoodPreset {
  const MoodPreset({
    required this.name,
    required this.backgroundColor,
    required this.faceColor,
    required this.featureColor,
  });

  final String name;
  final Color backgroundColor;
  final Color faceColor;
  final Color featureColor;

  static const List<MoodPreset> presets = <MoodPreset>[
    MoodPreset(
      name: "Classic",
      backgroundColor: Color(0xFFF5F5F7),
      faceColor: Color(0xFFFFFFFF),
      featureColor: Color(0xFF1D1D1F),
    ),
    MoodPreset(
      name: "Midnight",
      backgroundColor: Color(0xFF1D1D1F),
      faceColor: Color(0xFF2C2C2E),
      featureColor: Color(0xFFF5F5F7),
    ),
    MoodPreset(
      name: "Mist",
      backgroundColor: Color(0xFFEDEFF2),
      faceColor: Color(0xFFFFFFFF),
      featureColor: Color(0xFF2A3138),
    ),
  ];
}
