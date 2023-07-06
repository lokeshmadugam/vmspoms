import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDropDown extends StatelessWidget {
  MyDropDown({
    Key? key,

     this.hintText,
     this.labelText,
    required this.value,
    required this.items,
    required this.onchanged,
    this.enabled = false,
  }) : super(key: key);

  final String? hintText;
  final String? labelText;
  var value;
  final List<DropdownMenuItem<dynamic>>? items;
  final ValueChanged onchanged;
bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(6.0),
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField(
            //menuMaxHeight: 200,

            decoration: InputDecoration(
                labelText: labelText,
                labelStyle:GoogleFonts.roboto(textStyle:TextStyle(color: Colors.grey,fontSize: 13,fontWeight: FontWeight.normal), ),
                // Theme.of(context).textTheme.bodyText1,
              enabled: enabled ,
                contentPadding:
                const EdgeInsets.fromLTRB(10,0,0,0),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),

                ),
                focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
            ),
            items: items,
            value: value,
            onChanged: onchanged,

            hint: Text(
              hintText.toString(),
              style: GoogleFonts.roboto(textStyle:TextStyle(color: Colors.grey,fontSize: 13,fontWeight: FontWeight.normal), ),
              // style: Theme.of(context).textTheme.bodyText1,
            ),
            icon: const Icon(
              Icons.arrow_drop_down_outlined,
              // color: Colors.grey
              // Color(0xFF036CB2),
            ),
            iconSize: 24,
            style: const TextStyle(color: Colors.black),
          ),
        ));
  }
}