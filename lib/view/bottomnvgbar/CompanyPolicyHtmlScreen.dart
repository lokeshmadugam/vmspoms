import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import '../../model/CompanyPolicies.dart';
import '../notifications/PDFScreen.dart';

class CompanyPolicyHtmlScreen extends StatefulWidget {
  var data;

  CompanyPolicyHtmlScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<CompanyPolicyHtmlScreen> createState() =>
      _CompanyPolicyHtmlScreenState();
}

class _CompanyPolicyHtmlScreenState extends State<CompanyPolicyHtmlScreen> {

  PolicyItems data = PolicyItems();
  String? generatedPdfFilePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.data!=null){
      data = widget.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        elevation: 0.0,
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
          data.dispName.toString(),
          style: Theme.of(context).textTheme.headlineLarge,
          // TextStyle(
          //     fontSize: 16, color: Colors.white, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
          backgroundColor: Color(0xFF036CB2)
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
                  data.policyDescription.toString(),
                  textStyle:GoogleFonts.roboto(textStyle: TextStyle(color: Colors.black,fontSize: 13)) ,

                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      generateDocument(data.policyDescription);
                    },
                    child: Text(
                      'View PDF',
                      style: GoogleFonts.roboto(textStyle: TextStyle(
                          fontWeight: FontWeight.normal,fontSize: 16,
                          color: Colors.white), )
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF036CB2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> generateDocument(var body) async {
    final htmlContent = body;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    final targetFileName = "notification-pdf";

    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(htmlContent, targetPath, targetFileName);
    generatedPdfFilePath = generatedPdfFile.path;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFScreen(pdfPath: generatedPdfFilePath.toString()),
      ),
    );

  }

}
