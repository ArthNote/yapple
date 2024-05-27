// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatefulWidget {
  BarChartWidget({Key? key}) : super(key: key);

  @override
  _BarChartWidgetState createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  late Future<List<BarChartGroupData>> _dataFuture;
  Map<String, int> majorCounts =
      {}; // Add a member variable to hold major counts

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchChartData();
  }

  Future<List<BarChartGroupData>> fetchChartData() async {
    List<BarChartGroupData> barGroups = [];
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('students').get();

      for (var doc in snapshot.docs) {
        if (majorCounts.containsKey('students')) {
          majorCounts['students'] = majorCounts['students']! + 1;
        } else {
          majorCounts['students'] = 1;
        }
      }

      var teachers =
          await FirebaseFirestore.instance.collection('teachers').get();
      for (var element in teachers.docs) {
        if (majorCounts.containsKey('teachers')) {
          majorCounts['teachers'] = majorCounts['teachers']! + 1;
        } else {
          majorCounts['teachers'] = 1;
        }
      }

      var parents =
          await FirebaseFirestore.instance.collection('parents').get();
      for (var element in parents.docs) {
        if (majorCounts.containsKey('parents')) {
          majorCounts['parents'] = majorCounts['parents']! + 1;
        } else {
          majorCounts['parents'] = 1;
        }
      }

      const colors = [];

      int index = 0;
      majorCounts.forEach((major, count) {
        barGroups.add(
          BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count.toDouble(),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                width: 60,
                borderRadius: BorderRadius.circular(4),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: count.toDouble() + 10,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        );
        index++;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BarChartGroupData>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No data available');
        } else {
          return _buildChart(snapshot.data!);
        }
      },
    );
  }

  Widget _buildChart(List<BarChartGroupData> data) {
    List<String> majors =
        majorCounts.keys.toList(); // Extract major names for labels
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: data,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 30),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  var style = TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  if (value.toInt() < 0 || value.toInt() >= majors.length) {
                    return SizedBox
                        .shrink(); // Return an empty widget if the index is out of bounds
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4,
                    child: Text(majors[value.toInt()], style: style),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          gridData: FlGridData(
            show: false,
          ),
        ),
      ),
    );
  }
}
