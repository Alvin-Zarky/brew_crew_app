import 'package:brew_crew/constants/constant.dart';
import 'package:brew_crew/widgets/brew_list_tile.dart';
import 'package:brew_crew/widgets/modal_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BrewCrewView extends StatefulWidget {
  const BrewCrewView({Key? key}) : super(key: key);

  @override
  State<BrewCrewView> createState() => _BrewCrewViewState();
}

class _BrewCrewViewState extends State<BrewCrewView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void showBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => const ModalBottomSheet());
  }

  Future signOutUser() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (err) {
      debugPrint(err.message.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 130, 103, 61),
        title: Text(
          "Brew Crew",
          style: kTextTitleAppBar.copyWith(fontFamily: "Roboto"),
        ),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: signOutUser,
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  const Icon(Icons.logout),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    "Logout",
                    style: kTextTitleAppBar.copyWith(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: showBottomSheet,
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  const Icon(Icons.settings_outlined),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    "Settings",
                    style: kTextTitleAppBar.copyWith(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image(
              height: double.infinity,
              image: AssetImage("lib/assets/img/coffee_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection("users")
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final List<BrewListTile> array = [];
                      if (!snapshot.hasData) {
                        return const Center(
                          child: SpinKitRing(
                            color: Color.fromARGB(255, 130, 103, 61),
                            size: 60.0,
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        final ref = snapshot.data;
                        for (final data in ref!.docs) {
                          final name = data.get('name');
                          final sugar = data.get('sugar');
                          final currentStrength = data.get('currentStrength');
                          final userWidget = BrewListTile(
                              user: name,
                              amount: sugar.toString(),
                              brewColor: Colors.brown[currentStrength]);
                          array.add(userWidget);
                        }
                      }
                      return ListView(
                        children: array,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
