class StepEntry {
  final DateTime date;
  final int stepCount;
  final double stepCaloriesBurnt;

  StepEntry({
    required this.date,
    required this.stepCount,
    required this.stepCaloriesBurnt,
  });

  factory StepEntry.fromJson(Map<String, dynamic> json) {
    return StepEntry(
      date: DateTime.parse(json['date']),
      stepCount: json['stepCount'] as int,
      stepCaloriesBurnt: (json['stepCaloriesBurnt'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'stepCount': stepCount,
      'stepCaloriesBurnt': stepCaloriesBurnt,
    };
  }
}
