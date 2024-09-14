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

//--------------------------------------------------------------------------------------
//********  Vitals Functions**********/
//--------------------------------------------------------------------------------------

  // Record a vital
  Future<void> recordNewVital(Vitals vital) async {
    try {
      _firestore.collection('vitals').add(vital.toMap());
    } catch (e) {
      debugPrint('Error adding vital');
    }
  }

  // Read user vitals
  Future<List<Vitals>> fetchUserVital(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('vitals')
          .where('user', isEqualTo: uid)
          .get();
      List<Vitals> allVitals = querySnapshot.docs
          .map((doc) => Vitals.fromMap(doc.data(), doc.id))
          .toList();
      return allVitals;
    } catch (e) {
      debugPrint('Error fetching user vitals: $e');
      return [];
    }
  }

  // edit user vital
  Future<void> updateUserVital(Vitals vital) async {
    try {
      _firestore.collection('vitals').doc(vital.id).update(vital.toMap());
    } catch (e) {
      debugPrint('Error updating vital');
    }
  }

  // delete user vital
  Future<void> deleteUserVital(Vitals vital) async {
    try {
      _firestore.collection('vitals').doc(vital.id).delete();
    } catch (e) {
      debugPrint('Error deleting vital');
    }
  }

//--------------------------------------------------------------------------------------
//********  Vitals Functions**********/
//--------------------------------------------------------------------------------------

  // Record a user vital
  Future<void> newVitalCategory(CategoryModel category) async {
    try {
      _firestore.collection('categories').add(category.toMap());
    } catch (e) {
      debugPrint('Error adding category');
    }
  }

  // Read user vital categories
  Future<List<CategoryModel>> fetchUserVitalsCategories(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('categories')
          .where('user', isEqualTo: uid)
          .get();
      List<CategoryModel> allCategories = querySnapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
          .toList();
      return allCategories;
    } catch (e) {
      debugPrint('Error fetching user categories: $e');
      return [];
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

  // edit user vital
  Future<void> updateUserVitalCategory(CategoryModel category) async {
    try {
      _firestore.collection('categories').doc(category.id).update(category.toMap());
    } catch (e) {
      debugPrint('Error updating vital category');
    }
  }

  // delete user vital
  Future<void> deleteUserVitalCategory(CategoryModel category) async {
    try {
      _firestore.collection('categories').doc(category.id).delete();
    } catch (e) {
      debugPrint('Error deleting category');
    }
  }
}
