import 'package:brew_crew/screens/authentication/sign_in.dart';
import 'package:brew_crew/screens/authentication/sign_up.dart';
import "package:flutter/material.dart";

class IndexAuth extends StatefulWidget {
  const IndexAuth({Key? key}) : super(key: key);

  @override
  State<IndexAuth> createState() => _IndexAuthState();
}

class _IndexAuthState extends State<IndexAuth> {
  bool isSignUp = false;
  void showToggle() {
    setState(() {
      isSignUp = !isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isSignUp) {
      return SignUpView(toggle: showToggle);
    } else {
      return SignInView(toggle: showToggle);
    }
  }
}
