import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:myvitals/Models/category_model.dart';
import 'package:myvitals/models/vital_model.dart';

import '../../models/person_model.dart';

class FirebaseDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//--------------------------------------------------------------------------------------
//********  Person Functions**********/
//--------------------------------------------------------------------------------------

  // get person profile by ID
  Future<Person?> getPersonProfile(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection('persons').doc(uid).get();

      if (documentSnapshot.exists) {
        return Person.fromMap(documentSnapshot.data()!, uid);
      } else {
        debugPrint('No user profile found for uid: $uid');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return null;
    }
  }

  // get person profile by username
  Future<Person?> getPersonProfileByUsername(String username) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('persons')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming you want to return the first match
        return Person.fromMap(
            querySnapshot.docs.first.data(), querySnapshot.docs.first['id']);
      } else {
        debugPrint('No user profile found for username: $username');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return null;
    }
  }

  //get all persons on the app
  Future<List<Person>> getAllPersons() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('persons').get();
      List<Person> allPersons = querySnapshot.docs
          .map((doc) => Person.fromMap(doc.data(), doc.id))
          .toList();
      return allPersons;
    } catch (e) {
      debugPrint('Error fetching all persons: $e');
      return [];
    }
  }

  // update person profile by user ID
  Future<void> updatePersonProfile(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('persons').doc(userId).update(updatedData);
      debugPrint('Profile updated successfully.');
    } catch (e) {
      debugPrint('Failed to update profile: $e');
      throw Exception('Error updating profile');
    }
  }

  Future<void> updatePersonCategories(
      String uid, List<String> categories) async {
    await _firestore.collection('persons').doc(uid).update({
      'categories': categories,
    });
  }

  // edit user vital
  Future<void> updateUserVitalCategory(CategoryModel category) async {
    try {
      _firestore
          .collection('categories')
          .doc(category.id)
          .update(category.toMap());
    } catch (e) {
      debugPrint('Error updating vital category');
    }
  }

  // Read user vitals by category
  Future<List<VitalsModel>> fetchUserVitalsByCategory(String uid, String category) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('vitals')
          .where('user', isEqualTo: uid)
          .where('vitalCategory', isEqualTo: category)
          .get();
      List<VitalsModel> allVitals = querySnapshot.docs
          .map((doc) => VitalsModel.fromMap(doc.data(), doc.id))
          .toList();
      return allVitals;
    } catch (e) {
      debugPrint('Error fetching user vitals for $uid: $e');

      return [];
    }
  }
//--------------------------------------------------------------------------------------
//********  Vitals Functions**********/
//--------------------------------------------------------------------------------------

  // Record a vital
  Future<void> recordNewVital(VitalsModel vital) async {
    try {
      _firestore.collection('vitals').add(vital.toMap());
    } catch (e) {
      debugPrint('Error adding vital');
    }
  }

  // Read user vitals
  Future<List<VitalsModel>> fetchUserVital(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('vitals')
          .where('user', isEqualTo: uid)
          .get();
      List<VitalsModel> allVitals = querySnapshot.docs
          .map((doc) => VitalsModel.fromMap(doc.data(), doc.id))
          .toList();
      return allVitals;
    } catch (e) {
      debugPrint('Error fetching user vitals for $uid: $e');

      return [];
    }
  }

  // edit user vital
  Future<void> updateUserVital(VitalsModel vital) async {
    try {
      _firestore.collection('vitals').doc(vital.id).update(vital.toMap());
    } catch (e) {
      debugPrint('Error updating vital');
    }
  }

  // delete user vital
  Future<void> deleteUserVital(VitalsModel vital) async {
    try {
      _firestore.collection('vitals').doc(vital.id).delete();
    } catch (e) {
      debugPrint('Error deleting vital');
    }
  }

//--------------------------------------------------------------------------------------
//********  Vital Categories Functions**********/
//--------------------------------------------------------------------------------------

  // Record a user vital
  Future<void> newVitalCategory(CategoryModel category) async {
    try {
      _firestore.collection('categories').add(category.toMap());
    } catch (e) {
      debugPrint('Error adding category');
    }
  }

  // Read all vital categories
  Future<List<CategoryModel>> fetchAllVitalsCategories(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('categories').get();
      List<CategoryModel> allCategories = querySnapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
          .toList();
      return allCategories;
    } catch (e) {
      debugPrint('Error fetching user vitals: $e');
      return [];
    }
  }

  // fetch category by ID
  Future<CategoryModel?> fetchCategoryById(String categoryId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _firestore.collection('categories').doc(categoryId).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        // Return a single CategoryModel
        return CategoryModel.fromMap(docSnapshot.data()!, docSnapshot.id);
      } else {
        return null; // Return null if the document does not exist
      }
    } catch (e) {
      debugPrint('Error fetching category: $e');
      return null;
    }
  }

  // delete user vital
  Future<void> deleteUserVitalCategory(CategoryModel category) async {
    try {
      WriteBatch batch = _firestore.batch();

      // Delete the category from the categories collection
      DocumentReference categoryRef =
          _firestore.collection('categories').doc(category.id);
      batch.delete(categoryRef);

      // Find all users who have this category in their list
      QuerySnapshot usersSnapshot = await _firestore
          .collection('persons')
          .where('categories', arrayContains: category.id)
          .get();

      for (DocumentSnapshot userDoc in usersSnapshot.docs) {
        List<String> updatedCategories =
            List<String>.from(userDoc['categories']);
        updatedCategories
            .remove(category.id); // Remove the deleted category from the list

        // Update the user's document with the updated category list
        batch.update(userDoc.reference, {'categories': updatedCategories});
      }

      // Commit the batch operation to delete the category and update users
      await batch.commit();
    } catch (e) {
      debugPrint('Error deleting category');
    }
  }
}
