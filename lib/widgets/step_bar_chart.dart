import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/step_entry_model.dart';

class StepBarChart extends StatelessWidget {
  final List<StepEntry> stepData;

  const StepBarChart({Key? key, required this.stepData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxY = (stepData.map((e) => e.stepCount).fold<int>(0, (a, b) => a > b ? a : b)).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY + 1000,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.black87,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final date = DateFormat('MMM d').format(stepData[group.x.toInt()].date);
                  return BarTooltipItem(
                    '$date\n${rod.toY.toInt()} steps',
                    const TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 1000,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey[300],
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  interval: 1000,
                  getTitlesWidget: (value, _) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index >= 0 && index < stepData.length) {
                      final date = stepData[index].date;
                      return SideTitleWidget(
                        axisSide: AxisSide.bottom,
                        space: 8,
                        child: Text(
                          DateFormat('MM/dd').format(date),
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: stepData.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isToday = _isSameDay(step.date, DateTime.now());

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: step.stepCount.toDouble(),
                    color: isToday ? Colors.green : Colors.blue,
                    width: 18,
                    borderRadius: BorderRadius.circular(6),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxY + 1000,
                      color: Colors.grey[200],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
