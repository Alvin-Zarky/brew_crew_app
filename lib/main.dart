import 'package:brew_crew/screens/index.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Brew Crew Coffee App",
      home: MainPageWrapper(),
    );
  }
}
