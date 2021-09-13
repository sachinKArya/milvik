import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:milvik_flutter_app/common/constants.dart';
import 'package:milvik_flutter_app/common/reference.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _mobileNumberController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String fullMobileNumber = "";

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(Constants.primaryColor),
      body: SingleChildScrollView(
        child: Container(
          height: _size.height,
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 120,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              loginPageContent(_size),
              loginPageButton(_size, context),
            ],
          ),
        ),
      ),
    );
  }

  Column loginPageContent(Size _size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "ENTER YOUR MOBILE NUMBER",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.robotoCondensed().fontFamily,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        IntlPhoneField(
          controller: _mobileNumberController,
          decoration: InputDecoration(
            hintText: 'Phone Number',
            enabledBorder: Constants.mobileFieldStyle,
            focusedBorder: Constants.mobileFieldStyle,
            hintStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
            suffixIcon: IconButton(
              onPressed: () {
                _mobileNumberController.text = "";
              },
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
            ),
          ),
          onChanged: (phone) {
            print(phone.completeNumber);
            fullMobileNumber = phone.completeNumber;
          },
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          keyboardType: TextInputType.number,
          initialCountryCode: 'IN',
          countryCodeTextColor: Colors.white,
          dropDownIcon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
          showCountryFlag: false,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Text(
            "We will send you an SMS with the verification code to this number",
            style: TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.robotoCondensed().fontFamily),
          ),
        ),
      ],
    );
  }

  Widget loginPageButton(Size _size, context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        minimumSize: Size(_size.width, 50),
      ),
      onPressed: (_mobileNumberController.text.length == 10)
          ? () async {
              loginRepository.registerUser(fullMobileNumber, context);
            }
          : null,
      child: Text(
        "Continue",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}
