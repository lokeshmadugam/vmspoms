import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
class RuleBookScreen extends StatefulWidget {
  String? facilityName;
  RuleBookScreen({Key? key, required this.facilityName}) : super(key: key);

  @override
  State<RuleBookScreen> createState() => _RuleBookScreenState();
}

class _RuleBookScreenState extends State<RuleBookScreen> {
  @override
  Widget build(BuildContext context) {
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
            'Rules',
            style: Theme.of(context).textTheme.headlineLarge,
            // TextStyle(
            //     fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                HtmlWidget(
                  widget.facilityName.toString(),
                  textStyle: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       generateDocument(data.body);
                //     },
                //     child: Text(
                //       'View PDF',
                //       style: const TextStyle(
                //           fontWeight: FontWeight.normal,
                //           color: Colors.white),
                //     ),
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.indigo,
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(25))),
                //   ),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
              ],
            ),
          ),
    )
        )
    );
  }
}
