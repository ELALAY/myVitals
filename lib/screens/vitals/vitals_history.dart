import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvitals/services/realtime_db/firebase_db.dart';

import '../../Components/myvital_card.dart';
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
  Map<String, CategoryModel> userCategories = {}; // Category ID => Category
  bool isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('History of Vital'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
              itemCount: vitals.length,
              itemBuilder: (context, index) {
                VitalsModel vital = vitals[index];
                return MyVitalCard(
                    vital: vital,
                    color: Colors.green);
              }),
            ),
          ],
        ));
  }
}
