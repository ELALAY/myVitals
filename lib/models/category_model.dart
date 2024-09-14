import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final double minValue; // New field for minimum value
  final double maxValue; // New field for maximum value

  // Constructor without ID (for creating new categories)
  CategoryModel({
    required this.name,
    required this.minValue,
    required this.maxValue,
  }) : id = '';

  // Constructor with ID (for existing categories with ID)
  CategoryModel.withId({
    required this.id,
    required this.name,
    required this.minValue,
    required this.maxValue,
  });

  // Factory method to create a CategoryModel from a Firestore document
  factory CategoryModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel.withId(
      id: doc.id,
      name: data['name'] ?? '',
      minValue: (data['minValue'] ?? 0).toDouble(),
      maxValue: (data['maxValue'] ?? 0).toDouble(),
    );
  }

  // Convert a CategoryModel instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'minValue': minValue,
      'maxValue': maxValue,
    };
  }

  // Factory method to create a CategoryModel from a map (e.g., for local usage)
  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel.withId(
      id: id,
      name: map['name'] ?? '',
      minValue: (map['minValue'] ?? 0).toDouble(),
      maxValue: (map['maxValue'] ?? 0).toDouble(),
    );
  }
}
