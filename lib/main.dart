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
          secondaryContainer: Colors.amber.shade200, // A lighter variant of the secondary color
          background: Colors.white, // Background color
          surface: Colors.red.shade50, // A light color for surfaces
          onPrimary: Colors.white, // Text color on primary
          onSecondary: Colors.white, // Text color on secondary
          onBackground: Colors.black, // Text color on background
          onSurface: Colors.black, // Text color on surfaces
        ),
        // Optional: Additional theming
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red, // AppBar color
          iconTheme: IconThemeData(color: Colors.white), // AppBar icon color
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.red, // Button color
          textTheme: ButtonTextTheme.primary, // Text color on buttons
        ),
      ),
      home: const AuthChecker(),
    );
  }
}
