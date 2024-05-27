// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';
import 'package:yapple/firebase/AuthService.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yapple/firebase/ClassService.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/firebase/PaymentService.dart';
import 'package:yapple/pages/admin/addClass.dart';
import 'package:yapple/pages/admin/addParent.dart';
import 'package:yapple/pages/admin/addTeacher.dart';
import 'package:yapple/pages/admin/createStudentExcel.dart';
import 'package:yapple/pages/admin/viewFeedback.dart';
import 'package:yapple/widgets/Carousel.dart';
import '../../models/barchart.dart';
import 'package:d_chart/d_chart.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Stream<QuerySnapshot<Map<String, dynamic>>> streamChart;
  int unpaid = 0;
  int paid = 0;
  int modules = 0;
  int classes = 0;

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

    // Add a listener to the controller to rebuild the widget when the animation status changes
    controller.addListener(() {
      setState(() {});
    });
    getStats();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void getStats() async {
    int p = await PaymentService().getPaidPaymentsCount();
    int u = await PaymentService().getUnpaidPaymentsCount();
    int m = await ModuleService().getModulesCount();
    int c = await ClassService().getClassesCount();
    setState(() {
      paid = p;
      unpaid = u;
      modules = m;
      classes = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FabCircularMenuPlus(
        fabMargin: const EdgeInsets.all(0),
        ringDiameter: 500,
        alignment: Alignment.bottomRight,
        fabColor: Theme.of(context).colorScheme.primary,
        ringColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
        fabOpenIcon: Icon(Icons.menu,
            color: Theme.of(context).appBarTheme.backgroundColor),
        fabCloseIcon: Icon(Icons.close,
            color: Theme.of(context).appBarTheme.backgroundColor),
        children: [
          IconButton(
            icon: Icon(null),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Create Students',
            icon: Icon(
              Icons.face,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateStudentsExcel(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Create Classes',
            icon: Icon(
              Icons.class_,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddClass(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Create Parents',
            icon: Icon(
              Icons.family_restroom,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddParent(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Create Teachers',
            icon: Icon(
              Icons.badge,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTeacher(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'View Feedbacks',
            icon: Icon(
              Icons.help_center,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewFeedback(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 50,
                            child: Image.asset(
                              'assets/yapple.png',
                              color:
                                  Theme.of(context).appBarTheme.backgroundColor,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.logout),
                            color:
                                Theme.of(context).appBarTheme.backgroundColor,
                            iconSize: 30,
                            onPressed: () => AuthService().logout(context),
                          ),
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Hi, Administrator!',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        color: Theme.of(context).appBarTheme.backgroundColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Wrap(
              direction: Axis.horizontal,
              runSpacing: 20,
              spacing: 20,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width / 2.3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        paid.toString(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Completed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.6),
                        ),
                      ),
                      Text(
                        'Payments',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width / 2.3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        unpaid.toString(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Non-Completed Payments',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width / 2.3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        modules.toString(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Modules',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width / 2.3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        classes.toString(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Classes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 300, // Set a specific height for the BarChart
                child: BarChartWidget(),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: StreamBuilder(
            //     stream: streamChart,
            //     builder: (context,
            //         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
            //             snapshot) {
            //       if (snapshot.hasData) {
            //         return AspectRatio(
            //           aspectRatio: 16 / 9,
            //           child: DChartBarO(
            //             groupList: _buildOrdinalGroupList(snapshot),
            //           ),
            //         );
            //       } else {
            //         return CircularProgressIndicator(); // Or any other loading indicator
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  List<OrdinalGroup> _buildOrdinalGroupList(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    List<OrdinalData> ordinalList = snapshot.data!.docs.map((e) {
      return OrdinalData(
        domain: e.data()['major'] ??
            '', // Change 'date' to the field name in your Firebase document
        measure: e.data()['year'] ??
            0, // Change 'income' to the field name in your Firebase document
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
              itemsButton(-45, context,
                  color: Color(0xfff83f3f), icon: Icons.face),
              itemsButton(30, context,
                  color: Color(0xfff83f3f), icon: Icons.class_),
              itemsButton(100, context,
                  color: Color(0xfff83f3f), icon: Icons.family_restroom),
              itemsButton(-115, context,
                  color: Color(0xfff83f3f), icon: Icons.school),
              itemsButton(-185, context,
                  color: Color(0xfff83f3f), icon: Icons.badge),
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
                  child:
                      const Icon(Icons.add, size: 40, color: Color(0xfff83f3f)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget itemsButton(double angle, BuildContext context,
      {required Color color, required IconData icon}) {
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
          onPressed: () {},
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
