import 'package:brew_crew/screens/authentication/index.dart';
import 'package:brew_crew/screens/home/brew_crew.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class MainPageWrapper extends StatefulWidget {
  const MainPageWrapper({Key? key}) : super(key: key);

  @override
  State<MainPageWrapper> createState() => _MainPageWrapperState();
}

class _MainPageWrapperState extends State<MainPageWrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return const BrewCrewView();
        } else {
          return const IndexAuth();
        }
      }),
    );
  }
}
