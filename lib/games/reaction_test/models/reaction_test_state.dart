import 'package:flutter/material.dart';

enum ReactionTestStatus {
  idle,
  waiting,
  colorChanged,
  testing,
  completed,
}

class ColorPreset {
  final String name;
  final Color beforeColor;
  final Color afterColor;

  const ColorPreset({
    required this.name,
    required this.beforeColor,
    required this.afterColor,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'beforeColor': beforeColor.toHex(),
    'afterColor': afterColor.toHex(),
  };

  factory ColorPreset.fromJson(Map<String, dynamic> json) {
    return ColorPreset(
      name: json['name'] as String,
      beforeColor: HexColor.fromHex(json['beforeColor'] as String),
      afterColor: HexColor.fromHex(json['afterColor'] as String),
    );
  }
}

extension HexColor on Color {
  String toHex() => '#${(toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  static Color fromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class ReactionTestState {
  final ReactionTestStatus status;
  final int currentTestNumber;
  final List<int> reactionTimes;
  final int averageReactionTime;
  final int selectedPresetIndex;
  final Color beforeColor;
  final Color afterColor;
  final int? startTime;
  final int? endTime;

  const ReactionTestState({
    required this.status,
    required this.currentTestNumber,
    required this.reactionTimes,
    required this.averageReactionTime,
    required this.selectedPresetIndex,
    required this.beforeColor,
    required this.afterColor,
    this.startTime,
    this.endTime,
  });

  static const List<ColorPreset> colorPresets = [
    ColorPreset(
      name: 'Red-Green (Colorblind)',
      beforeColor: Color(0xFFFF6B6B),
      afterColor: Color(0xFF4ECDC4),
    ),
    ColorPreset(
      name: 'Blue-Yellow (Colorblind)',
      beforeColor: Color(0xFF3498DB),
      afterColor: Color(0xFFF1C40F),
    ),
    ColorPreset(
      name: 'Monochromacy (Grayscale)',
      beforeColor: Color(0xFF555555),
      afterColor: Color(0xFFFFFFFF),
    ),
  ];

  static const List<Color> customColors = [
    Color(0xFFFF00FF),
    Color(0xFFFF0000),
    Color(0xFFFFFF00),
    Color(0xFFFF8000),
    Color(0xFF8B0000),
    Color(0xFF00FF00),
    Color(0xFF006400),
    Color(0xFF4B0082),
    Color(0xFF00FFFF),
    Color(0xFF808080),
    Color(0xFF000000),
    Color(0xFFFFFFFF),
  ];

  factory ReactionTestState.initial() {
    final preset = colorPresets[0];
    return ReactionTestState(
      status: ReactionTestStatus.idle,
      currentTestNumber: 1,
      reactionTimes: const [],
      averageReactionTime: 0,
      selectedPresetIndex: 0,
      beforeColor: preset.beforeColor,
      afterColor: preset.afterColor,
    );
  }

  ReactionTestState copyWith({
    ReactionTestStatus? status,
    int? currentTestNumber,
    List<int>? reactionTimes,
    int? averageReactionTime,
    int? selectedPresetIndex,
    Color? beforeColor,
    Color? afterColor,
    int? startTime,
    int? endTime,
  }) {
    return ReactionTestState(
      status: status ?? this.status,
      currentTestNumber: currentTestNumber ?? this.currentTestNumber,
      reactionTimes: reactionTimes ?? this.reactionTimes,
      averageReactionTime: averageReactionTime ?? this.averageReactionTime,
      selectedPresetIndex: selectedPresetIndex ?? this.selectedPresetIndex,
      beforeColor: beforeColor ?? this.beforeColor,
      afterColor: afterColor ?? this.afterColor,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ReactionTestState) return false;
    return status == other.status &&
        currentTestNumber == other.currentTestNumber &&
        _listEquals(reactionTimes, other.reactionTimes) &&
        averageReactionTime == other.averageReactionTime &&
        selectedPresetIndex == other.selectedPresetIndex &&
        beforeColor == other.beforeColor &&
        afterColor == other.afterColor &&
        startTime == other.startTime &&
        endTime == other.endTime;
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    status,
    currentTestNumber,
    Object.hashAll(reactionTimes),
    averageReactionTime,
    selectedPresetIndex,
    beforeColor,
    afterColor,
    startTime,
    endTime,
  );

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'currentTestNumber': currentTestNumber,
    'reactionTimes': reactionTimes,
    'averageReactionTime': averageReactionTime,
    'selectedPresetIndex': selectedPresetIndex,
    'beforeColor': beforeColor.toHex(),
    'afterColor': afterColor.toHex(),
    'startTime': startTime,
    'endTime': endTime,
  };

  factory ReactionTestState.fromJson(Map<String, dynamic> json) {
    return ReactionTestState(
      status: ReactionTestStatus.values.byName(json['status'] as String),
      currentTestNumber: json['currentTestNumber'] as int,
      reactionTimes: (json['reactionTimes'] as List<dynamic>).cast<int>(),
      averageReactionTime: json['averageReactionTime'] as int,
      selectedPresetIndex: json['selectedPresetIndex'] as int,
      beforeColor: HexColor.fromHex(json['beforeColor'] as String),
      afterColor: HexColor.fromHex(json['afterColor'] as String),
      startTime: json['startTime'] as int?,
      endTime: json['endTime'] as int?,
    );
  }

  @override
  String toString() =>
      'ReactionTestState(status: $status, test: $currentTestNumber, avg: ${averageReactionTime}ms)';
}
