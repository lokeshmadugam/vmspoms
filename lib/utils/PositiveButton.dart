// import 'package:cashbook/data/res/Styles.dart';
import 'package:flutter/material.dart';

import 'Colors.dart';

class PositiveButton extends StatelessWidget {
  const PositiveButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF036CB2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      onPressed: onPressed,
      child: Text(text,
          textAlign: TextAlign.center,
          softWrap: true,
          style: Theme.of(context).textTheme.headlineMedium
          // const TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.w500),
          ),
    );
  }
}
