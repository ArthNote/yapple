import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:yapple/firebase/EventService.dart';
import 'package:yapple/models/eventModel.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int myCurrentIndex = 0;
  final myAnnouncements = [
    'assets/ann_marketing.png',
    'assets/ann_marketing.png',
    'assets/ann_marketing.png',
  ];

  List<eventModel> events = [];

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  void getEvents() async {
    var e = await EventService().getLatestEvents();
    setState(() {
      events.addAll(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        height: 200,
        viewportFraction: 0.9,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          setState(() {
            myCurrentIndex = index;
          });
        },
      ),
      items: events.map((event) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: SizedBox(
            width: double.infinity,
            height: 200.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                event.imageUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
