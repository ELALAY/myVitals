import 'package:flutter/material.dart';

class MyVitalCard extends StatefulWidget {
  final String id;
  final String user;
  final String vitalCategory;
  final String value;
  final DateTime date;
  final Color color;

  const MyVitalCard(
      {super.key,
      required this.id,
      required this.user,
      required this.vitalCategory,
      required this.value,
      required this.date,
      required this.color});

  @override
  State<MyVitalCard> createState() => _MyVitalCardState();
}

class _MyVitalCardState extends State<MyVitalCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80.0,
        width: 400.0,
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade500, borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.vitalCategory,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.value.toString(),
                style:
                    TextStyle(color: widget.color, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
