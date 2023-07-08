import 'package:flutter/material.dart';

const Color blue = Colors.blue;

//Text colors
const Color textColorWhite = Colors.white;
const Color textColorBlack = Colors.black;
const Color textColorBlue = Colors.blue;
const Color greyTextHint = Colors.grey;

//Button background colors
const Color positiveBtnBgColor = Colors.blue;
Color negativeBtnBgColor = Colors.blueGrey.shade50;

//Gradients
final blueGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.blue.shade200,
    Colors.blue,
  ],
);

final blueGreenGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Colors.blueAccent.shade700, Colors.greenAccent.shade200],
);
