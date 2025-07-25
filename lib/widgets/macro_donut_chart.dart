import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/macro_entry_model.dart';

class MacroDonutChart extends StatelessWidget {
  final List<MacroEntry> macros;

  const MacroDonutChart({super.key, required this.macros});

  @override
  Widget build(BuildContext context) {
    final total = macros.fold<double>(0, (sum, item) => sum + item.calories);

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 60,
          sectionsSpace: 2,
          sections: macros.map((macro) {
            final percentage = (macro.calories / total * 100).toStringAsFixed(1);
            return PieChartSectionData(
              value: macro.calories,
              title: '${macro.macroType}\n$percentage%',
              radius: 80,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              color: _getMacroColor(macro.macroType),
            );
          }).toList(),
        ),
      ),
    );
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
}
