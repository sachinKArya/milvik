import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milvik_flutter_app/common/constants.dart';
import 'package:milvik_flutter_app/common/reference.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPage extends StatefulWidget {
  final String mobileNumber;
  OtpPage({@required this.mobileNumber});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _otpController = TextEditingController();
  String _enteredOtp;
  bool _agree;
  @override
  void initState() {
    super.initState();
    _agree = false;
    _enteredOtp = "";
  }

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
              loginPageContent(_size, context),
              loginPageButton(_size),
            ],
          ),
        ),
      ),
    );
  }

  Column loginPageContent(Size _size, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "ENTER VERIFICATION CODE",
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
        PinCodeTextField(
          appContext: context,
          length: 6,
          obscureText: false,
          onChanged: (value) {
            setState(() {
              _enteredOtp = value;
            });
          },
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(
              2,
            ),
            fieldHeight: 50,
            fieldWidth: 40,
            selectedFillColor: Color(Constants.primaryDarkColor),
            borderWidth: 0,
            fieldOuterPadding: EdgeInsets.all(0),
            inactiveFillColor: Color(Constants.primaryDarkColor),
            activeFillColor: Color(Constants.primaryDarkColor),
          ),
          cursorColor: Colors.black,
          animationDuration: Duration(milliseconds: 300),
          textStyle: TextStyle(fontSize: 20, height: 1.6, color: Colors.white),
          enableActiveFill: true,
          keyboardType: TextInputType.number,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Text(
            "Please enter the verification code that was sent to ${widget.mobileNumber}",
            style: TextStyle(
                color: Colors.white,
                fontFamily: GoogleFonts.robotoCondensed().fontFamily),
          ),
        ),
      ],
    );
  }

  Widget loginPageButton(Size _size) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            minimumSize: Size(_size.width, 50),
          ),
          onPressed: (_agree && (_enteredOtp.length == 6))
              ? () async {
                  await loginRepository.submitOtp(context,
                      enteredPin: _enteredOtp,
                      verificationCode: verificationToken);
                }
              : null,
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: _agree,
              onChanged: (value) {
                setState(() {
                  _agree = value;
                });
              },
            ),
            Text.rich(
              TextSpan(
                style: TextStyle(
                    fontFamily: GoogleFonts.robotoCondensed().fontFamily,
                    fontSize: 14,
                    color: Colors.white),
                children: [
                  TextSpan(text: 'I agree to the'),
                  TextSpan(
                    text: ' Terms Of User ',
                    style: TextStyle(color: Color(Constants.accentColor)),
                  ),
                  TextSpan(text: 'and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(color: Color(Constants.accentColor)),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
