import 'package:brew_crew/constants/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({Key? key}) : super(key: key);

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  String user = '';
  String currentSugar = '';
  int currentBrewColor = 500;

  final List<String> sugarDropDown = ['0', '1', '2', '3', '4', '5'];

  Future updateBrewUser(String id, String userName, String sugar) async {
    try {
      await _firestore.collection("users").doc(id).update({
        "name": user != '' ? user : userName,
        "sugar": currentSugar != '' ? currentSugar : sugar,
        "currentStrength": currentBrewColor
      });
    } on FirebaseAuthException catch (err) {
      debugPrint(err.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Update your brew settings",
                style: kTextTitleAppBar.copyWith(
                  fontSize: 17,
                  fontFamily: "Roboto",
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 25),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: _firestore
                          .collection("users")
                          .doc(_auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final ref = snapshot.data;
                          final id = ref?.id;
                          final userName = ref?.get('name');
                          final sugar = ref!.get('sugar').toString();
                          double currentBrew = double.parse(
                              ref.get('currentStrength').toString());
                          return Column(
                            children: [
                              TextFormField(
                                initialValue: userName,
                                decoration: kInputBorder,
                                onChanged: (value) {
                                  setState(() {
                                    user = value;
                                  });
                                },
                                validator: (value) =>
                                    value!.isEmpty ? "Enter the name" : null,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              DropdownButtonFormField(
                                items: sugarDropDown.map(
                                  (val) {
                                    return DropdownMenuItem(
                                      value: val,
                                      child: Text("$val sugar(s)"),
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    currentSugar = val as String;
                                  });
                                },
                                value: sugar.toString(),
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 130, 103, 61),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 130, 103, 61),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Slider(
                                value: currentBrewColor.toDouble(),
                                min: 100.0,
                                max: 900.0,
                                divisions: 8,
                                activeColor:
                                    const Color.fromARGB(255, 130, 103, 61),
                                inactiveColor:
                                    const Color.fromARGB(255, 182, 182, 182),
                                onChanged: (val) {
                                  setState(() {
                                    currentBrewColor = val.round();
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    updateBrewUser(id!, userName, sugar);
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 13, 20, 13),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 130, 103, 61),
                                  ),
                                  child: const Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Inter",
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                            child: SpinKitRing(
                              color: Color.fromARGB(255, 130, 103, 61),
                              size: 60.0,
                            ),
                          );
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
