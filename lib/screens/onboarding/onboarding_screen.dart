import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myvitals/Screens/onboarding/onboarding_page_1.dart';
import 'package:myvitals/models/person_model.dart';
import 'package:myvitals/services/realtime_db/firebase_db.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../home.dart';

class OnboardingScreen extends StatefulWidget {
  final User user;
  const OnboardingScreen({super.key, required this.user});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  FirebaseDB firebaseDB = FirebaseDB();
  final PageController _controller = PageController();
  bool isLastScreen = false;
  Person? personProfile;

  @override
  void initState() {
    super.initState();
    fetchprofile();
  }

  void fetchprofile() async {
    try {
      personProfile = await firebaseDB.getPersonProfile(widget.user.uid);
    } catch (e) {
      debugPrint('error fetching profile!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              isLastScreen = (index == 2);
            });
          },
          children: const [
            // vitals
            OnboardingPage(
              title: 'Keep track of your vitals',
              description: 'Here you can record your vitals on a daily basis',
              image: 'temperature',
            ),
            // history
            OnboardingPage(
              title: 'Vitals History',
              description:
                  'Here you can visualize the history of you recorded vitals',
              image: 'heartbeat',
            ),
            // insights
            OnboardingPage(
              title: 'Insights',
              description:
                  'You can find the status of your vitals before you reach critical levels',
              image: 'vitals_history',
            ),
          ],
        ),
        // controls and page indicator
        Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Skip to last page
                GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    )),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.deepPurple),
                ),
                isLastScreen
                    // Done => to home page
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MyHomePage(
                              user: widget.user,
                              personProfile: personProfile!,
                            );
                          }));
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ))
                    :
                    // Next Page
                    GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        )),
              ],
            )),
      ]),
    );
  }
}
