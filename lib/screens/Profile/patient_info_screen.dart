import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvitals/Components/my_textfields/my_numberfield.dart';
import 'package:myvitals/screens/home.dart';
import 'package:myvitals/services/realtime_db/firebase_db.dart';
import '../../models/person_model.dart';

class PatientInfoScreen extends StatefulWidget {
  final User user;
  final Person personProfile;
  const PatientInfoScreen(
      {super.key, required this.user, required this.personProfile});

  @override
  State<PatientInfoScreen> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  FirebaseDB firebaseDB = FirebaseDB();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  void savePatientInfo() {
    try {
      FirebaseFirestore.instance
          .collection('persons')
          .doc(widget.user.uid)
          .set({
        'height': heightController.text,
        'weight': weightController.text,
        'age': ageController.text,
      });
      debugPrint("Patient information updated successfully");
      // Navigate to the Home Page
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
      );
    } catch (e) {
      debugPrint("Failed to update patient information: $e");
    }
  }

  @override
  void initState() async {
    super.initState();
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
            ],
          ),
        ),
      ),
    );
  }
}
