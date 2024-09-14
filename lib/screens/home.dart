import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:myvitals/Models/category_model.dart';
import 'package:myvitals/models/vital_model.dart';
import 'package:myvitals/screens/vitals/new_vital.dart';
import 'package:myvitals/screens/vitals/vitals_history.dart';
// import 'package:myvitals/Components/my_drawer.dart';
import '../Components/myvital_card.dart';
import '../models/person_model.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/login_register_screen.dart';
import '../services/realtime_db/firebase_db.dart';
import 'Profile/profile_screen.dart';
import 'onboarding/onboarding_screen.dart';

class MyHomePage extends StatefulWidget {
  final Person personProfile;
  final User user;
  const MyHomePage(
      {super.key, required this.user, required this.personProfile});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseDB fbdatabaseHelper = FirebaseDB();
  AuthService authService = AuthService();
  List<VitalsModel> vitals = [];
  Map<String, CategoryModel> userCategories = {}; // Category ID => Category
  int _selectedIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserVitals();
    fetchCategories();
    isLoading = false;
  }

  void reload() {
    isLoading = true;
    fetchUserVitals();
    fetchCategories();
    isLoading = false;
  }

  void fetchUserVitals() async {
    try {
      List<VitalsModel> vitalsTemp =
          await fbdatabaseHelper.fetchUserVital(widget.user.uid);
      setState(() {
        vitals = vitalsTemp;
        debugPrint('user vitals: ${vitals.length.toString()}');
      });
    } catch (e) {
      debugPrint('Error fetching user vitals: $e');
    }
  }

  void fetchCategories() async {
    try {
      Map<String, CategoryModel> catMap = {}; // Category ID => Category
      for (String categoryId in widget.personProfile.categories) {
        CategoryModel? cat =
            await fbdatabaseHelper.fetchCategoryById(categoryId);
        if (cat != null) {
          catMap[categoryId] = cat; // Fixed: use categoryId as key
        }

        setState(() {
          userCategories = catMap;
          debugPrint('user categories: ${userCategories.length.toString()}');
        });
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
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
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyVitalsHistory(
                    user: widget.user,
                    personProfile: widget.personProfile,
                  )),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OnboardingScreen(
                    user: widget.user,
                  )),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              user: widget.user,
              personProfile: widget.personProfile,
            ),
          ),
        );
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
          IconButton(
              onPressed: logout, icon: const Icon(Icons.logout_outlined)),
          IconButton(
              onPressed: reload, icon: const Icon(Icons.refresh_outlined)),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: vitals.length,
                      itemBuilder: (context, index) {
                        VitalsModel vital = vitals[index];
                        return MyVitalCard(
                            vital: vital,
                            color: Colors.green);
                      }),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: navNewVital,
        child: const Icon(Icons.add),
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

  void navNewVital() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewVital(
          personProfile: widget.personProfile,
        ),
      ),
    );
  }
}
