import 'package:flutter/material.dart';

class NewVital extends StatefulWidget {
  const NewVital({super.key});

  @override
  State<NewVital> createState() => _NewVitalState();
}

class _NewVitalState extends State<NewVital> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record New Vital'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
    );
  }
}
