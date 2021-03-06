import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:myflutter/services/google_maps_requests.dart';
import 'package:permission/permission.dart';

class AppState with ChangeNotifier {

  static const googleAPIKey = 'AIzaSyA3whKRHle7Fv6bk4mntyUY6f70CPIFHY8';
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  bool locationServiceActive = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  List<LatLng> routeCoords = [];


  PolylinePoints polylinePoints = PolylinePoints();
  GoogleMapPolyline googleMapPolyline =  
        new GoogleMapPolyline(apiKey: googleAPIKey);
  GoogleMapController _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleAPIKey);

  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();


  //getting & Setting
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;

  AppState() {
    _getUserLocation();
    // _loadingInitialPosition();
    getsomePoints();
    getPolylineRoute();
  }
// ! TO GET THE USERS LOCATION
  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);

      print('User Position--------------------$position');
    _initialPosition = LatLng(position.latitude, position.longitude);
    print("the latitude is: ${position.longitude} and th longitude is: ${position.longitude} ");
    print("initial position is : ${_initialPosition.toString()}");
    print("The name of the position is : ${placemark[0].name} ${placemark[0].thoroughfare}, ${placemark[0].locality}");
    locationController.text = placemark[0].name + ' ' +placemark[0].thoroughfare + ' ' +placemark[0].locality;

    notifyListeners();
  }
  getsomePoints () async {
    // getting the permission status from the user
    var permissions = await Permission.getPermissionsStatus([PermissionName.Location]);
    if (permissions[0].permissionStatus == PermissionStatus.notAgain) {
      var askpermissions = await Permission.requestPermissions([PermissionName.Location]);
    } else {
    // getting the coordinates of the user
    routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
      origin:  LatLng(6.5273, 3.3414),
      destination: LatLng(6.5536, 3.3567),
      mode: RouteMode.driving);
      makeRoute();
    }
  }
  void  getPolylineRoute() async{
    routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
      origin: LatLng(6.4698, 3.5852), destination: LatLng(6.4703, 3.2818), mode: RouteMode.driving);
    addMarker(LatLng(6.524379, 3.379206), locationController.text);
  }

  // ! TO CREATE ROUTE
  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 4,
        visible: true,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.black));
    notifyListeners();
  }
  void makeRoute() {
        _polyLines.add(
          Polyline(polylineId: PolylineId('route1'),
          visible: true,
          points: routeCoords,
          width: 3,
          color: Colors.green[400],
          startCap: Cap.roundCap,
          endCap: Cap.buttCap)
        );
  }

  // ! ADD A MARKER ON THE MAO
  addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId('i\'m here'),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
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

  // ! SEND REQUEST
  void sendRequest(String intendedLocation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    createRoute(route);
    notifyListeners();
  }

  // ! ON CAMERA MOVE
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

//  LOADING INITIAL POSITION
  void _loadingInitialPosition()async{
    await Future.delayed(Duration(seconds: 5)).then((v) {
      if(_initialPosition == null){
        locationServiceActive = false;
        notifyListeners();
      }
    });
  }
}
