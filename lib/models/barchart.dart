// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key}) : super(key: key);

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
        String major = doc['major'];
        if (majorCounts.containsKey(major)) {
          majorCounts[major] = majorCounts[major]! + 1;
        } else {
          majorCounts[major] = 9;
        }
      }

      int index = 0;
      majorCounts.forEach((major, count) {
        barGroups.add(
          BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count.toDouble(),
                color: Colors.blue,
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
    return SizedBox(
      height: 400,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: data,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            rightTitles: AxisTitles(
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
                    child: Text(majors[value.toInt()], style: style),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
          ),
          gridData: FlGridData(
            show: false,
          ),
        ),
      ),
    );
  }
}
