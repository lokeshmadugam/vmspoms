import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewDropDown extends StatelessWidget {
  NewDropDown({
    Key? key,
    this.hintText,
    required this.controller,
    required this.items,
    required this.onchanged,
  }) : super(key: key);

  final String? hintText;
  final List<String>? items;
  final ValueChanged onchanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: CustomDropdown.search(
        hintText: hintText,
        controller: controller,
        items: items,
        onChanged: onchanged,
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey, width: 0.5),
      ),
    );
  }
}
