import 'package:brew_crew/constants/constant.dart';
import 'package:brew_crew/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class SignUpView extends StatefulWidget {
  final VoidCallback toggle;
  const SignUpView({
    Key? key,
    required this.toggle,
  }) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _textNameController = TextEditingController();
  final _textEmailController = TextEditingController();
  final _textPasswordController = TextEditingController();

  String email = '';
  String errMessage = '';
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _textNameController.dispose();
    _textEmailController.dispose();
    _textPasswordController.dispose();
  }

  Future signUpUserWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
        errMessage = '';
      });
      final name = _textNameController.text.trim();
      final email = _textEmailController.text.trim();
      final password = _textPasswordController.text.trim();
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      setState(() {
        isLoading = false;
      });
      return await _firestore.collection("users").doc(result.user!.uid).set({
        "name": name,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
        "role": "user",
        "isAdmin": false,
        "isOnline": true,
        "sugar": "0",
        "currentStrength": 500,
      });
    } on FirebaseAuthException catch (err) {
      debugPrint(err.message.toString());
      setState(() {
        isLoading = false;
        errMessage = err.message.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingWidget()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 130, 103, 61),
              title: Text(
                "Sign Up To Brew Crew",
                style: kTextTitleAppBar.copyWith(fontFamily: "Roboto"),
              ),
              centerTitle: false,
              actions: [
                GestureDetector(
                  onTap: widget.toggle,
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: Row(
                      children: [
                        const Icon(Icons.login),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Login",
                          style: kTextTitleAppBar.copyWith(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 45,
                  left: 40,
                  right: 40,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _textNameController,
                        decoration: kInputBorder.copyWith(
                          hintText: 'Enter the name',
                          prefixIcon: const Icon(
                            Icons.person,
                            size: 23,
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter the name" : null,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: _textEmailController,
                        decoration: kInputBorder.copyWith(
                          hintText: 'Enter the email',
                          prefixIcon: const Icon(
                            Icons.email,
                            size: 23,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter the email";
                          }
                          if (!EmailValidator.validate(
                              _textEmailController.text)) {
                            return "Email invalid";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: _textPasswordController,
                        obscureText: true,
                        decoration: kInputBorder.copyWith(
                          hintText: 'Enter the password',
                          prefixIcon: const Icon(
                            Icons.lock,
                            size: 22,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter the password";
                          }
                          if (value.length < 6) {
                            return "Password must be 6 characters";
                          }
                          return null;
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            signUpUserWithEmailAndPassword();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 25),
                          padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 130, 103, 61),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Inter",
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        errMessage,
                        style: kTextErrMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
