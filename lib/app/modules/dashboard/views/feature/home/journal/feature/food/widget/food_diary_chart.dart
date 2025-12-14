import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/utils/time_utils.dart';

class FoodDiaryChart extends StatelessWidget {
  final List<DiaryChartData> data;

  const FoodDiaryChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: AnimatedIn(
          child: Text("There are currently no food diaries available."),
        ),
      );
    }

    final chartWidth = data.length * 80.0;

    return InteractiveViewer(
      panEnabled: true,
      scaleEnabled: false,
      child: SizedBox(
        width: chartWidth < MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width
            : chartWidth,
        height: 280,
        child: Column(
          children: [
            // ---------------- LEGEND ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _LegendItem(color: Colors.green, label: "Requirement(Kcal)"),
                _LegendItem(color: Colors.red, label: "Target(Kcal)"),
                _LegendItem(color: Colors.blue, label: "Actual(Kcal)"),
              ],
            ),

            const SizedBox(height: 12),

            // ---------------- CHART ----------------
            Expanded(
              child: AnimatedIn(
                child: BarChart(
                  BarChartData(
                    maxY: _getMaxValue(),
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(enabled: false),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 200,
                      getDrawingHorizontalLine: (value) =>
                          FlLine(color: Colors.black12, strokeWidth: 1),
                    ),
                    borderData: FlBorderData(show: false),

                    // ---------------- TITLES ----------------
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 200,
                          getTitlesWidget: (value, _) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            int index = value.toInt();
                            if (index < 0 || index >= data.length) {
                              return const SizedBox.shrink();
                            }

                            return Transform.rotate(
                              angle: -0.2,
                              child: Column(
                                children: [
                                  const SizedBox(height: 12.0),
                                  Text(
                                    TimeUtils.formatShortDate(
                                      DateTime.parse(data[index].date),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                    ),

                    barGroups: _buildGroups(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================= MAX VALUE =========================
  double _getMaxValue() {
    double maxVal = 0;
    for (var item in data) {
      maxVal = [
        maxVal,
        item.requirement.toDouble(),
        item.target.toDouble(),
        item.actual.toDouble(),
      ].reduce((a, b) => a > b ? a : b);
    }
    return maxVal + 200;
  }

  // ========================= GROUPS =========================
  List<BarChartGroupData> _buildGroups() {
    return List.generate(data.length, (i) {
      final item = data[i];
      return BarChartGroupData(
        x: i,
        barsSpace: 0,
        barRods: [
          BarChartRodData(
            toY: item.requirement.toDouble(),
            width: 16,
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: item.target.toDouble(),
            width: 16,
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: item.actual.toDouble(),
            width: 16,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}

// ========================= MODEL =========================

class DiaryChartData {
  final String date;
  final int requirement;
  final int target;
  final int actual;

  DiaryChartData({
    required this.date,
    required this.requirement,
    required this.target,
    required this.actual,
  });
}

// ========================= LEGEND WIDGET =========================
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        AnimatedIn(child: Text(label, style: const TextStyle(fontSize: 10))),
      ],
    );
  }
}
