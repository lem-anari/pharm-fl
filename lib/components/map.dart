import 'dart:async';
import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:farma_app/components/map-src/application-bloc.dart';
import 'package:farma_app/components/map-src/models/place.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _mapController = Completer();
  StreamSubscription locationSubscription;
  StreamSubscription boundsSubscription;
  final _locationController = TextEditingController();
  SharedPreferences sharedPreferences;
  Timer timer;
  // final applicationBloc = ApplicationBloc();

  @override
  void initState() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    //Listen for selected Location
    locationSubscription =
        applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        _locationController.text = place.name;
        _goToPlace(place);
      } else
        _locationController.text = "";
    });

    applicationBloc.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    });
//    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => setGeolocation(applicationBloc));
    super.initState();
  }
  setGeolocation(final appBloc) async{
    sharedPreferences = await SharedPreferences.getInstance();

    String employeeId =  sharedPreferences.getString("employee_id");

    Map setCurrLocationEmployee = {
      'lat' : appBloc.currentLocation.latitude.toString(),
      'long': appBloc.currentLocation.longitude.toString(),
      'employee_id' : employeeId.toString()
    };
    var response = await http.post(Uri.parse("http://10.0.2.2:8000/api/employee/location"), body: setCurrLocationEmployee);

    if(response.statusCode == 200){
      print(response.body);
    }else{
      print(response.body);
    }
  }
  @override
  void dispose() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    _locationController.dispose();
    locationSubscription.cancel();
    boundsSubscription.cancel();
    timer.cancel();
    super.dispose();
  }

  void openLocationSetting() async {
    if (Platform.isAndroid) {
      final AndroidIntent intent = new AndroidIntent(
        action: 'android.settings.LOCATION_SOURCE_SETTINGS',
      );
      await intent.launch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
//    setGeolocation(applicationBloc);
    timer = Timer.periodic(Duration(seconds: 360), (Timer t) => setGeolocation(applicationBloc));

    // applicationBloc.asBroadcastStream;
    return Scaffold(
        // return ChangeNotifierProvider(
        //     create: (context) => ApplicationBloc(), // ???????????? ???????? ?? home
        //     child: Scaffold(
        // return Provider.value(
        //     value: applicationBloc,

        body: (applicationBloc.currentLocation == null)
            ? Center(
                // child: CircularProgressIndicator(),
                child: ElevatedButton(
                  child: const Text('Tap here to open settings'),
                  onPressed: openLocationSetting,
                ),
              )
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _locationController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'Search by City',
                        suffixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => applicationBloc.searchPlaces(value),
                      onTap: () => applicationBloc.clearSelectedLocation(),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 300.0,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                applicationBloc.currentLocation.latitude,
                                applicationBloc.currentLocation.longitude),
                            zoom: 14,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _mapController.complete(controller);
                          },
                          markers: Set<Marker>.of(applicationBloc.markers),
                        ),
                      ),
                      if (applicationBloc.searchResults != null &&
                          applicationBloc.searchResults.length != 0)
                        Container(
                            height: 300.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.6),
                                backgroundBlendMode: BlendMode.darken)),
                      if (applicationBloc.searchResults != null)
                        Container(
                          height: 300.0,
                          child: ListView.builder(
                              itemCount: applicationBloc.searchResults.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    applicationBloc
                                        .searchResults[index].description,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    applicationBloc.setSelectedLocation(
                                        applicationBloc
                                            .searchResults[index].placeId);
                                  },
                                );
                              }),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('?????????? ????????????????????',
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.normal)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8.0,
                      children: [
                        FilterChip(
                            label: Text('????????????', style: TextStyle(fontSize: 18.0),),
                            onSelected: (val) => applicationBloc
                                .togglePlaceType('pharmacy', val),
                            selected: applicationBloc.placeType == 'pharmacy',
                            selectedColor: Colors.blue),
                        FilterChip(
                            label: Text('????????', style: TextStyle(fontSize: 18.0)),
                            onSelected: (val) =>
                                applicationBloc.togglePlaceType('bank', val),
                            selected: applicationBloc.placeType == 'bank',
                            selectedColor: Colors.blue),
                      ],
                    ),
                  )
                ],
              ));
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                place.geometry.location.lat, place.geometry.location.lng),
            zoom: 14.0),
      ),
    );
  }
}
