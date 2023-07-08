import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../model/newsbulletin/NewsBulletinModel.dart';
import '../../model/visitorreg/VisitorsStatusModel.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/newsBulletin&announcement/NewsBulletinViewModel.dart';
import 'ReadAnnouncementsScreen.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  var userVM = UserViewModel();
  var viewModel = NewsButtelinViewModel();

  int propertyId = 0;
  int userId = 0;

  String unitNumber = " ";
  int newsId = 0;
  List<NewsBulletinItems> _newsItems = [];
  List<VisitorStatusItems> visitorStatusItems = [];
  DateTime _todayDate = DateTime.now();
  List<NewsBulletinItems> filteredNewsItems = [];
  List<NewsBulletinItems> todayNewsItems = [];
  List<NewsBulletinItems> lastWeekNewsItems = [];
  List<NewsBulletinItems> latstOnemonth = [];
  List<NewsBulletinItems> olderNewsItems = [];

  final List<Color> colors = [
    Color(0xFFFA8605),
    Colors.indigo.shade500,
    Color(0xFF91DE7C),
    Color(0xFF2F7EC2),
  ];

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
      userId = userid ?? 0;

      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      final unitnmb = value.userDetails?.unitNumber;
      unitNumber = unitnmb ?? " ";
      fetchNewsandAnnouncements();
    });
  }

  void fetchNewsandAnnouncements() async {
    viewModel
        .getNewsandAnnouncements(
            "ASC", "id", 1, 25, "VMS", "AnnounceNewBulletin")
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              visitorStatusItems = data;
              for (var item in data) {
                final id = item.id ?? 0;
                if (id == 296) {
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
        .getNewsList("ASC", "id", 1, 500, propertyId.toString(), newsId)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _newsItems = data;

              for (var item in data) {
                DateTime announcementDate =
                    DateTime.parse(item.announcementDate.toString());
                DateTime today = DateTime.now();
                DateTime oneWeekAgo = today.subtract(Duration(days: 7));
                DateTime oneMonthAgo = today.subtract(Duration(days: 30));
                DateTime moreMonthAgo = today.subtract(Duration(days: 365));
                if (announcementDate.isAfter(today)) {
                  todayNewsItems.add(item);
                } else if (announcementDate.isAfter(oneWeekAgo)) {
                  lastWeekNewsItems.add(item);
                } else if (announcementDate.isAfter(oneMonthAgo)) {
                  latstOnemonth.add(item);
                } else if (announcementDate.isAfter(moreMonthAgo)) {
                  olderNewsItems.add(item);
                }
              }
              filteredNewsItems.addAll(todayNewsItems);
              filteredNewsItems.addAll(lastWeekNewsItems);
              filteredNewsItems.addAll(latstOnemonth);
              filteredNewsItems.addAll(olderNewsItems);
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
      // appBar: AppBar(
      //   leadingWidth: 90,
      //   leading: Row(
      //     children: [
      //       SizedBox(
      //         width: 20,
      //         child: IconButton(
      //           onPressed: () {
      //             setState(() {
      //               Navigator.pop(context);
      //             });
      //           },
      //           iconSize: 20, // reduce the size of the icon
      //           icon: Icon(
      //             Icons.arrow_back_ios,
      //             color: Colors.white,
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: EdgeInsets.only(left: 1.0),
      //         child: SizedBox(
      //           width: 60, // set a wider width for the text
      //           child: TextButton(
      //             onPressed: () {
      //               setState(() {
      //                 Navigator.pop(context);
      //               });
      //             },
      //             child: Text(
      //               'Back',
      //               style: Theme.of(context).textTheme.headlineMedium,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      //   title: Text(
      //     'Announcements',
      //     style:  Theme.of(context).textTheme.headlineLarge,
      //     // TextStyle(
      //     //     fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Color(0xFF036CB2),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredNewsItems.length,
                    itemBuilder: (context, index) {
                      var item = filteredNewsItems![index];
                      Color itemColor;
                      if (index < todayNewsItems.length) {
                        itemColor = colors[0]; // Today's news color
                      } else if (index <
                          (todayNewsItems.length + lastWeekNewsItems.length)) {
                        itemColor = colors[1]; // Last week's news color
                      } else if (index <
                          (todayNewsItems.length +
                              lastWeekNewsItems.length +
                              latstOnemonth.length)) {
                        itemColor = colors[2]; // One month old news color
                      } else {
                        itemColor =
                            colors[3]; // More than one month old news color
                      }
                      return InkWell(
                        child: Card(
                          // shadowColor: colors[index % colors.length],
                          color: Colors.grey.shade100,

                          elevation: 8.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                  color: itemColor,
                                ),
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  child: Text(
                                    item.newsBulletinName!.toString(),
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    height: 60,
                                    child: SingleChildScrollView(
                                      child: HtmlWidget(
                                          item.picDocument ??
                                              " ".trim().substring(1, 3),
                                          textStyle: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13
                                                // maxLines: 2, // Specify the maximum number of lines to display
                                                ),
                                          )),
                                    ),
                                  )),
                              Divider(
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "${item.announcementDate != null ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(item.announcementDate.toString())) : ''}",
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF1B248D)))),
                                    Text("Click here...",
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF1B248D))))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReadAnnouncementsScreen(
                                      data: item,
                                    )),
                          );
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
