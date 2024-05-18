import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yapple/firebase/AuthService.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/barchart.dart';
import 'package:d_chart/d_chart.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final myAnnouncements = [
    'assets/ann_gaming.png',
    'assets/test.png',
    'assets/ann_marketing.png',
  ];
  int myCurrentIndex = 0;

  late Stream<QuerySnapshot<Map<String, dynamic>>> streamChart;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    streamChart = FirebaseFirestore.instance
        .collection('classes')
        .snapshots(includeMetadataChanges: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => AuthService().logout(context),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  height: 200,
                  viewportFraction: 0.8, // Increase the fraction to zoom in
                  enlargeCenterPage: true, // This will enlarge the center item
                  onPageChanged: (index, reason) {
                    setState(() {
                      myCurrentIndex = index;
                    });
                  },
                ),
                items: myAnnouncements.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust the horizontal padding for spacing
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        item,
                        fit: BoxFit.cover, // Ensures the image covers the space
                      ),
                    ),
                  );
                }).toList(),
              ),
            SizedBox(
              height: 400, // Set a specific height for the RadialAnimatedMenu
              child: Center(
                child: RadialAnimatedMenu(controller: controller),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 300, // Set a specific height for the BarChart
                child: BarChartWidget(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                stream: streamChart,
                builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: DChartBarO(
                        groupList: _buildOrdinalGroupList(snapshot),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator(); // Or any other loading indicator
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<OrdinalGroup> _buildOrdinalGroupList(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    List<OrdinalData> ordinalList = snapshot.data!.docs.map((e) {
      return OrdinalData(
        domain: e.data()['major'] ?? '', // Change 'date' to the field name in your Firebase document
        measure: e.data()['year'] ?? 0, // Change 'income' to the field name in your Firebase document
      );
    }).toList();

    final ordinalGroup = [
      OrdinalGroup(
        id: '1',
        data: ordinalList,
      ),
    ];

    return ordinalGroup;
  }
}

class RadialAnimatedMenu extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> translate;
  final Animation<double> rotate;
  final Animation<double> itemScale;

  RadialAnimatedMenu({super.key, required this.controller})
      : scale = Tween<double>(begin: 2, end: 0.0).animate(
    CurvedAnimation(parent: controller, curve: Curves.linear),
  ),
        translate = Tween<double>(begin: 0.0, end: 120.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.slowMiddle),
        ),
        rotate = Tween<double>(begin: 0.0, end: 2 * pi).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeInOut),
        ),
        itemScale = Tween<double>(begin: 1.0, end: 1.4).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeInOut),
        );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: rotate.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              itemsButton(-45, color: Color(0xfff83f3f), icon: Icons.face),
              itemsButton(30, color: Color(0xfff83f3f), icon: Icons.class_),
              itemsButton(100, color: Color(0xfff83f3f), icon: Icons.family_restroom),
              itemsButton(-115, color: Color(0xfff83f3f), icon: Icons.school),
              itemsButton(-185, color: Color(0xfff83f3f), icon: Icons.badge),
              Transform.scale(
                scale: scale.value - 1.3,
                child: FloatingActionButton(
                  onPressed: close,
                  backgroundColor: Color(0xfffed3d3),
                  child: Icon(Icons.add, color: Color(0xfff83f3f)),
                ),
              ),
              Transform.scale(
                scale: scale.value,
                child: FloatingActionButton(
                  onPressed: open,
                  backgroundColor: Color(0xfffed3d3),
                  child: const Icon(Icons.add, size: 40, color: Color(0xfff83f3f)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget itemsButton(double angle, {required Color color, required IconData icon}) {
    final double rad = radians(angle);
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          translate.value * cos(rad),
          translate.value * sin(rad),
        ),
      child: Transform.scale(
        scale: itemScale.value,
        child: FloatingActionButton(
          onPressed: close,
          backgroundColor: color,
          child: Icon(icon),
        ),
      ),
    );
  }

  void open() {
    controller.forward();
  }

  void close() {
    controller.reverse();
  }
}
