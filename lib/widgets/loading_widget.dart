import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: const SpinKitRing(
        color: Color.fromARGB(255, 130, 103, 61),
        size: 60.0,
      ),
    );
  }
}
