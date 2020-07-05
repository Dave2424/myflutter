import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:permission/permission.dart';

class Mymap extends StatefulWidget {
  Mymap({Key key}) : super(key: key);

  @override
  _MymapState createState() => _MymapState();
}

class _MymapState extends State<Mymap> {


  GoogleMapController _controller;
  final Set<Polyline> polylines = {};
  Set<Marker> _markers = {};
  List<LatLng> routeCoords = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = 'AIzaSyA3whKRHle7Fv6bk4mntyUY6f70CPIFHY8';
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: 'AIzaSyA3whKRHle7Fv6bk4mntyUY6f70CPIFHY8');
      // new GoogleMapPolyline(apiKey: 'AIzaSyDPaFRwkTfLGUgDovW6ZrldT9e77mYR7sU');
      // new GoogleMapPolyline(apiKey: 'AIzaSyBMLQ3ZXfD-K3Ip54qEo5yobukiDUVLNOM');


static LatLng _initialPosition;


String searchAddr = '';
static const kGoogleApiKey = "AIzaSyA3whKRHle7Fv6bk4mntyUY6f70CPIFHY8";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

// latlng.add(_new);
// latlng.add(_news);


  @override
  void initState() { 
    super.initState();
    getsomePoints();
  }


  getsomePoints() async {
    var permission = await Permission.getPermissionsStatus([PermissionName.Location]);
    if (permission[0].permissionStatus == PermissionStatus.notAgain) {
      var askpermissions = await Permission.requestPermissions([PermissionName.Location]);
    
    } else {

    routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
      origin: LatLng(6.4698, 3.5852), 
      destination: LatLng(6.4703, 3.2818), 
      mode: RouteMode.driving);
      print('this is the routes of cordinates-----------------------------$routeCoords');

      setState(() {
        polylines.add(
          Polyline(polylineId: PolylineId('route1'),
          visible: true,
          points: routeCoords,
          width: 3,
          color: Colors.green[400],
          startCap: Cap.roundCap,
          endCap: Cap.buttCap)
        );
      });
    _getUserLocation();

    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: <Widget>[
          // textfield(),
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target:LatLng(6.5244, 3.3792),
              zoom: 14.0,          
              ),
              mapType: MapType.normal,
              onMapCreated: onMapCreated,
              polylines: polylines,
              myLocationEnabled: true,
          ),
        ],
      ));

  }

  Widget textfield() {
    return Container(
          padding: EdgeInsets.only(top: 14),
          color: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              // color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: "Enter address",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () async {
                              Prediction p = await PlacesAutocomplete.show(
                            context: context, apiKey: kGoogleApiKey,mode: Mode.fullscreen);
                              displayPrediction(p);
                            },
                            iconSize: 30.0,
                          )
                        ),
                        onChanged: (val) {
                          setState(() {
                            searchAddr = val;
                          }
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          ),
        );
  }
    
    Future<Null> displayPrediction(Prediction p) async {
      if (p != null) {
        PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p.placeId);

        var placeId = p.placeId;
        double lat = detail.result.geometry.location.lat;
        double lng = detail.result.geometry.location.lng;

        var address = await Geocoder.local.findAddressesFromQuery(p.description);

        print(lat);
        print(lng);
      }
  }

  void onMapCreated(GoogleMapController controller) {
    
    _controller = controller;
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    print(points);
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    print('RESULT-------------------------------------$result');
    return result;
  }
    void createRoute(String encondedPoly) {
    polylines.add(Polyline(
        polylineId: PolylineId('postionId'),
        width: 5,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.black));
    // notifyListeners();
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

   void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);

      print('User Position--------------------$position');
    _initialPosition = LatLng(position.latitude, position.longitude);
    print("the latitude is: ${position.longitude} and th longitude is: ${position.longitude} ");
    print("initial position is : ${_initialPosition.toString()}");
    print("The name of the position is : ${placemark[0].name} ${placemark[0].thoroughfare}, ${placemark[0].locality}");
    // locationController.text = placemark[0].name;
  }

}