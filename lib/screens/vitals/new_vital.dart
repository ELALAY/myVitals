import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:myvitals/Components/my_buttons/my_button.dart';
import 'package:myvitals/Components/my_textfields/my_numberfield.dart';
import 'package:myvitals/models/person_model.dart';
import 'package:myvitals/services/realtime_db/firebase_db.dart';
import '../../Models/category_model.dart';
import '../../models/vital_model.dart';

class NewVital extends StatefulWidget {
  final Person personProfile;
  const NewVital({super.key, required this.personProfile});

  @override
  State<NewVital> createState() => _NewVitalState();
}

class _NewVitalState extends State<NewVital> {
  FirebaseDB firebaseDB = FirebaseDB();
  final TextEditingController vitalReadingController = TextEditingController();
  List<CategoryModel> categories = [];
  String selectedCategory = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories when the widget initializes
  }

  void fetchCategories() async {
    setState(() {
      isLoading = true; // Set loading state to true while fetching
    });

    try {
      List<CategoryModel> cats = [];
      for (String catId in widget.personProfile.categories) {
        CategoryModel? category = await firebaseDB.fetchCategoryById(catId);
        if (category != null) {
          cats.add(category);
        }
      }
      setState(() {
        categories = cats;
        isLoading = false; // Set loading state to false once fetching is done
      });
    } catch (e) {
      debugPrint('No categories fetched! $e');
      setState(() {
        isLoading = false; // Set loading state to false on error
      });
    }
  }

  void saveVital() async {
    try {
      if (selectedCategory.isNotEmpty &&
          vitalReadingController.text.isNotEmpty) {
        VitalsModel vital = VitalsModel(
          selectedCategory,
          double.parse(vitalReadingController.text),
          widget.personProfile.id,
          DateTime.now(),
        );
        await firebaseDB.recordNewVital(vital);
        showSuccessSnackBar('Vital reading saved successfully!');
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        showInfoSnackBar('Choose a category and enter a reading!');
      }
    } catch (e) {
      debugPrint('Error Creating Vital! $e');
      showErrorSnackBar('Error saving reading!');
    }
  }

  void showErrorSnackBar(String message) {
    awesomeTopSnackbar(
      context,
      message,
      iconWithDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        color: Colors.amber.shade400,
      ),
      backgroundColor: Colors.amber,
      icon: const Icon(
        Icons.close,
        color: Colors.white,
      ),
    );
  }

  void showInfoSnackBar(String message) {
    awesomeTopSnackbar(
      context,
      message,
      iconWithDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        color: Colors.lightBlueAccent.shade400,
      ),
      backgroundColor: Colors.lightBlueAccent,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    awesomeTopSnackbar(
      context,
      message,
      iconWithDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        color: Colors.green.shade400,
      ),
      backgroundColor: Colors.green,
      icon: const Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record New Vital'),
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
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                        height: 300,
                        child: Image.asset('lib/images/vitals_history.gif'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Choice of category of vital
                    DropdownButton<String>(
                      // dropdownColor: Colors.deepPurple,
                      focusColor: Colors.deepPurple,
                      iconEnabledColor: Colors.deepPurple,
                      hint: const Text('Select a Vital'),
                      borderRadius: BorderRadius.circular(12),
                      value: selectedCategory.isEmpty ? null : selectedCategory,
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    // Value
                    MyNumberField(
                      controller: vitalReadingController,
                      label: 'New Reading',
                      color: Colors.deepPurple,
                      enabled: true,
                    ),
                    const SizedBox(height: 30),
                    MyButton(
                      label: 'Save',
                      onTap: saveVital,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
