import 'package:flutter/material.dart';
import 'package:myflutter/screens/authenticate/authenticate.dart';
import 'package:myflutter/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    // return either home or authentication widget
    return Authenticate();
  }
}