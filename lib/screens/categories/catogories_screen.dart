import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myvitals/models/person_model.dart';
import '../../Components/my_buttons/my_button.dart';
import '../../Models/category_model.dart';
import '../../services/realtime_db/firebase_db.dart';
import 'create_category_screen.dart';
import 'edit_category_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final User user;
  final Person personProfile;
  const CategoriesScreen({super.key, required this.user, required this.personProfile});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  FirebaseDB firebaseDatabasehelper = FirebaseDB();
  List<CategoryModel> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    isLoading = false;
  }

  void reload() {
    isLoading = true;
    fetchCategories();
    isLoading = false;
  }

  void fetchCategories() async {
    List<CategoryModel> temp =
        await firebaseDatabasehelper.fetchAllVitalsCategories(widget.user.uid);
    setState(() {
      categories = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0.0,
        title: const Text('Categories'),
        actions: [
          IconButton(onPressed: reload, icon: const Icon(Icons.refresh))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        bool isActiveCategory = widget.personProfile.categories.contains(category.id);
                        return Slidable(
                            key: const ValueKey(0),

                            // The start action pane is the one at the left or the top side.
                            startActionPane: ActionPane(
                              // A motion is a widget used to control how the pane animates.
                              motion: const StretchMotion(),

                              // All actions are defined in the children parameter.
                              children: [
                                // A SlidableAction can have an icon and/or a label.
                                SlidableAction(
                                  onPressed: (context) {
                                    editcategory(category);
                                    fetchCategories();
                                  },
                                  backgroundColor:
                                      const Color.fromARGB(255, 192, 174, 174),
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Update',
                                ),
                              ],
                            ),

                            // The start action pane is the one at the left or the top side.
                            endActionPane: ActionPane(
                              // A motion is a widget used to control how the pane animates.
                              motion: const StretchMotion(),

                              // All actions are defined in the children parameter.
                              children: [
                                // A SlidableAction can have an icon and/or a label.
                                SlidableAction(
                                  onPressed: (context) {
                                    _showDeleteCategoryDialog(category);
                                    fetchCategories();
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete_forever_outlined,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SwitchListTile(
                                title: Text(category.name),
                                  activeColor: Colors.pink,
                                  tileColor: Colors.grey.shade200,
                                  value: isActiveCategory, // Show active/inactive based on user's categories
                                  onChanged: (value) {
                                setState(() {
                                  if (value) {
                                    widget.personProfile.categories.add(category.id); // Add category if activated
                                  } else {
                                    widget.personProfile.categories.remove(category.id); // Remove category if deactivated
                                  }
                                });
                                // Update the person's categories in Firebase
                                updateUserCategories();
                              },
                            ),
                            ));
                      }),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createCategory,
        backgroundColor: Colors.pink,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void updateUserCategories() async {
    try {
      // Update user's category list in Firestore
      await firebaseDatabasehelper.updatePersonCategories(widget.user.uid, widget.personProfile.categories);
      showSuccessSnachBar('Categories updated!');
    } catch (e) {
      showErrorSnachBar('Error updating categories!');
    }
  }

  void _showDeleteCategoryDialog(CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text(category.name),
          actions: [
            MyButton(
                label: 'delete',
                onTap: () {
                  setState(() {
                    categories.remove(category);
                  });
                  deleteCategory(category);
                  Navigator.of(context).pop();
                  fetchCategories();
                }),
          ],
        );
      },
    );
  }

  void editcategory(CategoryModel catergory) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditCategory(
        category: catergory,
      ); // replace with your settings screen
    })).then((value) => reload());
  }

  void _createCategory() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const CreateCategory(); // replace with your settings screen
    })).then((value) => reload());
  }

  void deleteCategory(CategoryModel category) async {
    try {
      firebaseDatabasehelper.deleteUserVitalCategory(category);
      setState(() {
        fetchCategories(); // Reload categories
      });
      showSuccessSnachBar('Category deleted!');
    } catch (e) {
      showErrorSnachBar('Error deleting category!');
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
