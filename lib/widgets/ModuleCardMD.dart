import 'package:flutter/material.dart';

class ModuleCardMD extends StatefulWidget {
  ModuleCardMD({super.key, required this.isStarred});
  bool isStarred;

  @override
  State<ModuleCardMD> createState() => _ModuleCardMDState();
}

class _ModuleCardMDState extends State<ModuleCardMD> {
  @override
  Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
    return Container(
      height: 200,
      width: size.width * 0.42,
      decoration: BoxDecoration(
        color: Colors.red.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.code),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isStarred = !widget.isStarred;
                  });
                },
                child: Icon(
                  widget.isStarred ? Icons.star : Icons.star_outline,
                  color: Colors.yellow.shade700,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
