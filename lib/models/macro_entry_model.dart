class MacroEntry {
  final String macroType;
  final double grams;
  final double calories;
  final double percentageOfTotalCalories;

  MacroEntry({
    required this.macroType,
    required this.grams,
    required this.calories,
    required this.percentageOfTotalCalories,
  });

  factory MacroEntry.fromJson(Map<String, dynamic> json) {
    return MacroEntry(
      macroType: json['macroType'],
      grams: (json['grams'] as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
      percentageOfTotalCalories: (json['percentageOfTotalCalories'] as num).toDouble(),
    );
  }
}
