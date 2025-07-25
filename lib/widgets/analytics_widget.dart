import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/macro_entry_model.dart';
import '../models/step_entry_model.dart';
import 'macro_donut_chart.dart';
import 'step_bar_chart.dart';

Widget buildAnalyticsUI(List<MacroEntry> macroData, List<StepEntry> steps) {
  final sortedMacros = [...macroData]..sort(
        (a, b) => b.percentageOfTotalCalories.compareTo(a.percentageOfTotalCalories),
  );

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionCard(
          title: "Macro Breakdown",
          child: Column(
            children: [
              const SizedBox(height: 10),
              MacroDonutChart(macros: sortedMacros),
              const SizedBox(height: 16),
              ...sortedMacros.map((macro) => _macroProgress(macro)).toList(),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _sectionCard(
            title: "Steps (Weekly)",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 250,
                child: StepBarChart(stepData: steps),
              ),
              const SizedBox(height: 16),
              ...steps.map((step) {
                final formattedDate = DateFormat('EEE, MMM d').format(step.date);
                final isToday = _isSameDay(step.date, DateTime.now());

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isToday ? Colors.green[50] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: isToday ? Colors.blue : Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          formattedDate,
                          style: TextStyle(
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                            color: isToday ? Colors.blue[900] : Colors.black87,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${step.stepCount} steps',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14,),
                          ),
                          Text(
                            '${step.stepCaloriesBurnt.toStringAsFixed(1)} kcal',
                            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _macroProgress(MacroEntry macro) {
  final color = _getMacroColor(macro.macroType);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${macro.macroType}: ${macro.grams}g  |  ${macro.calories.toStringAsFixed(1)} kcal",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: macro.percentageOfTotalCalories / 100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: Colors.grey[300],
            minHeight: 8,
          ),
        ),
      ],
    ),
  );
}

Widget _sectionCard({required String title, required Widget child}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    ),
  );
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

Color _getMacroColor(String type) {
  switch (type.toLowerCase()) {
    case 'carbs':
      return Colors.blue;
    case 'protein':
      return Colors.orange;
    case 'fat':
      return Colors.red;
    default:
      return Colors.white;
  }
}
