import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milvik_flutter_app/common/constants.dart';
import 'package:milvik_flutter_app/ui/dashboard_page.dart';
import 'package:milvik_flutter_app/ui/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(Constants.primaryColor),
        statusBarIconBrightness: Brightness.light,
        // set Status bar icons color in Android devices.
        statusBarBrightness: Brightness.light,
        //set Status bar icon color in iOS.
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
      home: LoginPage(),
    );
  }
}
