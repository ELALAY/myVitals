import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvitals/Components/my_drawer.dart';
import 'package:myvitals/Models/category_model.dart';
import 'package:myvitals/models/vital_model.dart';
import 'package:myvitals/screens/vitals/new_vital.dart';
import 'package:myvitals/screens/vitals/vitals_history.dart';
import '../models/person_model.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/login_register_screen.dart';
import '../services/realtime_db/firebase_db.dart';
                        
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseDB firebaseDatabasehelper = FirebaseDB();
  AuthService authService = AuthService();
  List<VitalsModel> vitals = [];
  Map<String, CategoryModel> userCategories = {}; // Category ID => Category
  int _selectedBarIndex = 0;
  bool isLoading = true;
  User? user;
  Person? personProfile;

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
      // Fetch the user
      User? userTemp = authService.getCurrentUser();
      if (userTemp != null) {
        debugPrint('got user: ${userTemp.email}');
        // Fetch user profile
        Person? personProfileTemp =
            await firebaseDatabasehelper.getPersonProfile(userTemp.uid);
        personProfileTemp != null
            ? debugPrint('got user: ${personProfileTemp.email}')
            : debugPrint('no user profile');
        setState(() {
          user = userTemp;
          personProfile = personProfileTemp;
        });
      }

      List<VitalsModel> vitalsTemp =
          await firebaseDatabasehelper.fetchUserVital(user!.uid);
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
      for (String categoryId in personProfile!.categories) {
        CategoryModel? cat =
            await firebaseDatabasehelper.fetchCategoryById(categoryId);
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
      _selectedBarIndex = index;
    });
    // Navigate based on selected index
    if (_selectedBarIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else if (_selectedBarIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyVitalsHistory(
                  user: user!,
                  personProfile: personProfile!,
                )),
      );
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
      drawer: user != null && personProfile != null
          ? MyDrawer(user: user!, personProfile: personProfile!)
          : null,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const SizedBox(
              height: 500.0,
              child: Text('Vitals'),
              
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: navNewVital,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBarIndex,
        selectedItemColor: Colors.pink,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
              ),
              label: 'History'),
        ],
        onTap: _onTabSelected,
      ),
    );
  }

  void navNewVital() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewVital(
          personProfile: personProfile!,
        ),
      ),
    );
  }
}
