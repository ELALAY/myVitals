import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/person.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final Person person;
  const ProfileScreen({super.key, required this.user, required this.person});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('user profile')),);
  }
}