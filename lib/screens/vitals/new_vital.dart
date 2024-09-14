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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // choice of category of vital

            // value

            // show max and min value of the vategory

            // 
          ],
        ),
      ),
    );
  }
}
