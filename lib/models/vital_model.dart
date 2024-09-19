import 'package:flutter/material.dart';

class VitalsModel {
  String id;
  String vitalCategory;
  double value;
  String user;
  DateTime date;
  int color;

  VitalsModel(this.vitalCategory, this.value, this.user, this.date, this.color) : id = '';

  VitalsModel.withId(
      this.id, this.vitalCategory, this.value, this.user, this.date, this.color);

  Map<String, dynamic> toMap() {
    return {
      'vitalCategory': vitalCategory,
      'value': value,
      'user': user,
      'date': date.toIso8601String(), // Store date as an ISO 8601 string
      'color': color 
    };
  }

  factory VitalsModel.fromMap(Map<String, dynamic> map, String id) {
    return VitalsModel.withId(
      id,
      map['vitalCategory'], 
      map['value'],
      map['user'],
      // Convert the stored date back into a DateTime object
      DateTime.parse(map['date']),
      map['color'] ?? Colors.white.value, // Default color
    );
  }
}
