import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poms_app/view/houseRules/ReadSubRulesScreen.dart';

import '../../model/houserules/HouseRulesModel.dart';
import '../../model/houserules/RulesModel.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/houserules/HouseRulesViewModel.dart';
class ReadRulesScreen extends StatefulWidget {
  var ruleName;
  var data;
  bool view;
  ReadRulesScreen({Key? key, required this.data, required this.ruleName,required this.view}) : super(key: key);

  @override
  State<ReadRulesScreen> createState() => _ReadRulesScreenState();
}

class _ReadRulesScreenState extends State<ReadRulesScreen> {
  var userVM = UserViewModel();
  var viewModel = HouseRulesViewModel();

  int propertyId = 0;
  int userId = 0 ;
  String unitNumber = " ";
 
List<RulesItems> _rulesItems = [];
bool showitems = false;
bool notshow = false;
int? count;
  void initState() {
    super.initState();
    getUserDetails();

  }

  void dispose() {
    super.dispose();
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id;
      userId =userid ?? 0;

      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      final unitnmb = value.userDetails?.unitNumber;
      unitNumber = unitnmb ?? " ";
setState(() {
  fetchRules();
});


    });
  }

  Future<void> fetchRules() async {
    viewModel
        .getRules( "ASC", "id", 1, 500, propertyId,widget.data)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          var itemscount  = response.data!.result!.itemCounts;
          if (data != null) {
            setState(() {

              _rulesItems = data;
count = itemscount;
if((_rulesItems != null || _rulesItems.isNotEmpty) && count != 0 ){
  showitems = true ;
}else{
  notshow = true;
}
            });

          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
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
            '${widget.ruleName}',
              style: Theme.of(context).textTheme.headlineLarge
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

        if ( _rulesItems.isNotEmpty  || count != 0)
        Visibility(
          visible: showitems,
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _rulesItems!.length,
            itemBuilder: (context, index) {
              var item = _rulesItems![index];

            if (_rulesItems.length == 1) {
                return Column(
                  children: [
                    HtmlWidget(
                        item.documentText ?? "",
                textStyle: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.black)),
                    ),
                  ],
                );
              }

              else if(_rulesItems.length >= 1) {
                return Visibility(
                  visible: showitems,
                  child: InkWell(
                    child: Card(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                            Icons.file_open_outlined, color: Color(0xFF036CB2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${item.documentName}",
                             style:  GoogleFonts.roboto(textStyle: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w500)),
                                ),

                             SizedBox(height: MediaQuery.of(context).size.height*0.005,),
                                Text("${item.docPublishDate != null
          ? DateFormat('yyyy-MM-dd hh:mm a')
          .format(DateTime.parse(item.docPublishDate
          .toString()))
          : ''}",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 12)))
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(Icons.keyboard_arrow_right_outlined),

                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      if(widget.view) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReadSubRulesScreen(data: item.documentText,
                                      rule: item.documentName,)));
                      }
                    },
                  ),
                );
              }
              // else if (_rulesItems.length == 0 || count == 0) {

              // }

            } ,

            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                // height: MediaQuery.of(context).size.height * 0.01,
              );
            },
          ),
        ),
        if ( _rulesItems.isEmpty  || count == 0)
          Visibility(
            visible: notshow,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text ('No Document Available!',style:   GoogleFonts.roboto(textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                    ),
                    SizedBox(height: 20,),
                    Image.asset(
                      'assets/images/prohibited.png',
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    )
    )
    )
    )
    );
  }
}
