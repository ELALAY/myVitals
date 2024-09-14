import 'package:flutter/material.dart';
import 'package:myvitals/models/vital_model.dart';

class MyVitalCard extends StatefulWidget {
  final VitalsModel vital;
  final Color color;
  const MyVitalCard(
      {super.key,
      required this.vital,
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
            color: Colors.pink, borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.vital.vitalCategory,
                style: const TextStyle(color: Colors.black),
              ),
              Text(
                widget.vital.value.toString(),
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
