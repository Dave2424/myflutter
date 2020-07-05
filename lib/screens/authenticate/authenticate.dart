import 'package:flutter/material.dart';
import 'package:myflutter/screens/authenticate/login.dart';
import 'package:myflutter/widgets/map_pane.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginPage(),
      // child: Mymap(),
    );
  }
}
