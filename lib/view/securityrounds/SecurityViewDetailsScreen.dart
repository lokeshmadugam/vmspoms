import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../viewmodel/securityrounds/SecurityViewDetailsScreenViewModel.dart';
import '../../model/SignInModel.dart';

class SecurityViewDetailsScreen extends StatefulWidget {
  const SecurityViewDetailsScreen({Key? key}) : super(key: key);

  @override
  State<SecurityViewDetailsScreen> createState() =>
      _SecurityViewDetailsScreenState();
}

class _SecurityViewDetailsScreenState extends State<SecurityViewDetailsScreen> {

  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Set<Circle> _circles = {};

  UserDetails userDetails = UserDetails();

  /*List<LatLng> pathPoints = [
    LatLng(37.785865, -122.406637),
    LatLng(37.786956, -122.407475),
    LatLng(37.788578, -122.406612),
    LatLng(37.788238, -122.404798),
    LatLng(37.787371, -122.404156),
    LatLng(37.785923, -122.404607),
    LatLng(37.784916, -122.405819),
    LatLng(37.784810, -122.407373),
    LatLng(37.785865, -122.406637),
  ];*/

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;

    Provider.of<SecurityViewDetailsScreenViewModel>(context, listen: false)
        .fetchSecurityDetails(userDetails.id, userDetails.propertyId);
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
        // title: Text(
        //   'Grey List',
        //   style: TextStyle(
        //       fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        // ),
        // centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Consumer<SecurityViewDetailsScreenViewModel>(
                  builder: (context, model, child) {
                if (model.securityDetails.data?.result?.items != null) {
                  var data = model.securityDetails.data!.result!.items![0].mapView;

                  List<LatLng> pathPoints = [];

                  for(int i=0;i<data!.length;i++){
                    pathPoints.add(LatLng(double.parse(data[i].checkinLatitude.toString()),
                        double.parse(data[i].checkinLongitude.toString())));
                  }

                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: pathPoints.first,
                      zoom: 15.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      setState(() {
                        _markers.add(
                          Marker(
                            markerId: MarkerId('start'),
                            position: pathPoints.first,
                          ),
                        );
                        _markers.add(
                          Marker(
                            markerId: MarkerId('end'),
                            position: pathPoints.last,
                          ),
                        );
                        _polylines.add(
                          Polyline(
                            polylineId: PolylineId('path'),
                            color: Colors.blue,
                            width: 3,
                            points: pathPoints,
                          ),
                        );
                        /*_circles.add(
                          Circle(
                              circleId: CircleId('path'),
                          )
                        );*/
                      });
                    },
                    markers: _markers,
                    polylines: _polylines,
                   // circles: _circles,
                  );
                }
                return Container();
              }),
            ),

          ],
        ),
      ),
    );
  }
}
