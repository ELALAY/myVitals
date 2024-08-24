import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class MyNavBar extends StatefulWidget {
  const MyNavBar({super.key});

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  @override
  Widget build(BuildContext context) {
    return const GNav(
        activeColor: Colors.deepPurple,
        gap: 12.0,
        tabBackgroundColor: Color.fromARGB(255, 230, 230, 230),
        padding: EdgeInsets.all(12.0),
        tabs: [
        GButton(
          icon: LineIcons.home,
          text: 'Home',
        ),
        GButton(
          icon: LineIcons.history,
          text: 'History',
        ),
        GButton(
          icon: LineIcons.barChart,
          text: 'Insights',
        ),
        GButton(
          icon: LineIcons.user,
          text: 'Profile',
        )
      ]);
  }
}