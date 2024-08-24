import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myvitals/screens/get_started.dart';

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
          primary: Colors.amber, // Primary color
          primaryContainer: Colors.amber.shade200, // A lighter variant of the primary color
          secondary: Colors.red, // Secondary color
          secondaryContainer: Colors.red.shade200, // A lighter variant of the secondary color
          background: Colors.white, // Background color
          surface: Colors.amber.shade50, // A light color for surfaces
          onPrimary: Colors.white, // Text color on primary
          onSecondary: Colors.white, // Text color on secondary
          onBackground: Colors.black, // Text color on background
          onSurface: Colors.black, // Text color on surfaces
        ),
        // Optional: Additional theming
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amber, // AppBar color
          iconTheme: IconThemeData(color: Colors.white), // AppBar icon color
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.amber, // Button color
          textTheme: ButtonTextTheme.primary, // Text color on buttons
        ),
      ),
      home: const GetStarted(),
    );
  }
}
