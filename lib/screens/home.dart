import 'package:flutter/material.dart';
import 'package:myvitals/Components/myvital_card.dart';

import '../Components/mynavbar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vitals'),
        backgroundColor: Colors.deepPurple,
        elevation: 0.0,
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyVitalCard(
            vital: 'Blood Sugar',
            level: '0.97g',
            color: Colors.tealAccent,
          ),
          MyVitalCard(
            vital: 'Cortisol',
            level: '2g',
            color: Colors.amber,
          ),
          MyVitalCard(
            vital: 'Temperature',
            level: '38',
            color: Colors.red,
          ),
        ],
      ),
      // bottomNavigationBar: const MyNavBar(),
    );
  }
}
