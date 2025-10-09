import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/domain/entity/monthly_totals.dart';
import 'package:spendwise_1/utils/formatters.dart';

class MonthlyBarChart extends StatefulWidget {
  final List<MonthlyTotals> data;

  const MonthlyBarChart({super.key, required this.data});

  @override
  State<MonthlyBarChart> createState() => _MonthlyBarChartState();
}

class _MonthlyBarChartState extends State<MonthlyBarChart> {
  int touchedIndex = -1;

  String _getMonthName(int month) {
    const monthNames = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return monthNames[month - 1];
  }

  List<BarChartGroupData> _buildBarGroups() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final monthData = entry.value;
      final isTouched = index == touchedIndex;

      return BarChartGroupData(
        x: monthData.month - 1,
        barRods: [
          // Barra de Ingresos
          BarChartRodData(
            toY: monthData.income,
            color: AppPalette.cAccent,
            width: isTouched ? 18 : 14,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              color: AppPalette.cComponent3,
            ),
          ),
          // Barra de Gastos
          BarChartRodData(
            toY: monthData.expense,
            color: Colors.redAccent,
            width: isTouched ? 18 : 14,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              color: AppPalette.cComponent3,
            ),
          ),
        ],
        barsSpace: 4,
      );
    }).toList();
  }

  double _getMaxY() {
    double maxValue = 0.0; // Cambiado a double literal
    for (var monthData in widget.data) {
      if (monthData.income > maxValue) maxValue = monthData.income;
      if (monthData.expense > maxValue) maxValue = monthData.expense;
    }

    return maxValue * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(
        child: Text(
          'No hay datos para mostrar',
          style: TextStyle(color: AppPalette.cText, fontSize: 16),
        ),
      );
    }

    final double rawMaxY = _getMaxY(); // Explícitamente double
    final double effectiveMaxY = rawMaxY > 0
        ? rawMaxY
        : 100000.0; // Fallback como double

    return Column(
      children: [
        // Leyenda
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Ingresos', AppPalette.cAccent),
              const SizedBox(width: 24),
              _buildLegendItem('Gastos', Colors.redAccent),
            ],
          ),
        ),

        SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, top: 16),
            child: BarChart(
              BarChartData(
                maxY: effectiveMaxY,
                minY: 0,
                barGroups: _buildBarGroups(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          barTouchResponse == null ||
                          barTouchResponse.spot == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => AppPalette.cComponent,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final monthData = widget.data[groupIndex];
                      final isIncome = rodIndex == 0;
                      final value = isIncome
                          ? monthData.income
                          : monthData.expense;
                      final label = isIncome ? 'Ingresos' : 'Gastos';

                      return BarTooltipItem(
                        '$label\n${formatToCOP(value)}',
                        TextStyle(
                          color: AppPalette.cText,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < 12) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _getMonthName(value.toInt() + 1),
                              style: const TextStyle(
                                color: AppPalette.grisClaro,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) {
                          return const Text(
                            '\$0',
                            style: TextStyle(
                              color: AppPalette.grisClaro,
                              fontSize: 10,
                            ),
                          );
                        }

                        String formattedValue;
                        if (value >= 1000000) {
                          formattedValue =
                              '\$${(value / 1000000).toStringAsFixed(1)}M';
                        } else if (value >= 1000) {
                          formattedValue =
                              '\$${(value / 1000).toStringAsFixed(0)}K';
                        } else {
                          formattedValue = '\$${value.toStringAsFixed(0)}';
                        }
                        return Text(
                          formattedValue,
                          style: const TextStyle(
                            color: AppPalette.grisClaro,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: effectiveMaxY / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppPalette.cComponent3,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: AppPalette.cComponent3),
                    bottom: BorderSide(color: AppPalette.cComponent3),
                  ),
                ),
                groupsSpace: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppPalette.cText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}