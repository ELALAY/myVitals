import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
// import 'package:myvitals/Components/my_drawer.dart';
import '../Components/myvital_card.dart';
import '../models/person_model.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/login_register_screen.dart';
import '../services/realtime_db/firebase_db.dart';
import 'Profile/profile_screen.dart';
import 'onboarding/onboarding_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseDB fbdatabaseHelper = FirebaseDB();
  AuthService authService = AuthService();
  int _selectedIndex = 0;
  bool isLoading = true;

  User? user;
  Person? personProfile;

  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  void fetchUser() async {
    try {
      User? userTemp = authService.getCurrentUser();
      Person? person = await fbdatabaseHelper.getPersonProfile(userTemp!.uid);

      setState(() {
        user = userTemp;
        personProfile = person;
        isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      debugPrint('Error fetching user $e');
      setState(() {
        isLoading = false; // Set loading to false even if there's an error
      });
    }
  }

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

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on selected index
    switch (index) {
      // case 1:
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => const HistoryScreen()),
      //   );
      //   break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
        break;
      case 3:
        if (user != null && personProfile != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                user: user!,
                personProfile: personProfile!,
              ),
            ),
          );
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vitals'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0.0,
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout_outlined))
        ],
      ),
      //  drawer: MyDrawer(user: user!, personProfile: personProfile!),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                // Blood Sugar
                MyVitalCard(
                  vital: 'Blood Sugar',
                  level: '0.97g',
                  color: Colors.tealAccent,
                ),
                // Cortisol
                MyVitalCard(
                  vital: 'Cortisol',
                  level: '2g',
                  color: Colors.amber,
                ),
                // Temperature
                MyVitalCard(
                  vital: 'Temperature',
                  level: '38',
                  color: Colors.red,
                ),
              ],
            ),
      bottomNavigationBar: GNav(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabSelected,
        activeColor: Colors.red,
        gap: 12.0,
        tabBackgroundColor: const Color.fromARGB(255, 230, 230, 230),
        padding: const EdgeInsets.all(12.0),
        tabs: const [
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
        ],
      ),
    );
  }
}
