import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/finance_models.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1200;
    final isMediumScreen = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isWideScreen
            ? Column(
                children: [
                  const _GesamtUebersichtKarte(),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Einnahmen & Ausgaben',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              child: _BalkenDiagramm(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Verteilung der Ausgaben',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              child: _KreisDiagramm(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Monatliche Entwicklung',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: _LinienDiagramm(),
                  ),
                ],
              )
            : isMediumScreen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _GesamtUebersichtKarte(),
                                const SizedBox(height: 20),
                                const Text(
                                  'Einnahmen & Ausgaben',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 300,
                                  child: _BalkenDiagramm(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Verteilung der Ausgaben',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 300,
                                  child: _KreisDiagramm(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Monatliche Entwicklung',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300,
                        child: _LinienDiagramm(),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _GesamtUebersichtKarte(),
                      const SizedBox(height: 20),
                      const Text(
                        'Einnahmen & Ausgaben',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300,
                        child: _BalkenDiagramm(),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Verteilung der Ausgaben',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300,
                        child: _KreisDiagramm(),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Monatliche Entwicklung',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300,
                        child: _LinienDiagramm(),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _GesamtUebersichtKarte extends StatelessWidget {
  const _GesamtUebersichtKarte();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gesamtübersicht',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _UebersichtZeile(
              titel: 'Aktueller Kontostand',
              betrag: 5000.0,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            _UebersichtZeile(
              titel: 'Offene Ratenzahlungen',
              betrag: -1200.0,
              color: Colors.orange,
            ),
            const SizedBox(height: 10),
            _UebersichtZeile(
              titel: 'Gesamte Schulden',
              betrag: -15000.0,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class _UebersichtZeile extends StatelessWidget {
  final String titel;
  final double betrag;
  final Color color;

  const _UebersichtZeile({
    required this.titel,
    required this.betrag,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titel),
        Text(
          '${betrag.toStringAsFixed(2)} €',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _BalkenDiagramm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 2000,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const titles = ['Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun'];
                if (value.toInt() >= 0 && value.toInt() < titles.length) {
                  return Text(titles[value.toInt()]);
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          _createBarGroup(0, 1500, 1200),
          _createBarGroup(1, 1800, 1400),
          _createBarGroup(2, 1600, 1300),
          _createBarGroup(3, 1900, 1600),
          _createBarGroup(4, 1700, 1500),
          _createBarGroup(5, 2000, 1700),
        ],
      ),
    );
  }

  BarChartGroupData _createBarGroup(int x, double einnahmen, double ausgaben) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: einnahmen,
          color: Colors.green,
          width: 12,
        ),
        BarChartRodData(
          toY: ausgaben,
          color: Colors.red,
          width: 12,
        ),
      ],
    );
  }
}

class _KreisDiagramm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 35,
            title: 'Miete',
            color: Colors.blue,
            radius: 100,
          ),
          PieChartSectionData(
            value: 25,
            title: 'Essen',
            color: Colors.red,
            radius: 100,
          ),
          PieChartSectionData(
            value: 20,
            title: 'Transport',
            color: Colors.green,
            radius: 100,
          ),
          PieChartSectionData(
            value: 20,
            title: 'Sonstiges',
            color: Colors.yellow,
            radius: 100,
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}

class _LinienDiagramm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const titles = ['Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun'];
                if (value.toInt() >= 0 && value.toInt() < titles.length) {
                  return Text(titles[value.toInt()]);
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 1500),
              const FlSpot(1, 1800),
              const FlSpot(2, 1600),
              const FlSpot(3, 1900),
              const FlSpot(4, 1700),
              const FlSpot(5, 2000),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
