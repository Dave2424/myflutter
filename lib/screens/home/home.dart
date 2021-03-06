import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myflutter/screens/home/map.dart';
import 'package:myflutter/services/google_maps_requests.dart';
import 'package:myflutter/widgets/accept_pane.dart';
import 'package:myflutter/widgets/app_state.dart';
import 'package:myflutter/widgets/arrive.dart';
import 'package:myflutter/widgets/default_pane.dart';
import 'package:myflutter/widgets/online.dart';
import 'package:permission/permission.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(),
      // home: MapSample(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  AnimationController _controller, _iconController;
  BorderRadiusTween borderRadius;
  Duration _duration = Duration(milliseconds: 500);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  double _height, min = 0.3, initial = 0.4, max = 1;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController _controllers;
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  final Set<Marker> _markers = {};
  //Polyline in map
  final Set<Polyline> polyline = {};

  // var _initialPosition = LatLng(6.5273, 3.3414);
  // var _destinationPosition = LatLng(6.5273, 3.3414);
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition; 
  List<LatLng> routeCoords;
  PolylinePoints polylinePoints = PolylinePoints();
  GoogleMapPolyline googleMapPolyline =  
        new GoogleMapPolyline(apiKey: 'AIzaSyDPaFRwkTfLGUgDovW6ZrldT9e77mYR7sU');
        // new GoogleMapPolyline(apiKey: 'AIzaSyA3whKRHle7Fv6bk4mntyUY6f70CPIFHY8');
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();String route;

  Map<PolylineId, Polyline> polylines = {};
  BitmapDescriptor pinLocationIcon;

    final descTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 18,
    height: 2,
  );

    final nameTextStyle = TextStyle(
    color: Colors.black54,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 18,
    height: 2,
  );
    final topTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Roboto',
    letterSpacing: 0.5,
    fontSize: 18,
  );
  double screenWidth;


  bool _status = true;
   Uint8List markerIcon;


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
    }
  }

  _createPolyline(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates('AIzaSyDPaFRwkTfLGUgDovW6ZrldT9e77mYR7sU', PointLatLng(start.latitude, start.longitude),
    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates('AIzaSyA3whKRHle7Fv6bk4mntyUY6f70CPIFHY8', PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),

      travelMode: TravelMode.transit);

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          routeCoords.add(LatLng(point.latitude, point.longitude));
        });
      }

      PolylineId id =  PolylineId('poly');

      Polyline polyline = Polyline(polylineId: id, color: Colors.red, points: routeCoords, width: 3);
      polylines[id] = polyline;
  }

  void _getUserLocation() async {
    print("GET USER METHOD RUNNING =========");
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    print("the latitude is: ${position.longitude} and th longitude is: ${position.longitude} ");
    print("initial position is : ${_initialPosition.toString()}");
    // locationController.text = placemark[0].name;
    //  route = await _googleMapsServices.getRouteCoordinates(
    //     LatLng(6.5273, 3.3414), LatLng(6.5536, 3.3567));

  }
  getImage(){

    setState(()  async {
      
    markerIcon = await getBytesFromAsset('assets/images/doctor.png', 50);
    });
  }
  @override
  void initState() {
    super.initState();
      // getsomePoints();
    // _getUserLocation();
    _controller = AnimationController(vsync: this, duration: _duration);
    _iconController = AnimationController(vsync: this, duration: _duration);
    borderRadius = BorderRadiusTween(
      begin: BorderRadius.circular(10.0),
      end: BorderRadius.circular(0.0),
    );

      _controller.forward();//changing the state of the footer show


  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
}

  Widget mapSpace(BuildContext context) {
  final appState = Provider.of<AppState>(context);
  // appState.
  // routeCoords = appState.getsomePoints();
    return Scaffold(
      body: GoogleMap(
        onMapCreated: onMapCreated,
        polylines: appState.polyLines,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(6.524379, 3.379206),
          zoom: 14.0
          ),
          mapType: MapType.normal,
          // compassEnabled: true,
          markers: Set.of(_markers),       
        ),
      
    );
  }
  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controllers = controller;
        // this is the marker to show in the map
      _markers.add(Marker(markerId: MarkerId(_initialPosition.toString()),
      position: LatLng(6.5536, 3.3567),
      infoWindow: InfoWindow(
        snippet: 'Good place',
        title: 'remember here',
      ), icon: BitmapDescriptor.fromBytes(markerIcon)
      ));
    });
  }

  Widget onlineTicket(screenWidth) {
    return Row(children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                children: <Widget>[
                  Container( 
                    height: 60,
                    width: 150,
                    margin: const EdgeInsets.fromLTRB(110, 27, 0, 0),
                    padding: const EdgeInsets.fromLTRB(24,0,0,0), //Online
                    decoration: new BoxDecoration(
                      color: Colors.blue[300], // for Online
                      // color: Colors.grey[350], // for offline
                      borderRadius: new BorderRadius.all(Radius.elliptical(50, 50)),
                          ),
                    child: Row(
                      mainAxisAlignment:  MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Online', style: topTextStyle,), // Online
                        Container(
                          padding: EdgeInsets.all(7),
                          margin: EdgeInsets.fromLTRB(7, 0, 0, 0), //Online
                          height: 70,
                          width: 70,
                          child: 
                            ClipRRect(
                            borderRadius: BorderRadius.circular(70.0),
                            child: Image.asset('assets/doctor.png',
                            fit: BoxFit.fill,
                                height:0.0,
                                width: 70.0,
                            ),
                        )
                        ),
                      ],
                    ),
                  )
                ],
              ),

                  ),
        
      ],
    );
  }

  Widget onlinebutton () {
    return Container(
        width: 150,
        height: 50,
        margin: const EdgeInsets.fromLTRB(110, 27, 0, 0),
        padding: const EdgeInsets.fromLTRB(10,0,0,0), //Online
      child: 
    RaisedButton(
          onPressed: () => {
              setState(() {
                _status = !_status;
              })
          },
          color: Colors.blue[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.blue[400])
          ),
          child: Row( // Replace with a Row for horizontal icon + text
            children: <Widget>[
                Text("Online", style: TextStyle(color: Colors.white, fontSize: 18),),
                SizedBox(width: 20), 
                  SizedBox(
                    width: 40,
                        child: CircleAvatar(
                            backgroundImage: AssetImage("assets/doctor.png"),
                          )
                        )
            ],
          ),
        ),
    );
  }

  Widget offlinebutton() {
    return Container(
        width: 150,
        height: 50,
        margin: const EdgeInsets.fromLTRB(110, 27, 0, 0),
        padding: const EdgeInsets.fromLTRB(10,0,0,0), //Online
      child: 
    RaisedButton(
          onPressed: () => {
              setState(() {
                _status = !_status;
              })
          },
          color: Colors.grey[350],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.grey[350])
          ),
          child: Row( 
            children: <Widget>[
                  SizedBox(
                    width: 40,
                        child: CircleAvatar(
                            backgroundImage: AssetImage("assets/doctor.png"),
                          )
                        ),
                SizedBox(width: 17), 
                Text("Offline", style: TextStyle(color: Colors.white, fontSize: 18),),
            ],
          ),
        ),
    );
  }
  
  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenWidth = screenWidth/7;
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: GestureDetector(
        child: Container(
          margin: const EdgeInsets.fromLTRB(5, 100, 0, 0),
          child: FloatingActionButton(
          child: AnimatedIcon(icon: AnimatedIcons.menu_close, progress: _iconController, size: 22),
          elevation: 8, 
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,          

          onPressed: () async {
          _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            mapSpace(context),
            _status == true ? onlinebutton() : offlinebutton(),
            // onlineTicket(screenWidth),
            // onlinebutton(),
            // offlinebutton(),
            // onlinePane(_tween, _controller, _height, descTextStyle, nameTextStyle),
            // textPane(_tween, _controller, _height, descTextStyle, nameTextStyle),
            // acceptPane(_tween, _controller, _height, descTextStyle, nameTextStyle)
            // arrivePane(_tween, _controller, _height, descTextStyle, nameTextStyle)

          ],
        ),
      ),
      drawer: Container(
      // width: 350,
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader (
              decoration: BoxDecoration(
                color: new Color(0xFF0062ac),
              ),
              accountName: Text("Marcelo Augusto Elias"),
              accountEmail: Text("Matrícula: 5046850"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? new Color(0xFF0062ac)
                        : Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              dense: true,
              title: Text("Home",
                style: TextStyle(fontSize: 16),),
              leading: Icon(Icons.home, size: 30,
              ),
            ),
            SizedBox(height: 10),
            
            ListTile(onTap: (){
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => Contracheques()),
              // );
            },
              dense: true,
              title: Text("Summary",
                style: TextStyle(fontSize: 16),),
              leading: Icon(Icons.content_paste, size: 30,
              ),
            ),
            SizedBox(height: 10),
            ListTile(onTap: (){
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => AutorizacaoEmprestimos()),
              // );
            },
              dense: true,
              title: Text("My Subscriptions",
                style: TextStyle(fontSize: 16),),
              leading: Icon(Icons.local_activity, size: 30,
              ),
            ),
            SizedBox(height: 10),
            ListTile(onTap: (){

            },
              dense: true,
              title: Text("notification",
                style: TextStyle(fontSize: 16),),
              leading: Icon(Icons.notifications, size: 30,
              ),
            ),
            SizedBox(height: 10),
            ListTile(onTap: (){
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => HistoricoConsignacoes()),
              // );
            },
              dense: true,
              title: Text("Settings",
                style: TextStyle(fontSize: 16),),
              leading: Icon(Icons.settings, size: 30,
              ),
            ),
            SizedBox(height: 10),
            ListTile(onTap: (){
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => ConsultaMargem()),
              // );
            },
              dense: true,
              title: Text("Logout",
                style: TextStyle(fontSize: 16),),
              leading: Icon(Icons.power_settings_new, size: 30,
              ),
            ),
          ],
        ),
      
      ),
      ),
    );
  }
  
  _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
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

}
