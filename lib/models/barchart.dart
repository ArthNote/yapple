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

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchChartData();
  }

  Future<List<BarChartGroupData>> fetchChartData() async {
    List<BarChartGroupData> barGroups = [];
    try {
      // Replace 'collectionName' and 'fieldY' with your Firestore collection and fields
      var snapshot = await FirebaseFirestore.instance.collection('teachers').get();
      int index = 0;
      for (var doc in snapshot.docs) {
        barGroups.add(BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: 10.01, // Replace with your field name
              color: Colors.blue,
            ),
          ],
        ));
        index++;
      }
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
        List<BarChartGroupData> datas = snapshot.data as List<BarChartGroupData>;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No data available');
        } else {
          return _buildChart(datas);
        }
      },
    );
  }

  Widget _buildChart(List<BarChartGroupData> data) {
    // Adjust the height of the BarChart by wrapping it with SizedBox
    return SizedBox(
      height: 300, // Set the desired height here
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: data,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              // Set the AxisTitle for the left axis to null
              sideTitles: SideTitles(showTitles: true),// Hide left axis titles
            ),
            rightTitles: AxisTitles(
              // Set the AxisTitle for the left axis to null
              sideTitles: SideTitles(showTitles: false),// Hide left axis titles
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(
            show: false, // Set to false to hide the axis lines
          ),
          gridData: FlGridData(
            show: false, // Set to false to hide the grid lines
          ),
        ),
      ),
    );
  }



}
