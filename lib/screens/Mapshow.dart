import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'Payment.dart';

double latitude;
double longitude;


PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};
List<LatLng> polylineCoordinates = [];

class Mapshow extends StatefulWidget {

  final double employeeLat, employeeLong;

  Mapshow(this.employeeLat,this.employeeLong);

  @override
  _MapshowState createState() => _MapshowState();
}

class _MapshowState extends State<Mapshow> {
  Set<Marker> _markers = {};
  void _onmapcreated(GoogleMapController controller) {
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId('id-1'),
            position: LatLng(widget.employeeLat, widget.employeeLong),
            infoWindow: InfoWindow(onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return Payment();
                  }));
            },
                title: "Jolikaran", snippet: 'Hardworking boi')),
      );
    });
  }

  @override
  void initState() {

    getcurrentlocation();
    addPolyLine();
    makeLines();
    super.initState();
  }

  Future<void> getcurrentlocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      print(position);
      print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('id-2'),
            position: LatLng(latitude, longitude),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  void makeLines() async {
    await polylinePoints
        .getRouteBetweenCoordinates(
      'AIzaSyC0mDpWjR6y6mIwWIpRV6O7uAeQr_gaFSI',
      PointLatLng(latitude, longitude), //Starting LATLANG
      PointLatLng(20.8505, 76.2711), //End LATLANG
      travelMode: TravelMode.driving,
    )
        .then((value) {
      value.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }).then((value) {
      addPolyLine();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(polylines: Set<Polyline>.of(polylines.values),
          onMapCreated: _onmapcreated,
          markers: _markers,
          initialCameraPosition:
          CameraPosition(target: LatLng(10.8505, 76.2711), zoom: 5),
        ));
  }
}
