import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvitals/Components/myvital_card.dart';

import '../services/auth/auth_service.dart';
import '../services/auth/login_register_screen.dart';
import '../services/realtime_db/firebase_db.dart';

class MyHomePage extends StatefulWidget {
  final User user;
  const MyHomePage({super.key, required this.user});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseDB fbdatabaseHelper = FirebaseDB();
  AuthService authService = AuthService();

  void logout() async {
    try {
      await authService.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginOrRegister()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Logout Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vitals'),
        backgroundColor: Colors.deepPurple,
        elevation: 0.0,
        actions: [IconButton(onPressed: logout, icon: const Icon(Icons.logout_outlined))],
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
