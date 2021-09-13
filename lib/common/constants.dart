import 'package:flutter/material.dart';

class Constants {
  static final String doctorListApiUrl =
      'https://5efdb0b9dd373900160b35e2.mockapi.io/contacts';
  static final int primaryColor = 0xFF015ECB;
  static final int primaryDarkColor = 0xFF2F579F;
  static final int accentColor = 0xFFFAB206;
  static final mobileFieldStyle = UnderlineInputBorder(
    // borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: Colors.white,
      width: 1,
    ),
  );
}
