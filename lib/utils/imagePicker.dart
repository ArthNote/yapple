import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(40),
        ),
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        onPressed: onClicked,
      );
}


class TitleWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  const TitleWidget({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, size: 100, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
}