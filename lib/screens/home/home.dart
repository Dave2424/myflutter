import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myflutter/screens/home/map.dart';
import 'package:myflutter/services/google_maps_requests.dart';
import 'package:myflutter/widgets/accept_pane.dart';
import 'package:myflutter/widgets/app_state.dart';
import 'package:myflutter/widgets/arrive.dart';
import 'package:myflutter/widgets/default_pane.dart';
import 'package:myflutter/widgets/online.dart';
import 'package:myflutter/widgets/try.dart';
import 'package:permission/permission.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
        // new GoogleMapPolyline(apiKey: 'AIzaSyDPaFRwkTfLGUgDovW6ZrldT9e77mYR7sU');
        new GoogleMapPolyline(apiKey: 'AIzaSyA3whKRHle7Fv6bk4mntyUY6f70CPIFHY8');
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();String route;

  Map<PolylineId, Polyline> polylines = {};
  BitmapDescriptor pinLocationIcon;

    final descTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontFamily: 'Lato',
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
    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates('AIzaSyDPaFRwkTfLGUgDovW6ZrldT9e77mYR7sU', PointLatLng(start.latitude, start.longitude),
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates('AIzaSyA3whKRHle7Fv6bk4mntyUY6f70CPIFHY8', PointLatLng(start.latitude, start.longitude),
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

  // void _getUserLocation() async {
  //   print("GET USER METHOD RUNNING =========");
  //   Position position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   List<Placemark> placemark = await Geolocator()
  //       .placemarkFromCoordinates(position.latitude, position.longitude);
  //   _initialPosition = LatLng(position.latitude, position.longitude);
  //   print("the latitude is: ${position.longitude} and th longitude is: ${position.longitude} ");
  //   print("initial position is : ${_initialPosition.toString()}");
  //   // locationController.text = placemark[0].name;
  //   //  route = await _googleMapsServices.getRouteCoordinates(
  //   //     LatLng(6.5273, 3.3414), LatLng(6.5536, 3.3567));

  // }

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


  Widget mapSpace(BuildContext context) {
    _initialPosition = LatLng(6.5244, 3.3792);
  final appState = Provider.of<AppState>(context);
    setState(() {
    _initialPosition = appState.initialPosition;
    });
    return Scaffold(
      body: GoogleMap(
        onMapCreated: onMapCreated,
        polylines: appState.polyLines,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(6.5244, 3.3792),
          // target: appState.initialPosition??_initialPosition,
          zoom: 12.0
          ),
          mapType: MapType.normal,
          // compassEnabled: true,
          markers: appState.markers,
          zoomGesturesEnabled: true, 
          myLocationButtonEnabled: false,
        ),
      
    );
  }
  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controllers = controller;
        // this is the marker to show in the map
      // _markers.add(Marker(markerId: MarkerId(_initialPosition.toString()),
      // position: LatLng(6.4703, 3.2818),
      // infoWindow: InfoWindow(
      //   snippet: 'Good place',
      //   title: 'remember here',
      // ), icon: BitmapDescriptor.defaultMarker
      // ));
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
  

  Widget createSlideup() {

final List<String> entries = <String>['A', 'B', 'C','D','E','F'];
final List<int> colorCodes = <int>[600, 500, 100];
bool _enable = false;
    return Container(
      margin: const EdgeInsets.only(top:60),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],                
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left:10.0, right: 10.0,top: 14),
                child: Icon(Icons.search),
              ),
              Expanded(
                child: TextField(
                  keyboardType:  TextInputType.text,
                  textInputAction: TextInputAction.search,
                  cursorColor: Colors.black,
                  autofocus: false,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.black,
                    letterSpacing: .5,
                    fontWeight: FontWeight.w400,
                    fontSize: 18)
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 1),
                    hintText: 'Search address',
                    border: InputBorder.none,
                    disabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.transparent),
                      borderRadius: new BorderRadius.circular(2)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color:Colors.transparent),
                      borderRadius: new BorderRadius.circular(2)
                    )
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      _enable = true;
                      // print('Checking11111111111');
                    });
                    // FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  onTap: () {
                    setState(() {
                      // _enable = !_enable;
                    });
                  },
                ) ),
            ],
          ),
            ),
            _enable ? 
            Expanded(
              child: GhostLoader(),
            ) :
          Expanded(
            child: Column(
              mainAxisSize:  MainAxisSize.max,
              children: <Widget>[
                // GhostLoader(),
                ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Card(
                      color: Colors.white,
                      elevation: 2.0,
                      child: InkWell(
                        onTap: () {
                          print('Home address pressed');
                        },
                        child: ListTile(
                          leading: Icon(Icons.home),
                          title: Text('15B aLhaji street lekki phrase1, Lagos',style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.black,
                              letterSpacing: .5,
                              fontSize: 14)
                            ),
                      ),
                        ),
                      ),
                    ),
                  Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: InkWell(
                      onTap: () {
                          print('Workplace pressed');
                        },
                      child: ListTile(
                        leading: Icon(Icons.business),
                        title: Text('Orinu Estate VI, Lagos',style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.black,
                            letterSpacing: .5,
                            fontSize: 14)
                          ),
                    ),),
                    ),
                  ),
                    ],
                  
                ),
                Expanded(
                      child: ListView.separated(
                      itemCount: entries.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 2.0,
                          child: InkWell(
                            onTap: () {
                              print('Histroy--$index clicked');
                            },
                              child: ListTile(
                              leading: Icon(Icons.access_time),
                              title: Text('Apha beach, Lagos',style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.black,
                              letterSpacing: .5,
                              fontSize: 14)
                              ),
                            ),
                        ),
                          )
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    ),
                )
              ],
              ),
          ),
        ],
      )
    );
  }

  Widget GhostLoader() {
    return Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: true,
                child: ListView.builder(
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48.0,
                          height: 48.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 40.0,
                                height: 8.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  itemCount: 4,
                ),
              ),
            ),
          ],
        ),
      );
  }
  
  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenWidth = screenWidth/7;

     BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0),
  );
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: GestureDetector(
        child: Container(
          margin: const EdgeInsets.fromLTRB(5, 100, 0, 0),
        //   new Theme(
        // data: new ThemeData(
        //   accentColor: Colors.transparent,
        // ),
          child: FloatingActionButton(
          child: AnimatedIcon(icon: AnimatedIcons.menu_close, progress: _iconController, size: 22),
          elevation: 0.0, 
          backgroundColor: Colors.transparent,
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
            // Try(),
            mapSpace(context),
            _status == true ? onlinebutton() : offlinebutton(),
           SlidingUpPanel(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          minHeight: MediaQuery.of(context).size.height/8,
          backdropEnabled: true,
             collapsed: Container( 
               decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: radius
                ),
                child: Center(
                  child: Text(
                    "Let\'s find a doctor",
                    style: 
                          GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.black,
                        letterSpacing: .5,
                        // fontWeight: FontWeight.bold,
                        fontSize: 23),
                      )
                  ),
                ),
              ),
              borderRadius: radius,
              header: Container(
                padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  color: Colors.blue[400]
                ),
                
                alignment: Alignment.center,
                  child: Text('Where do you want a doctor?',
                  style:GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.white,
                        letterSpacing: .5,
                        // fontWeight: FontWeight.bold,
                        fontSize: 20),
                      )
                    ),
              ),
              panel:  
              createSlideup(),
              // GhostLoader()
            
                
        )
            // Try(),
            // Default(),
            // onlineTicket(screenWidth),
            // onlinebutton(),
            // offlinebutton(),
            // onlinePane(_tween, _controller, _height, descTextStyle, nameTextStyle),
            // textPane(_tween, _controller, 0.3, descTextStyle, nameTextStyle),
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
                color: Colors.blue[400],
              ),
              accountName: Text("Marcelo Augusto Elias"),
              accountEmail: Text("Matrícula: 5046850"),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue[400]
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
