import 'package:flutter/material.dart';
import 'package:myvitals/screens/home.dart';
import 'package:myvitals/services/auth/auth_checker.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.amber,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Take Good Care of YouSELF!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  shadows: [
                    Shadow(
                        color: Colors.grey,
                        offset: Offset(2, 2),
                        blurRadius: 0.5)
                  ]),
            ),
            const SizedBox(
              height: 100.0,
            ),
            Image.asset(
                'lib/images/app_icon.png',
                height: 100.0, // Set the desired height
                width: 100.0, // Set the desired width
              ),
            const SizedBox(
              height: 100.0,
            ),
            GestureDetector(
              onTap: navHomeScreen,
              child: Container(
                height: 50.0,
                width: 250,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(2, 2),
                        blurRadius: 0.5)
                  ],
                  color: Colors.amber.shade800,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void navHomeScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const AuthChecker(); // replace with your settings screen
    }));
  }
}
