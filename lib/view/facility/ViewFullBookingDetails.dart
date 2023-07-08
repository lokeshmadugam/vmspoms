import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/facility/FacilityBookingModel.dart';
import '../../utils/MyDateField.dart';
import '../../utils/MyTextField.dart';

class BookingDetails extends StatefulWidget {
  var data;

  BookingDetails({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  final _facilityNameController = TextEditingController();
  final _bookingIdController = TextEditingController();
  final _numberofguestController = TextEditingController();
  final _bookingHoursController = TextEditingController();
  final _bookingStatusController = TextEditingController();
  final _bookingStartDateController = TextEditingController();
  final _bookingEndDateController = TextEditingController();
  final _keyCollectionDateController = TextEditingController();
  final _keyCollectionnameController = TextEditingController();
  final _keyHandOverbyController = TextEditingController();
  final _remarksController = TextEditingController();
  final _keyHandoverdateController = TextEditingController();
  final _usageController = TextEditingController();
  TextEditingController _keyHandoverTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FacilityItems items = FacilityItems();

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      items = widget.data;
      _facilityNameController.text = items.facilityName.toString();
      _bookingIdController.text = items.bookingId.toString();
      _numberofguestController.text = items.noOfUsrGuests.toString();
      _bookingHoursController.text = items.bookingHrsDay.toString();
      _bookingStatusController.text = items.bookingStatusName.toString();

      _usageController.text = items.usageDate != null
          ? DateFormat('yyyy-MM-dd hh:mm a')
              .format(DateTime.parse(items.usageDate ?? ''))
          : ''.toString();

      _bookingStartDateController.text = items.usageStarttime != null
          ? DateFormat('yyyy-MM-dd hh:mm a')
              .format(DateTime.parse(items.usageStarttime ?? ''))
          : ''.toString();

      _bookingEndDateController.text = items.usageEndtime != null
          ? DateFormat('yyyy-MM-dd hh:mm a')
              .format(DateTime.parse(items.usageEndtime ?? ''))
          : ''.toString();
      _keyHandoverTimeController.text = items.facilityKeyCodeCollectionTime !=
              null
          ? DateFormat('yyyy-MM-dd hh:mm a')
              .format(DateTime.parse(items.facilityKeyCodeCollectionTime ?? ''))
          : ''.toString();
      _keyCollectionnameController.text = items.keyCollectedName.toString();
      _keyHandOverbyController.text =
          items.facilityKeyCodeHandoverBy.toString();
      _remarksController.text = items.remarks.toString();
      _keyHandoverdateController.text = items.facilityKeyCodeHandoverTime !=
              null
          ? DateFormat('yyyy-MM-dd hh:mm a')
              .format(DateTime.parse(items.facilityKeyCodeHandoverTime ?? ''))
          : ''.toString();
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
                    child: Text('Back',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            'Booking Details',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF036CB2)),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MyTextField(
                    enabled: false,
                    preffixIcon: Icons.library_books_outlined,
                    controller: _facilityNameController,
                    labelText: 'Facility Name',
                    textInputType: TextInputType.text),
                MyTextField(
                    enabled: false,
                    preffixIcon: Icons.numbers,
                    controller: _bookingIdController,
                    labelText: 'Booking Id',
                    textInputType: TextInputType.number),
                MyTextField(
                  enabled: false,
                  preffixIcon: Icons.timer_sharp,
                  labelText: 'Hours',
                  controller: _bookingHoursController,
                  textInputType: TextInputType.text,
                ),
                MyTextField(
                    enabled: false,
                    preffixIcon: Icons.person_3,
                    controller: _numberofguestController,
                    labelText: 'No. of Guest',
                    textInputType: TextInputType.text),
                MyTextField(
                    enabled: false,
                    preffixIcon: Icons.info_outline,
                    controller: _bookingStatusController,
                    labelText: 'Booking Status',
                    textInputType: TextInputType.text),
                MyTextField(
                    enabled: false,
                    preffixIcon: Icons.calendar_today,
                    controller: _usageController,
                    labelText: 'Usage Date',
                    textInputType: TextInputType.text),
                MyTextField(
                    enabled: false,
                    preffixIcon: Icons.date_range,
                    controller: _bookingStartDateController,
                    labelText: 'Booking Start Date',
                    textInputType: TextInputType.text),
                MyTextField(
                    enabled: false,
                    preffixIcon: Icons.date_range,
                    controller: _bookingEndDateController,
                    labelText: 'Booking End Date',
                    textInputType: TextInputType.text),
                MyTextField(
                    enabled: false,
                    preffixIcon: Icons.lock_clock,
                    controller: _keyHandoverTimeController,
                    labelText: 'Key Collection Date',
                    textInputType: TextInputType.text),
                MyTextField(
                    enabled: false,
                    preffixIcon: Icons.person,
                    controller: _keyCollectionnameController,
                    labelText: 'Key Collection Name',
                    textInputType: TextInputType.text),
                MyTextField(
                    enabled: false,
                    preffixIcon: Icons.person,
                    controller: _keyHandOverbyController,
                    labelText: 'Hand Over Name',
                    textInputType: TextInputType.text),
                MyTextField(
                    enabled: false,
                    preffixIcon: Icons.av_timer_sharp,
                    controller: _keyHandoverTimeController,
                    labelText: 'Hand Over Time',
                    textInputType: TextInputType.text),
                MyTextField(
                    enabled: false,
                    preffixIcon: Icons.sticky_note_2,
                    controller: _remarksController,
                    labelText: 'Remarks',
                    textInputType: TextInputType.text),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
