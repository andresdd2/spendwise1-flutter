import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/domain/entity/dailay_totals.dart';
import 'package:spendwise_1/utils/formatters.dart';

class DailyLineChart extends StatefulWidget {
  final List<DailyTotals> data;

  const DailyLineChart({super.key, required this.data});

  @override
  State<DailyLineChart> createState() => _DailyLineChartState();
}

class _DailyLineChartState extends State<DailyLineChart> {
  bool showIncome = true;
  bool showExpense = true;

  List<FlSpot> _getIncomeSpots() {
    return widget.data
        .asMap()
        .entries
        .where((entry) => entry.value.income > 0)
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.income))
        .toList();
  }

  List<FlSpot> _getExpenseSpots() {
    return widget.data
        .asMap()
        .entries
        .where((entry) => entry.value.expense > 0)
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.expense))
        .toList();
  }

  double _getMaxY() {
    double maxValue = 0;
    for (var item in widget.data) {
      if (item.income > maxValue) maxValue = item.income;
      if (item.expense > maxValue) maxValue = item.expense;
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

    final maxY = _getMaxY();
    final incomeSpots = _getIncomeSpots();
    final expenseSpots = _getExpenseSpots();

    return Column(
      children: [
        // Controles de visibilidad
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildToggleButton(
                'Ingresos',
                AppPalette.cAccent,
                showIncome,
                () => setState(() => showIncome = !showIncome),
              ),
              const SizedBox(width: 16),
              _buildToggleButton(
                'Gastos',
                Colors.redAccent,
                showExpense,
                () => setState(() => showExpense = !showExpense),
              ),
            ],
          ),
        ),

        // Gráfico
        SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, top: 16),
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: widget.data.length > 1
                    ? widget.data.length.toDouble() - 1
                    : 30,
                minY: 0,
                maxY: maxY > 0 ? maxY : 100000,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => AppPalette.cComponent,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        if (index < 0 || index >= widget.data.length) {
                          return null;
                        }
                        final day = widget.data[index].day;
                        final value = spot.y;
                        final isIncome = spot.barIndex == 0;
                        final label = isIncome ? 'Ingresos' : 'Gastos';
                        final color = isIncome
                            ? AppPalette.cAccent
                            : Colors.redAccent;

                        return LineTooltipItem(
                          'Día $day\n$label: ${formatToCOP(value)}',
                          TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchLineStart: (data, index) => 0,
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: maxY > 0 ? maxY / 5 : 20000,
                  verticalInterval: widget.data.length > 6
                      ? widget.data.length / 6
                      : 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppPalette.cComponent3.withAlpha(3),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: AppPalette.cComponent3.withAlpha(2),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: widget.data.length > 6
                          ? widget.data.length / 6
                          : 5,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < widget.data.length) {
                          final day = widget.data[value.toInt()].day;
                          if (value.toInt() % 5 == 0 || value.toInt() == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                day.toString(),
                                style: const TextStyle(
                                  color: AppPalette.grisClaro,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      interval: maxY > 0 ? maxY / 5 : 20000,
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
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Línea de Ingresos
                  if (showIncome && incomeSpots.isNotEmpty)
                    LineChartBarData(
                      spots: incomeSpots,
                      isCurved: true,
                      curveSmoothness: 0.4,
                      color: AppPalette.cAccent,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppPalette.cAccent.withAlpha(4),
                            AppPalette.cAccent.withAlpha(1),
                            AppPalette.cAccent.withAlpha(0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  // Línea de Gastos
                  if (showExpense && expenseSpots.isNotEmpty)
                    LineChartBarData(
                      spots: expenseSpots,
                      isCurved: true,
                      curveSmoothness: 0.4,
                      color: Colors.redAccent,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.redAccent.withAlpha(4),
                            Colors.redAccent.withAlpha(1),
                            Colors.redAccent.withAlpha(0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        if (incomeSpots.isEmpty && expenseSpots.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No hay movimientos registrados en este mes',
              style: TextStyle(color: AppPalette.grisClaro, fontSize: 14),
            ),
          ),
      ],
    );
  }

  Widget _buildToggleButton(
    String label,
    Color color,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color.withAlpha(2) : AppPalette.cComponent3,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : AppPalette.grisClaro.withAlpha(3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isActive ? color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? color : AppPalette.grisClaro,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}