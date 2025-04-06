import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  String _selectedFilter = '7D';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(
            title: 'Thống kê',
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTitle(),
                    const SizedBox(height: 24),
                    _buildChart(),
                    const SizedBox(height: 24),
                    _buildTimeFilter(),
                    const SizedBox(height: 24),
                    _buildLegend(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Thống kê doanh thu',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      textAlign: TextAlign.center,
    );
  }

  List<FlSpot> _getRevenueSpots() {
    switch (_selectedFilter) {
      case '7D':
        return [
          const FlSpot(0, 1.5),
          const FlSpot(1, 2.0),
          const FlSpot(2, 1.8),
          const FlSpot(3, 2.5),
          const FlSpot(4, 2.2),
          const FlSpot(5, 3.0),
          const FlSpot(6, 2.8),
        ];
      case '1M':
        return [
          const FlSpot(0, 1.0),
          const FlSpot(7, 1.8),
          const FlSpot(14, 2.3),
          const FlSpot(21, 2.7),
          const FlSpot(28, 3.2),
        ];
      case '1Y':
        return [
          const FlSpot(0, 1.5),
          const FlSpot(2, 2.5),
          const FlSpot(4, 2.0),
          const FlSpot(6, 3.0),
          const FlSpot(8, 2.8),
          const FlSpot(10, 3.5),
          const FlSpot(12, 4.0),
        ];
      default:
        return [];
    }
  }

  List<FlSpot> _getCostSpots() {
    switch (_selectedFilter) {
      case '7D':
        return [
          const FlSpot(0, 1.0),
          const FlSpot(1, 1.2),
          const FlSpot(2, 1.1),
          const FlSpot(3, 1.4),
          const FlSpot(4, 1.3),
          const FlSpot(5, 1.6),
          const FlSpot(6, 1.5),
        ];
      case '1M':
        return [
          const FlSpot(0, 0.8),
          const FlSpot(7, 1.2),
          const FlSpot(14, 1.5),
          const FlSpot(21, 1.7),
          const FlSpot(28, 2.0),
        ];
      case '1Y':
        return [
          const FlSpot(0, 1.0),
          const FlSpot(2, 1.5),
          const FlSpot(4, 1.3),
          const FlSpot(6, 1.8),
          const FlSpot(8, 1.6),
          const FlSpot(10, 2.0),
          const FlSpot(12, 2.2),
        ];
      default:
        return [];
    }
  }

  Widget _buildChart() {
    double maxX = _selectedFilter == '7D' ? 6 : _selectedFilter == '1M' ? 28 : 12;
    double interval = _selectedFilter == '7D' ? 1 : _selectedFilter == '1M' ? 7 : 2;

    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 16), // Chỉ để padding bên phải
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(
              show: true,
              
              drawVerticalLine: false,
              horizontalInterval: 1,
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 28, // Giảm kích thước
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: interval,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    String text;
                    if (_selectedFilter == '1M') {
                      text = '${value.toInt()}d';
                    } else if (_selectedFilter == '1Y') {
                      text = 'T${value.toInt() + 1}';
                    } else {
                      text = '${value.toInt() + 1}';
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
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
            lineTouchData: LineTouchData(
              touchTooltipData: const LineTouchTooltipData(
                tooltipBgColor: Colors.blueAccent,
                tooltipRoundedRadius: 8,
                showOnTopOfTheChartBoxArea: true,
              ),
              touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
              handleBuiltInTouches: true,
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            minX: 0,
            maxX: maxX,
            minY: 0,
            maxY: _selectedFilter == '1Y' ? 5 : 4,
            lineBarsData: [
              _createLineChartBarData(
                spots: _getRevenueSpots(),
                color: Colors.green,
              ),
              _createLineChartBarData(
                spots: _getCostSpots(),
                color: Colors.purple,
              ),
            ],
            baselineY: 0,
            clipData: const FlClipData.all(),
          ),
        ),
      ),
    );
  }

  LineChartBarData _createLineChartBarData({
    required List<FlSpot> spots,
    required Color color,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: _selectedFilter != '7D',
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: color,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.1),
      ),
    );
  }

  Widget _buildTimeFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilterOption('7D', isSelected: _selectedFilter == '7D', onTap: () {
            setState(() {
              _selectedFilter = '7D';
            });
          }),
          const SizedBox(width: 16),
          _buildFilterOption('1M', isSelected: _selectedFilter == '1M', onTap: () {
            setState(() {
              _selectedFilter = '1M';
            });
          }),
          const SizedBox(width: 16),
          _buildFilterOption('1Y', isSelected: _selectedFilter == '1Y', onTap: () {
            setState(() {
              _selectedFilter = '1Y';
            });
          }),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String text, {bool isSelected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Doanh thu', Colors.green),
        const SizedBox(width: 24),
        _buildLegendItem('Chi phí', Colors.purple),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}