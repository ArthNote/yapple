import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yapple/firebase/AuthService.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/barchart.dart';


class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final myAnnouncements = [
    Image.asset('assets/testforcarousel.png'),
    Image.asset('assets/yapple.png'),
    Image.asset('assets/yapple.png'),
  ];
  int myCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                height: 200,
                onPageChanged: (index, reason) {
                  setState(() {
                    myCurrentIndex = index;
                  });
                },
              ),
              items: myAnnouncements,
            ),
          ),
          Expanded(
            child: Center(
              child: RadialAnimatedMenu(controller: controller),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChartWidget(),
            ),
          ),
        ],
      ),
    );
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
