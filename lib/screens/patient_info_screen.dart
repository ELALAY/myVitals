import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvitals/Components/my_buttons/my_button.dart';
import 'package:myvitals/Components/my_textfields/my_numberfield.dart';
import 'package:myvitals/screens/home.dart';

import '../Utils/globals.dart';
import '../models/person.dart';

class PatientInfoScreen extends StatefulWidget {
  final User user;
  const PatientInfoScreen({super.key, required this.user});

  @override
  State<PatientInfoScreen> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  Gender? _selectedGender;

  void _onGenderChanged(Gender? gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  void savePatientInfo() {
    FirebaseFirestore.instance.collection('persons').doc(widget.user.uid).set({
      'gender': genderController.text,
      'contact_number': contactNumberController.text,
      'height': heightController.text,
      'weight': weightController.text,
      'age': ageController.text,
    }, SetOptions(merge: true)) // Use merge to update only specified fields
        .then((_) {
      debugPrint("Patient information updated successfully");
      // Navigate to the PatientInfoScreen
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(user: widget.user,),
        ),
      );
    }).catchError((error) {
      debugPrint("Failed to update patient information: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Information'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
              onPressed: savePatientInfo, icon: const Icon(Icons.check_sharp))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              //Age input
              MyNumberField(
                  controller: ageController,
                  label: 'age',
                  color: Colors.red,
                  enabled: true),
              //Age input
              MyNumberField(
                  controller: heightController,
                  label: 'height',
                  color: Colors.red,
                  enabled: true),
              //Age input
              MyNumberField(
                  controller: weightController,
                  label: 'Weight',
                  color: Colors.red,
                  enabled: true),
              //contact number
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: contactNumberController,
                  keyboardType: TextInputType.number,
                  enabled: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    labelText: 'Contact Number',
                    labelStyle: TextStyle(color: Colors.red),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Gender Selection
              const Text(
                'Select Gender:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              DropdownButton<Gender>(
                value: _selectedGender,
                hint: const Text('Select Gender'),
                items: Gender.values.map((Gender gender) {
                  return DropdownMenuItem<Gender>(
                    value: gender,
                    child: Text(gender.toString().split('.').last),
                  );
                }).toList(),
                onChanged: _onGenderChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
