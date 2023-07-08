import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../model/securityrounds/SecurityViewDetails.dart';

class SecurityDetailsMapScreen extends StatefulWidget {
  Items data;

  SecurityDetailsMapScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<SecurityDetailsMapScreen> createState() =>
      _SecurityDetailsMapScreenState();
}

class _SecurityDetailsMapScreenState extends State<SecurityDetailsMapScreen> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  late Items items;
  List<LatLng> pathPoints = [];

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
    items = widget.data;
    for (int i = 0; i < items.mapView!.length; i++) {
      if (items.mapView![i].checkinLatitude != null &&
          items.mapView![i].checkinLongitude != null) {
        pathPoints.add(LatLng(
            double.parse(items.mapView![i].checkinLatitude.toString()),
            double.parse(items.mapView![i].checkinLongitude.toString())));
      }
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
        title:
            Text('Map View', style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: GoogleMap(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
