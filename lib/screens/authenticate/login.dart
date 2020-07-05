import 'package:flutter/material.dart';
import 'package:myflutter/screens/home/home.dart';
import 'package:myflutter/screens/home/map.dart';
import 'package:myflutter/services/auth.dart';
import 'package:myflutter/widgets/signupWidget.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

double screenHeight;
double screenWidth;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {

    // final navigatorstate 
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    // RouteFactory onGenerateRoute;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            lowerHalf(context),
            upperHalf(context),
            loginCard(context)
          ],
        ),
      ),
    );
  }
  Widget loginCard(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 4),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('Login', 
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Your email',
                      hasFloatingPlaceholder: true
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hasFloatingPlaceholder: true
                    ),

                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(onPressed: (){

                      },
                      child: Text('Forgot Password'),
                      
                      ),
                      Expanded(
                        child: Container(),
                        ),
                        FlatButton(onPressed: () async {

                          Navigator.push(
                            context,
                            // MaterialPageRoute(builder: (context) => WelcomPage()),
                            MaterialPageRoute(builder: (context) => Home()),
                          );

                        // dynamic result =  await _authService.signInAnon();
                        // if (result == null) {
                        //   print('error siginig in');
                        // } else {
                        //   print('signed in');
                        //   // print(result.uid);
                        // }

                        },
                        child: Text('Login'),
                        color: Colors.blue[800],
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                          left: 38,
                          right: 38,
                          top: 15,
                          bottom: 15
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                        
                        )
                    ],
                  )
                ],
              ),
              ),
            
          ),
          
          
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text('Dont have an account ?', 
              style: TextStyle(color: Colors.grey),),
              FlatButton(onPressed: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );

              },
              textColor: Colors.black87,
              child: Text('Create Account'))
          ],
          )
      ],
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/bg.jpg',
        fit: BoxFit.cover,
        width: screenWidth,
        ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight / 2,
        color: Color(0xFFECF0F3),
      ),
    );
  }
}