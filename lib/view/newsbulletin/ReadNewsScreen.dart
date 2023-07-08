import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../model/newsbulletin/NewsBulletinModel.dart';

class ReadNewsScreen extends StatefulWidget {
  var data;

  ReadNewsScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<ReadNewsScreen> createState() => _ReadNewsScreenState();
}

class _ReadNewsScreenState extends State<ReadNewsScreen> {
  NewsBulletinItems _newsItems = NewsBulletinItems();

  void initState() {
    super.initState();

    _newsItems = widget.data;
  }

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
                    child: Text('Back',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                ),
              ),
            ],
          ),
          title: Text('${_newsItems.newsBulletinName}',
              style: Theme.of(context).textTheme.headlineLarge),
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
                          _newsItems.picDocument ?? "",
                          textStyle: GoogleFonts.roboto(
                              textStyle: TextStyle(color: Colors.black)),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                                "Published on: ${_newsItems.announcementDate != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(_newsItems.announcementDate.toString())) : ''}",
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF1B248D)))),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.10,
                            ),
                            Text(
                                "at: ${_newsItems.announcementDate != null ? DateFormat('hh:mm a').format(DateTime.parse(_newsItems.announcementDate.toString())) : ''}",
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF1B248D)))),
                          ],
                        ),
                      ],
                    )))));
  }
}
