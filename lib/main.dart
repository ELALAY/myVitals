import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myvitals/services/auth/auth_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.red, // Primary color
          primaryContainer: Colors.red.shade200, // A lighter variant of the primary color
          secondary: Colors.amber, // Secondary color
          background: Colors.white, // Background color
        ),
      ),
      home: const AuthChecker(),
    );
  }
}
