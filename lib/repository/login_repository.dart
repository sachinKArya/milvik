import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flushbar/flushbar.dart';
import 'package:milvik_flutter_app/common/reference.dart';
import 'package:flutter/material.dart';
import 'package:milvik_flutter_app/ui/dashboard_page.dart';
import 'package:milvik_flutter_app/ui/otp_page.dart';

class LoginRepository {
  Future registerUser(String mobile, BuildContext context) async {
    await Firebase.initializeApp();
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpPage(
              mobileNumber: mobile,
            ),
          ),
        );
      },
      verificationFailed: (authException) {
        print(authException.message);
      },
      codeSent: (verificationID, a) async {
        print(verificationID);
        print(a);
        verificationToken = verificationID;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpPage(
              mobileNumber: mobile,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("verificationId : $verificationId");
      },
    );
  }

  Future submitOtp(
    BuildContext context, {
    String verificationCode,
    String enteredPin,
  }) async {
    if (enteredPin.length == 6) {
      try {
        AuthCredential _authCredential = PhoneAuthProvider.credential(
            verificationId: verificationCode, smsCode: enteredPin);
        firebaseAuth.signInWithCredential(_authCredential).then((value) async {
          if (value.user != null) {
            print("Login Successful");
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => DashboardPage()),
                (Route<dynamic> route) => false);
            verificationToken = "";
          }
          ;
        });
      } catch (e) {
        print(e.toString());
        Flushbar(
          title: "Otp Verification",
          message: "Otp is incorrect or already been used.",
          duration: Duration(seconds: 3),
        )..show(context);
      }
    }
  }
}
