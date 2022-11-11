import 'package:brew_crew/constants/constant.dart';
import 'package:brew_crew/widgets/loading_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class SignInView extends StatefulWidget {
  final VoidCallback toggle;
  const SignInView({
    Key? key,
    required this.toggle,
  }) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _textEmailController = TextEditingController();
  final _textPasswordController = TextEditingController();

  String email = '';
  String password = '';
  String errMessage = '';
  bool isLoading = false;

  Future signInUserWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
        errMessage = '';
      });
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        isLoading = false;
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
                "Sign In To Brew Crew",
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
                        const Icon(Icons.person),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Register",
                          style: kTextTitleAppBar.copyWith(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: Container(
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
                        if (!EmailValidator.validate(email)) {
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
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
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
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          signInUserWithEmailAndPassword();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 25),
                        padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 130, 103, 61),
                        ),
                        child: const Text(
                          "Sign In",
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
                      style: kTextErrMessage.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
