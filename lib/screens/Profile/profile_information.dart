import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvitals/Components/my_textfields/my_emailfield.dart';
import 'package:myvitals/Components/my_textfields/my_numberfield.dart';
import 'package:myvitals/Components/my_textfields/my_textfield.dart';

import '../../models/person_model.dart';
import '../../services/realtime_db/firebase_db.dart';

class ProfileInformation extends StatefulWidget {
  final User user;
  final Person personProfile;
  const ProfileInformation(
      {super.key, required this.user, required this.personProfile});

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  FirebaseDB firebaseDB = FirebaseDB();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  bool enableEdit = false;

  @override
  void initState() async {
    super.initState();
    usernameController =
        TextEditingController(text: widget.personProfile.username);
    emailController =
        TextEditingController(text: widget.personProfile.email);
    ageController = TextEditingController(text: widget.personProfile.age.toString());
    heightController =
        TextEditingController(text: widget.personProfile.height.toString());
    weightController =
        TextEditingController(text: widget.personProfile.weight.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Username
            MyTextField(
                controller: usernameController,
                label: 'Username',
                color: Colors.deepPurple,
                enabled: true),
            // Email
            MyEmailField(
                controller: emailController,
                label: 'Email',
                color: Colors.deepPurple,
                enabled: true),
            // Age
            MyNumberField(
                controller: ageController,
                label: 'Age',
                color: Colors.deepPurple,
                enabled: true),
            // Height
            MyNumberField(
                controller: heightController,
                label: 'height',
                color: Colors.deepPurple,
                enabled: true),
            // Weight
            MyNumberField(
                controller: weightController,
                label: 'Weight',
                color: Colors.deepPurple,
                enabled: true),
          ],
        ),
      ),
    );
  }
}
