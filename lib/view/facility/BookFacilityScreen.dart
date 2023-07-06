import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poms_app/utils/PositiveButton.dart';
import 'package:provider/provider.dart';
import '../../data/respose/Status.dart';
import '../../model/SignInModel.dart';
import '../../model/facility/FacilityBookingModel.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/utils.dart';
import '../../viewmodel/facility/FacilityBookingViewModel.dart';
import 'FacilityBookingFormScreen.dart';

import '../../viewmodel/UserViewModel.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookFacilityScreen extends StatefulWidget {
  final String facilityName;
  final int facilityId;

  final String image;
  var permisssions;
  BookFacilityScreen(
      {Key? key,
      required this.facilityName,
      required this.facilityId,
      required this.image,required this.permisssions})
      : super(key: key);

  @override
  State<BookFacilityScreen> createState() => _BookFacilityScreenState();
}

class _BookFacilityScreenState extends State<BookFacilityScreen> {
  var userVM = UserViewModel();
  var viewModel = FacilityBookingViewModel();
  String firstName = "";
  String lastName = "";
  String unitNumber = "";
  int propertyId = 0;

  DateTime _displayedMonth = DateTime.now();
  late CalendarController _calendarController;
  List<Appointment> _selectedAppointments = [];
  List<FacilityItems> _appointments = [];
  DateTime _selectedDate = DateTime.now();
  List<FacilityItems> facilityBookings = [];
  Map<DateTime, List<Appointment>> _appointmentsMap = {};

  List<FacilityItems> facilityItemsByDate = [];
  List<String> facilityNames = [];
  final DateFormat _monthNameFormat = DateFormat.MMMM();
  // int facilityId = 0;
  List<Permissions> permissions = [];
  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  bool isupload = false;
  @override
  void initState() {
    super.initState();

    getUserDetails();
    _calendarController = CalendarController();
    _displayedMonth = DateTime.now();
    permissions = widget.permisssions;
    actionPermissions();
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.firstName;

      firstName = userid ?? '';
      print(firstName);
      final lastname = value.userDetails?.lastName;
      lastName = lastname ?? '';
      print(lastName);
      setState(() {
        firstName = userid ?? '';
        print(firstName);
        lastName = lastname ?? '';
        print(lastName);
      });
      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      final unitnmb = value.userDetails?.unitNumber;
      unitNumber = unitnmb ?? " ";
      final blockname = value.userDetails?.blockName;
      // blockName = blockname ?? "";
      final usertypeId = value.userDetails?.userType;
      // userTypeId = usertypeId ?? 0;
      final appusagetypeid = value.userDetails?.appUsageTypeId;
      // appusagetypeId = appusagetypeid ?? 0;
      fetchFacilityBookings();
    });

  }
  void actionPermissions () async {

    setState(() {
      for (var item in permissions){

        if( (item.moduleDisplayNameMobile == "Facility Booking") && (item.action != null && item.action!.isNotEmpty)){
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
            else if ( act.actionName == "Upload files" || act.actionId == 7) {
              isupload = true;
              print("upload = $isupload");

            }
          }
        }
      }
    });
  }
  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final formatter = DateFormat('dd-MM-yyyy hh:mm:ss');
    return formatter.format(dateTime);
  }

  Future<void> fetchFacilityBookings() async {
    final facilityId = widget.facilityId;
    final response = await viewModel.fetchFacilityBookingList(
      facilityId,
      "ASC",
      "id",
      1,
      500,
      propertyId,"",""
    );

    if (response.data?.status == 200) {
      if (response.data?.result != null) {
        final data = response.data!.result!.items;
        if (data != null) {
          if (data.isNotEmpty) { // Add a check for non-empty list
            setState(() {
              facilityBookings = data;
              // Sort bookings by date
              facilityBookings.sort((a, b) => a.usageStarttime!.compareTo(b.usageStarttime!));
              for (final booking in facilityBookings) {
                final bookingDate = DateTime.parse(booking.usageStarttime ?? "");
                _getAppointmentsForDate(bookingDate);
              }
            });
          }
        }
      }
    } else {
      Utils.flushBarErrorMessage("failed", context);
    }
  }


  List<Appointment> _getAppointmentsForDate(DateTime date) {
    final appointments = _appointmentsMap[date] ?? [];
    if (appointments.isNotEmpty) {
      return appointments;
    }

    final filteredBookings = facilityBookings.where((booking) {
      final bookingDate = DateTime.parse(booking.usageStarttime ?? "");
      return bookingDate.year == date.year &&
          bookingDate.month == date.month &&
          bookingDate.day == date.day;
    }).toList();

    filteredBookings.forEach((booking) {
      final startTimeString = (booking.usageStarttime ?? "");
      final endTimeString = booking.usageEndtime ?? "";

      final startTimeFormatted = formatDateTime(startTimeString);
      final endTimeFormatted = formatDateTime(endTimeString);
      final name = booking.facilityKeyCodeHandoverBy ?? '';
      final unitNo = booking.createdBy.toString() ?? '';
      final facility =  booking.facilityName ?? '';
      final hours = booking.bookingHrsDay ?? '';
      final bookingstatus = booking.bookingStatusName ?? '';
      final appointment = Appointment(
        startTime: DateTime.parse(startTimeString),
        endTime: DateTime.parse(endTimeString),
        subject: name,
        id: unitNo,
        recurrenceId  : facility,
        recurrenceRule:hours,
notes: bookingstatus,
      );

      // Add appointment only if it's on selected date or present date
      if (appointment.startTime.day == date.day ||
          appointment.startTime.day == DateTime.now().day) {
        appointments.add(appointment);
      }
    });

    _appointmentsMap[date] = appointments;

    // Sort appointments by start time
    appointments.sort((a, b) => a.startTime.compareTo(b.startTime));

    return appointments;
  }

  void _handleCalendarTap(CalendarTapDetails details) {
    final selectedDate = details.date!;
    setState(() {
      _selectedDate = selectedDate;
    });

    if (_selectedDate != null) {
      final appointments = _getAppointmentsForDate(selectedDate);
      setState(() {
        _selectedAppointments = appointments;
      });

      if (_selectedAppointments.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No bookings for selected date.'),
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
 Future <void> appointmentDetailsPopup(BuildContext context, Appointment appointment) async{

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(

              content: SingleChildScrollView(
                  child: Column(children: [


                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 10, right: 10, bottom: 10),
                      child:Container(

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,

                          ),
                          color: Color(0xFFD3D3D3FF),
                        ),
                        child: IntrinsicWidth(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: Card(

                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2.0,bottom: 2.0,left: 4,right: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text('Key Handover By :',style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), ))),

                                        Expanded(child: Text( appointment.subject.split('/')[0],style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), ))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2.0,bottom: 2.0,left: 4,right: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text('Unit No :',style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), ))),
                                        Expanded(child: Text('${appointment.id ?? ''}',style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), ))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2.0,bottom: 2.0,left: 4,right: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text('Stat Time :',style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), ))),


                                        Expanded(child: Text('${DateFormat('yyyy-MM-dd hh:mm a').format(appointment.startTime)}',style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), ))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2.0,bottom: 2.0,left: 4,right: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text('End Time :',style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), ))),
                                        Expanded(child: Text('${DateFormat('yyyy-MM-dd hh:mm a').format(appointment.endTime)}',
                                            style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), )),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2.0,bottom: 2.0,left: 4,right: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text('Facility Name :',style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), ))),
                                        Expanded(child: Text('${appointment.recurrenceId ?? ''}',style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), ))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2.0,bottom: 2.0,left: 4,right: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text('Booking hours:',style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), ),)),
                                        Text(' '),
                                        Expanded(child: Text("${appointment.recurrenceRule ?? ''}",style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), ))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2.0,bottom: 2.0,left: 4,right: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text('BookingStatus:',style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), ))),
                                        Text(' '), // add a one-character space
                                        Expanded(child: Text('${appointment.notes ?? ''}',style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12,), ))),
                                      ],
                                    ),
                                  ),
                                ),

                              ),


                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF036CB2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40))),onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.close), label: Text('Close')),
                    ),
                  ])),
            );
          });
        });
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
          '${widget.facilityName}',
          style: Theme.of(context).textTheme.headlineLarge,
          // TextStyle(
          //     fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2)
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        _displayedMonth = DateTime(
                          _displayedMonth.year,
                          _displayedMonth.month - 1,
                        );
                      });
                      _calendarController.displayDate = _displayedMonth;
                    },
                  ),
                  Text(
                    '${_monthNameFormat.format(_displayedMonth)} - ${_displayedMonth.year}',
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        _displayedMonth = DateTime(
                          _displayedMonth.year,
                          _displayedMonth.month + 1,
                        );
                      });
                      _calendarController.displayDate = _displayedMonth;
                    },
                  ),
                ],
              ),
            ),
            SfCalendar(
              view: CalendarView.month,
              onTap: _handleCalendarTap,
              controller: _calendarController,
              initialDisplayDate:
                  DateTime(_displayedMonth.year, _displayedMonth.month),
              todayHighlightColor: Color(0xFF036CB2),
              dataSource: AppointmentDataSource(_selectedAppointments),

              monthCellBuilder: (BuildContext context, MonthCellDetails details) {
                final appointments = _getAppointmentsForDate(details.date);
                final isToday = details.date.isAtSameMomentAs(DateTime(
                  _displayedMonth.year,
                  _displayedMonth.month,
                  _displayedMonth.day,
                ));

                List<Widget> children = [];

                if (isToday) {
                  children.add(
                    Center(
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF036CB2)
                        ),
                        child: Center(
                          child: Text(
                            details.date.day.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  children.add(
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Text(
                        details.date.day.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }

                if (appointments.isNotEmpty) {
                  children.add(
                    Positioned(
                      left: 5,
                      right: 5,
                      bottom: 5,
                      child: _getDots(appointments, unitNumber),
                    ),


                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Stack(
                    children: children,
                  ),
                );
              },

              appointmentTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              monthViewSettings: MonthViewSettings(
                appointmentDisplayMode:
                    MonthAppointmentDisplayMode.appointment,
              ),
            ),
            (() {
              if (_selectedDate != null) {
                return ListView.


                builder(
                  itemCount: _selectedAppointments.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final appointment = _selectedAppointments[index];

                    return InkWell(
                      child: Card(
                        color: Colors.indigoAccent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, left: 4.0, bottom: 4.0),
                                    child: Text(
                                      appointment.subject.split('/')[0],
                                      style:GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white)) ,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4.0, left: 4.0),
                                  child: Text(appointment.id.toString(),
                                    style:GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white)) ,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, bottom: 4.0),
                              child: Text(
                                '${ DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(appointment.startTime.toString() ?? ''))} - '
                                    '${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(appointment.endTime.toString() ?? ''))}',
                                  style:GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white)) ,
                              ),
                            ),
                          ],
                        ),
                      ),
                        onTap: () {
                          appointmentDetailsPopup(context, appointment);
                        }
                    );
                  },
                );
              } else if (_selectedDate == null) {
                return Container(
                  height: 30,
                  child: Center(
                    child: Text('No appointments for selected date.'),
                  ),
                );
              } else {
                return Container();
              }
            }()),
            if(iscreate)
            SizedBox(
              width: MediaQuery.of(context).size.width*0.70,
              child: PositiveButton(
                text: 'Book Facility',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FacilityBookingFormScreen(
                        facilityName: widget.facilityName,
                        image: widget.image,
                        facilityId: widget.facilityId,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDots1(List<Appointment> appointments, String unitNumber) {
    final bool hasGreenDot = appointments.any((a) => a.id == unitNumber);
    final bool hasRedDot = appointments.any((a) => a.id != unitNumber);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasGreenDot)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
        if (hasRedDot)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
  Widget _getDots(List<Appointment> appointments, String unitNumber) {
    final bool hasGreenDot = appointments.any((a) => a.id == unitNumber);
    final bool hasRedDot = appointments.any((a) => a.id != unitNumber);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasGreenDot)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
        if (hasRedDot)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }


}

class AppointmentDataSource extends CalendarDataSource<Appointment> {
  final List<Appointment> appointments;

  AppointmentDataSource(this.appointments);

  @override
  DateTime getStartTime(int index) {
    return appointments[index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].endTime;
  }

  @override
  String getSubject(int index) {
    return appointments[index].subject;
  }

  @override
  Color getColor(int index) {
    return Color(0xFF036CB2);
  }

  @override
  bool isAllDay(int index) {
    return false;
  }

  @override
  List<Object> getChildren(int index) {
    return [];
  }

  @override
  String getNotes(int index) {
    return '';
  }

  @override
  String getLocation(int index) {
    return '';
  }

  @override
  bool isReadOnly(int index) {
    return true;
  }
}
