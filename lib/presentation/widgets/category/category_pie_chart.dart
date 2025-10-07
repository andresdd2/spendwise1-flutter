import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/domain/entity/totals_by_category.dart';
import 'package:spendwise_1/utils/formatters.dart';

class CategoryPieChart extends StatefulWidget {
  final List<TotalsByCategory> data;
  final bool showExpenses;

  const CategoryPieChart({
    super.key,
    required this.data,
    this.showExpenses = true,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  final List<Color> categoryColors = [
    const Color(0xFF288288),
    const Color(0xFFFF6B6B),
    const Color(0xFF4ECDC4),
    const Color(0xFFFFE66D),
    const Color(0xFFA8E6CF),
    const Color(0xFFFFD3B6),
    const Color(0xFFFFAAA5),
    const Color(0xFFB4A7D6),
    const Color(0xFF95E1D3),
    const Color(0xFFF38181),
  ];

  List<PieChartSectionData> _buildSections() {
    final filteredData = widget.data.where((item) {
      return widget.showExpenses ? item.totalExpense > 0 : item.totalIncome > 0;
    }).toList();

    if (filteredData.isEmpty) {
      return [];
    }

    final total = filteredData.fold<double>(
      0,
      (sum, item) =>
          sum + (widget.showExpenses ? item.totalExpense : item.totalIncome),
    );

    return filteredData.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final value = widget.showExpenses ? item.totalExpense : item.totalIncome;
      final percentage = (value / total * 100);
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 110.0 : 100.0;
      final fontSize = isTouched ? 16.0 : 14.0;

      return PieChartSectionData(
        color: categoryColors[index % categoryColors.length],
        value: value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppPalette.cComponent3,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  formatToCOP(value),
                  style: const TextStyle(
                    color: AppPalette.cText,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
            : null,
        badgePositionPercentageOffset: 1.3,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final sections = _buildSections();

    if (sections.isEmpty) {
      return Center(
        child: Text(
          'No hay datos para mostrar',
          style: TextStyle(color: AppPalette.cText, fontSize: 16),
        ),
      );
    }

    // Filtrar datos para la leyenda
    final filteredData = widget.data.where((item) {
      return widget.showExpenses ? item.totalExpense > 0 : item.totalIncome > 0;
    }).toList();

    return Column(
      children: [
        // Gráfico
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: sections,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Leyenda
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: filteredData.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildLegendItem(
              item.categoryName,
              categoryColors[index % categoryColors.length],
            );
          }).toList(),
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppPalette.cText,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}