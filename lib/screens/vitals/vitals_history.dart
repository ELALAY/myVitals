import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvitals/Components/myvital_card.dart';
import 'package:myvitals/services/realtime_db/firebase_db.dart';
import '../../Models/category_model.dart';
import '../../models/person_model.dart';
import '../../models/vital_model.dart';

class MyVitalsHistory extends StatefulWidget {
  final User user;
  final Person personProfile;
  const MyVitalsHistory(
      {super.key, required this.user, required this.personProfile});

  @override
  State<MyVitalsHistory> createState() => _MyVitalsHistoryState();
}

class _MyVitalsHistoryState extends State<MyVitalsHistory> {
  FirebaseDB fbdatabaseHelper = FirebaseDB();
  List<VitalsModel> vitals = [];
  List<VitalsModel> filteredVitals = [];
  Map<String, CategoryModel> userCategories = {}; // Category ID => Category
  bool isLoading = true;
  String selectedCategoryId = 'all'; // Default to 'all' for all vitals

  @override
  void initState() {
    super.initState();
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
        filteredVitals = vitals; // Initially show all vitals
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
          catMap[categoryId] = cat;
        }
      }
      setState(() {
        userCategories = catMap;
        debugPrint('user categories: ${userCategories.length.toString()}');
      });
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  void filterVitalsByCategory(String categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      if (categoryId == 'all') {
        // Show all vitals
        filteredVitals = vitals;
      } else {
        // Filter by selected category
        filteredVitals =
            vitals.where((vital) => vital.vitalCategory == categoryId).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History of Vitals'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            )
          : Column(
              children: [
                userCategories.keys.isNotEmpty ?
                // Horizontal List of Categories
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: userCategories.length + 1, // +1 for "All" option
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // First item is "All" button
                        return GestureDetector(
                          onTap: () => filterVitalsByCategory('all'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: selectedCategoryId == 'all'
                                  ? Colors.deepPurple
                                  : Colors.grey,
                            ),
                            child: const Center(
                              child: Text(
                                'All Vitals',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Other items are categories
                        String categoryId =
                            userCategories.keys.elementAt(index - 1);
                        CategoryModel category = userCategories[categoryId]!;

                        return GestureDetector(
                          onTap: () => filterVitalsByCategory(categoryId),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: selectedCategoryId == categoryId
                                  ? Colors.deepPurple
                                  : Colors.grey,
                            ),
                            child: Center(
                              child: Text(
                                category.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                )
                
                : const SizedBox(height: 20),

                // List of Vitals
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredVitals.length,
                    itemBuilder: (context, index) {
                      VitalsModel vital = filteredVitals[index];
                      return MyVitalCard(
                          id: vital.id,
                          user: vital.user,
                          vitalCategory: vital.vitalCategory,
                          value: vital.value.toString(),
                          date: vital.date,
                          color: Color(vital.color));
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
