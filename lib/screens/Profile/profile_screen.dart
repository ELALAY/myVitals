import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvitals/Components/my_list_tile.dart';
import 'package:myvitals/models/person_model.dart';
import 'package:myvitals/screens/Profile/profile_information.dart';

import '../categories/catogories_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final Person personProfile;
  const ProfileScreen(
      {super.key, required this.user, required this.personProfile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MyListTile(
                    icon: const Icon(Icons.category_outlined),
                    tileTitle: 'Vital Categories',
                    onTap: navCategoriesScreen),
                MyListTile(
                    icon: const Icon(Icons.person_2_outlined),
                    tileTitle: 'My Profile',
                    onTap: navProfileScreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void navCategoriesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategoriesScreen(
                user: widget.user,
                personProfile: widget.personProfile,
              )),
    );
  }

  void navProfileScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfileInformation(
                user: widget.user,
                personProfile: widget.personProfile,
              )),
    );
  }
}
