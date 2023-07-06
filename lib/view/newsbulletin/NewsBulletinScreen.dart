import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poms_app/view/newsbulletin/ReadNewsScreen.dart';
import 'package:poms_app/viewmodel/newsBulletin&announcement/NewsBulletinViewModel.dart';

import '../../model/SignInModel.dart';
import '../../model/newsbulletin/NewsBulletinModel.dart';
import '../../model/visitorreg/VisitorsStatusModel.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/UserViewModel.dart';


class NewsBulletinScreen extends StatefulWidget {
  var data;
  NewsBulletinScreen({Key? key,required this.data}) : super(key: key);

  @override
  State<NewsBulletinScreen> createState() => _NewsBulletinScreenState();
}

class _NewsBulletinScreenState extends State<NewsBulletinScreen> {
  var userVM = UserViewModel();
  var viewModel = NewsButtelinViewModel();

  int propertyId = 0;
  int userId = 0 ;
  String unitNumber = " ";
  List<NewsBulletinItems> _newsItems = [];
  List<VisitorStatusItems> visitorStatusItems = [];
  List<Permissions> permissions = [];

  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  bool isupload = false;
  bool isprint = false;
  bool isdownload = false;
int newsId = 0;
  void initState() {
    super.initState();
    getUserDetails();
    permissions = widget.data;
    actionPermissions();
  }

  void dispose() {
    super.dispose();
    // getUserDetails();

  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id;
      userId =userid ?? 0;

      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      final unitnmb = value.userDetails?.unitNumber;
      unitNumber = unitnmb ?? " ";
      fetchNewsandAnnouncements();

    });
  }
  void actionPermissions () async {

    setState(() {
      for (var item in permissions){

        if( (item.moduleDisplayNameMobile == "News Bulletin") && (item.action != null && item.action!.isNotEmpty)){
          var actions = item.action ?? [];
          for (var act in actions){
            if( act.actionName == "Add" || act.actionId == 1){
              iscreate = true;
              print("addbutton = $iscreate");

            }
            else if ( act.actionName == "Edit" || act.actionId == 2) {
              isupdate = true;
              print("edit = $isupdate");

            }
            else if ( act.actionName == "Delete" || act.actionId == 3) {
              isdelete = true;
              print("delete = $isdelete");

            }
            else if ( act.actionName == "View" || act.actionId == 4) {
              isview = true;
              print("view = $isview");

            }
            else if ( act.actionName == "Print" || act.actionId == 5) {
              isprint = true;
              print("print = $isprint");

            }
            else if ( act.actionName == "Download files" || act.actionId == 6) {
              isdownload = true;
              print("download = $isdownload");

            }
            else if ( act.actionName == "Upload files" || act.actionId == 7) {
              isupload = true;
              print("upload = $isupload");

            }
          }
        }
      }
    });
  }

  void fetchNewsandAnnouncements() async {
    viewModel.getNewsandAnnouncements("ASC", "id", 1, 25, "VMS", "AnnounceNewBulletin").then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              visitorStatusItems = data;
              for(var item in data){
                final id = item.id ?? 0;
                if (id == 297){
                  newsId = id;
                  fetchNewsBulletin();
                }
              }
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }
  Future<void> fetchNewsBulletin() async {
    viewModel
        .getNewsList( "ASC", "id", 1, 500, propertyId.toString(),newsId)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _newsItems = data;
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print("Wid = $width");
    print("hei = $height");
    double? fontSize;
    if(width < 411 || height < 707){
      fontSize = 16;
      print("SmallSize = $fontSize");
    }else {
      fontSize = 18;
      print("BigSize = $fontSize");
    }
    return  Scaffold(

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
          'News Bulletin',
            style: Theme.of(context).textTheme.headlineLarge
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListView.builder(
                    itemCount: _newsItems.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var item = _newsItems[index];

                      if (item == null) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 5,
                            right: 5,
                            bottom: 5,
                          ),
                          child: Text(
                            "No data found",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return InkWell(
                       child:   Card(
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 8.0,bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  SizedBox(

                                    child: item.imgUrl != null && item.imgUrl!.isNotEmpty
                                        ? Image.network(
                                      "${item.imgUrl}",
                                      fit: BoxFit.cover,
                                    )
                                        : null,

                                  ),
                                  SizedBox(

                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                      child: Text(
                                        "${item.newsBulletinName ?? ""}",
                                        style:GoogleFonts.roboto(textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500) ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Text("${item.announcementDate != null
                                            ? DateFormat('yyyy-MM-dd hh:mm a')
                                            .format(DateTime.parse(item.announcementDate
                                            .toString()))
                                            : ''}",style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,color: Color(
                                            0xFF1B248D)))),

                                        Text("Click here...",style:GoogleFonts.roboto(textStyle: TextStyle(fontSize: 12,color: Color(
                                            0xFF1B248D))))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        onTap: (){
                         if(isview) {
                           Navigator.push(
                               context,
                               MaterialPageRoute(
                                   builder: (context) =>
                                       ReadNewsScreen(
                                         data: item,
                                       )));
                         }
                        },

                      );


                    }),
              ],
            ),
          ),
        ),
      ) ,
    );
  }

}
