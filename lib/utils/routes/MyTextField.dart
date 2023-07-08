import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
    this.labelText,
    this.suffixIcon,
    required this.controller,
    required this.textInputType,
    this.hintText,
    this.onPressed,
    this.onTap,
    this.onChanged,
    this.validator,
    this.enabled,
    this.preffixIcon,
    this.maxLines,
  }) : super(key: key);

  final String? labelText;
  final String? hintText;
  final int? maxLines;
  final TextEditingController controller;
  final TextInputType textInputType;
  final IconData? suffixIcon;
  final VoidCallback? onPressed;
  final VoidCallback? onTap;
  final ValueChanged? onChanged;
  final FormFieldValidator<dynamic>? validator;
  final bool? enabled;
  final IconData? preffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        onTap: onTap,
        keyboardType: textInputType,
        validator: validator,
        maxLines: maxLines,
        enabled: enabled,
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
          ),

          labelText: labelText,
          // labelStyle: const TextStyle(
          //   color: Colors.grey,
          // ),
          // contentPadding: const EdgeInsets.fromLTRB(15,0,0,0),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixText: ' ',
          hintText: hintText,

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
          // Color(0xFF036CB2)
        ),
      ),
    );
  }
}
