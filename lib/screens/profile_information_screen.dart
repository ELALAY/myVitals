import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Add this import for File handling

import '../models/person.dart';
import '../components/my_textfields/my_numberfield.dart';
import '../components/my_textfields/my_textfield.dart';

class ProfileInformationScreen extends StatefulWidget {
  final User user;
  final Person person;
  const ProfileInformationScreen({super.key, required this.user, required this.person});

  @override
  State<ProfileInformationScreen> createState() => _ProfileInformationScreenState();
}

class _ProfileInformationScreenState extends State<ProfileInformationScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  String _selectedGender = 'other'; // Default value
  File? _profileImage; // Variable to store selected profile picture

  @override
  void initState() {
    super.initState();
    // Initialize controllers and selected gender
    usernameController.text = widget.person.username;
    emailController.text = widget.person.email;
    contactNumberController.text = widget.person.contactNumber;
    heightController.text = widget.person.height.toString();
    weightController.text = widget.person.weight.toString();
    ageController.text = widget.person.age.toString();
    _selectedGender = widget.person.gender.toString();
    // Load profile image if available
    if (widget.person.profile_picture.isNotEmpty) {
      _profileImage = File(widget.person.profile_picture);
    }
  }


  Future<String?> _uploadProfileImage(File image) async {
    try {
      debugPrint('uploading prfile image to cloud');
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${image.path.split('/').last}');
      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      } else {
        debugPrint('No image selected.');
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> saveProfile() async {
    try {
      // Upload the image to Firebase Storage if a new image is selected
      String? profilePictureUrl;
      if (_profileImage != null) {
        // Implement your image upload logic here and get the download URL
        profilePictureUrl = await _uploadProfileImage(_profileImage!);
      }

      await FirebaseFirestore.instance
          .collection('persons')
          .doc(widget.user.uid)
          .set({
        'gender': _selectedGender,
        'contactNumber': contactNumberController.text.trim(),
        'height': double.tryParse(heightController.text.trim()) ?? 0,
        'weight': double.tryParse(weightController.text.trim()) ?? 0,
        'age': int.tryParse(ageController.text.trim()) ?? 0,
        if (profilePictureUrl != null) 'profilePicture': profilePictureUrl,
      }, SetOptions(merge: true));

      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')));
    } catch (e) {
      debugPrint('Error Saving Changes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
          actions: [
            IconButton(onPressed: saveProfile, icon: const Icon(Icons.check))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                      children: [
                        Container(
                          width:
                              120, // Set width to make the CircleAvatar bigger
                          height:
                              120, // Set height to make the CircleAvatar bigger
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : widget.person.profile_picture
                                          .isNotEmpty
                                      ? NetworkImage(
                                          widget.person.profile_picture)
                                      : const NetworkImage(
                                          'https://icons.veryicon.com/png/o/miscellaneous/common-icons-31/default-avatar-2.png',
                                        ) as ImageProvider,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -15,
                          left: -10,
                          child: IconButton(
                              onPressed: _pickProfileImage,
                              icon: const Icon(Icons.add_a_photo_outlined)),
                        ),
                      ],
                    ),
              const SizedBox(height: 16.0),
              MyTextField(
                  controller: usernameController,
                  label: 'Username',
                  color: Colors.red,
                  enabled: true),
              MyTextField(
                  controller: emailController,
                  label: 'Email',
                  color: Colors.red,
                  enabled: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 100.0,
                      child: MyNumberField(
                          controller: ageController,
                          label: 'Age',
                          color: Colors.red,
                          enabled: true)),
                  SizedBox(
                    width: 100.0,
                    child: MyNumberField(
                        controller: heightController,
                        label: 'Height',
                        color: Colors.red,
                        enabled: true),
                  ),
                  SizedBox(
                    width: 100.0,
                    child: MyNumberField(
                        controller: weightController,
                        label: 'Weight',
                        color: Colors.red,
                        enabled: true),
                  ),
                ],
              ),
              MyTextField(
                  controller: contactNumberController,
                  label: 'Contact Number',
                  color: Colors.red,
                  enabled: true),
            ],
          ),
        ));
  }
}
