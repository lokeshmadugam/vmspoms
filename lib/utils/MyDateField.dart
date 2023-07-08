import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDateField extends StatelessWidget {
  MyDateField(
      {Key? key,
      required this.labelText,
      required this.controller,
      required this.onPressed,
      this.onChanged,
      this.enabled,
      this.preffixIcon,
      this.suffixIcon,
      this.hintText})
      : super(key: key);
  final String? hintText;
  final String labelText;
  final TextEditingController controller;
  final VoidCallback onPressed;
  final ValueChanged? onChanged;
  final bool? enabled;
  final IconData? preffixIcon;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextFormField(
        readOnly: true,
        onChanged: onChanged,
        controller: controller,
        enabled: enabled,
        // enabled: true,
        style: Theme.of(context).textTheme.bodySmall,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: hintText,
          labelText: labelText,
          labelStyle: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.normal),
          ),
          hintStyle: GoogleFonts.roboto(
            textStyle: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.normal),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixText: ' ',
          prefixIcon: preffixIcon != null
              ? Icon(
                  preffixIcon,
                  // Color(0xFF036CB2),
                )
              : null,
          prefixIconConstraints: preffixIcon != null
              ? const BoxConstraints(
                  minWidth: 30,
                  minHeight: 30,
                )
              : const BoxConstraints(),
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon),
                  onPressed: onPressed,
                )
              : null,
        ),
        onTap: onPressed,
      ),
    );
  }
}
