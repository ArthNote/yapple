// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CreateStudentsExcel extends StatelessWidget {
  CreateStudentsExcel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Excel',
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? filePath;
  List<List<dynamic>> data = [];

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['csv'],
    );

    if (result == null) return;

    filePath = result.files.single.path!;
    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(CsvToListConverter())
        .toList();
    setState(() {
      data = fields;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => pickFile(),
          child: Text('Upload Excel'),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
              itemCount: data.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(3),
                  color: index == 0 ? Colors.amber : Colors.white,
                  child: ListTile(
                    leading: Text(
                      data[index][0].toString(),
                      textAlign: TextAlign.center,
                    ),
                    title: Text(
                      data[index][1].toString(),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      data[index][2].toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
