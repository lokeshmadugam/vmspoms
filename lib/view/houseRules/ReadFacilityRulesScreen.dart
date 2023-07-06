

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';

class ReadFacilityRulesScreen extends StatefulWidget {
  var facilityname;
  var data;
   ReadFacilityRulesScreen({Key? key,required this.data,required this.facilityname}) : super(key: key);

  @override
  State<ReadFacilityRulesScreen> createState() => _ReadFacilityRulesScreenState();
}

class _ReadFacilityRulesScreenState extends State<ReadFacilityRulesScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print("Wid = $width");
    print("hei = $height");
    double? fontSize;
    if(width < 411 || height < 707){
      fontSize = 11;
      print("SmallSize = $fontSize");
    }else {
      fontSize = 14;
      print("BigSize = $fontSize");


    }

    return Scaffold(
        appBar: AppBar(
          leadingWidth: 90,
          leading: Row(
            children: [
              SizedBox(
                width: 20,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  iconSize: 20, // reduce the size of the icon
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 1.0),
                child: SizedBox(
                  width: 60, // set a wider width for the text
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      'Back',
                      style: Theme.of(context).textTheme.headlineMedium
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            '${widget.facilityname}',
           style: Theme.of(context).textTheme.headlineMedium
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF036CB2),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        HtmlWidget(
                          widget.data,
                          textStyle: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.black)),
                        ),
                      ],

                    )
                )
            )
        )
    );
  }
}

