import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings(); //check later
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  return await Geolocator.getCurrentPosition();
}

class GoogleMapScreen extends StatefulWidget {
  GoogleMapScreen({Key key}) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('id-1'),
          // position: LatLng(46.493882, 30.683254599999998)));
          position: LatLng(37.4219983, -122.084)));
    });
  }

  var locationMessageLat = "";
  var locationMessageLong = "";
  // var locationLat = "";
  // var locationLong = "";

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();
    print(lastPosition);
    var locationLat = position.latitude;
    var locationLong = position.longitude;
    print(locationLat);
    setState(() {
      // locationMessage = "$locationLat, $locationLong";
      locationMessageLat = "$locationLat";
      locationMessageLong = "$locationLong";
    });
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // print('my current: ' + position.latitude.toString());
    // Position lastPosition = await Geolocator.getLastKnownPosition();
    // StreamSubscription<Position> positionStream =
    //     Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high)
    //         .listen((position) {
    //   print(position == null
    //       ? 'Unknown'
    //       : 'mda' +
    //           position.latitude.toString() +
    //           ', ' +
    //           position.longitude.toString());
    // });
    // print('last position: ' + lastPosition.toString());
    // setState(() {
    //   locationMessageLat = positionStream as String;
    //   locationMessageLong = positionStream as String;
    // });
  }

  @override
  Widget build(BuildContext context) {
    _determinePosition();
    getCurrentLocation();
    return Container(
      child: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          initialCameraPosition: CameraPosition(
              // target: LatLng(46.493882, 30.683254599999998), zoom: 15)),
              target: LatLng(double.parse(locationMessageLat),
                  double.parse(locationMessageLong)),
              zoom: 15)),
    );
  }
}

// class GeolocatorService {
//   Future<Position> getCurrentLocation() async {
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }
// }

// class Appbloc with ChangeNotifier {
//   final geolocatorService = GeolocatorService();
//   Position currentLocation;

//   Appbloc() {
//     setCurrentLocation();
//   }
//   setCurrentLocation() async {
//     currentLocation = await geolocatorService.getCurrentLocation();
//     notifyListeners();
//   }
// }
