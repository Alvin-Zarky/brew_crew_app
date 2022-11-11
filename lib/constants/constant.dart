import "package:flutter/material.dart";

const kTextTitleAppBar = TextStyle(
  fontFamily: "Inter",
  fontWeight: FontWeight.bold,
  letterSpacing: 0.65,
);
const kInputBorder = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color.fromARGB(255, 130, 103, 61),
    ),
  ),
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
);
const kTextErrMessage = TextStyle(
  color: Color.fromARGB(255, 221, 56, 44),
  fontFamily: "Inter",
);
