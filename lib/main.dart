import 'package:flutter/material.dart';
import 'package:myflutter/widgets/app_state.dart';
import 'package:provider/provider.dart';
import 'package:myflutter/screens/wrapper.dart';

// void main() => runApp(
  
//   MyApp());

  void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(
  MultiProvider(providers: [
      ChangeNotifierProvider.value(value: AppState(),)
  ],
  child: MyApp(),));
}
//   void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   return runApp( MyApp(),);
// }

// enum AuthMode {LOGIN, SINGUP}

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}