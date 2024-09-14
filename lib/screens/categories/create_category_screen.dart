import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:myvitals/Components/my_textfields/my_numberfield.dart';

import '../../Components/my_buttons/my_button.dart';
import '../../Components/my_textfields/my_textfield.dart';
import '../../Models/category_model.dart';
import '../../services/realtime_db/firebase_db.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({super.key});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  FirebaseDB firebaseDatabasehelper = FirebaseDB();
  final TextEditingController newCategoryController = TextEditingController();
  final TextEditingController minValueController = TextEditingController();
  final TextEditingController maxValueController = TextEditingController();
  // String _selectedIcon = 'app_icon';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Category'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 30,
          ),
          const Icon(
            Icons.category_outlined,
            size: 100,
            color: Colors.pink,
          ),
          const SizedBox(
            height: 30,
          ),
          // Category Name
          SizedBox(
            width: 365.0,
            child: MyTextField(
                controller: newCategoryController,
                label: 'Category Name',
                color: Colors.deepPurple,
                enabled: true),
          ),
          const SizedBox(
            height: 12,
          ),
          // Category Min Value
          SizedBox(
            width: 365.0,
            child: MyNumberField(
                controller: minValueController,
                label: 'Min Value',
                color: Colors.deepPurple,
                enabled: true),
          ),
          const SizedBox(
            height: 12,
          ),
          // Category Max Value
          SizedBox(
            width: 365.0,
            child: MyNumberField(
                controller: maxValueController,
                label: 'Max Value',
                color: Colors.deepPurple,
                enabled: true),
          ),
          const SizedBox(
            height: 30,
          ),
          // Container(
          //   height: 300.0,
          //   width: 350.0,
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade100,
          //     borderRadius: BorderRadius.circular(12.0),
          //     border: Border.all(color: Colors.deepPurple),
          //   ),
          //   child: GridView.builder(
          //     shrinkWrap: true,
          //     itemCount: iconNames.length,
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 4,
          //       crossAxisSpacing: 10.0,
          //       mainAxisSpacing: 10.0,
          //     ),
          //     itemBuilder: (context, index) {
          //       String iconName = iconNames[index];
          //       return GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             _selectedIcon = iconName;
          //           });
          //         },
          //         child: Container(
          //           decoration: BoxDecoration(
          //             border: Border.all(
          //               color: _selectedIcon == iconName
          //                   ? Colors.blue
          //                   : Colors.transparent,
          //               width: 2,
          //             ),
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //           child: Image.asset(
          //             'lib/Images/$iconName.png',
          //             height: 35,
          //             width: 35,
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          MyButton(label: 'save', onTap: saveCategory),
        ],
      ),
    );
  }

  Future<void> saveCategory() async {
    try {
      if (newCategoryController.text.isNotEmpty &&
          maxValueController.text.isNotEmpty &&
          minValueController.text.isNotEmpty) {
        CategoryModel category = CategoryModel(
            name: newCategoryController.text,
            minValue: double.parse(minValueController.text),
            maxValue: double.parse(
                maxValueController.text)); //, iconName: _selectedIcon);
        await firebaseDatabasehelper.newVitalCategory(category);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        showInfoSnachBar('all fields should be filled!');
      }
    } catch (e) {
      showErrorSnachBar('Error creating category');
    }
  }

  void showErrorSnachBar(String message) {
    awesomeTopSnackbar(context, message,
        iconWithDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
            color: Colors.amber.shade400),
        backgroundColor: Colors.amber,
        icon: const Icon(
          Icons.close,
          color: Colors.white,
        ));
  }

  void showInfoSnachBar(String message) {
    awesomeTopSnackbar(context, message,
        iconWithDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
            color: Colors.lightBlueAccent.shade400),
        backgroundColor: Colors.lightBlueAccent,
        icon: const Icon(
          Icons.info_outline,
          color: Colors.white,
        ));
  }

  void showSuccessSnachBar(String message) {
    awesomeTopSnackbar(context, message,
        iconWithDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
            color: Colors.green.shade400),
        backgroundColor: Colors.green,
        icon: const Icon(
          Icons.check,
          color: Colors.white,
        ));
  }
}
