import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sehati/app/common/utils/time_utils.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/monitoring/widgets/legend_item.dart';

class SleepChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const SleepChart({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No sleep records found"));
    }

    return InteractiveViewer(
      panEnabled: true,
      scaleEnabled: true, 
      child: SizedBox(
        width: data.length * 60.0 < MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width
            : data.length * 60.0,
        height: 300,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  LegendItem(color: Colors.green, label: "Sleeping duration"),
                  SizedBox(width: 20),
                  LegendItem(color: Colors.redAccent, label: "Target"),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 24,
                    gridData: FlGridData(show: true, drawVerticalLine: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, _) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, _) {
                            int index = value.toInt();
                            if (index < 0 || index >= data.length) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              TimeUtils.formatDayMonth(data[index]['date']),
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (int i = 0; i < data.length; i++)
                            FlSpot(i.toDouble(), data[i]["actual"])
                        ],
                        color: Colors.green,
                        barWidth: 3,
                        isCurved: true,
                        dotData: const FlDotData(show: true),
                      ),
                      LineChartBarData(
                        spots: [
                          for (int i = 0; i < data.length; i++)
                            FlSpot(i.toDouble(), data[i]["ideal"])
                        ],
                        color: Colors.redAccent,
                        barWidth: 3,
                        isCurved: true,
                        dotData: const FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
