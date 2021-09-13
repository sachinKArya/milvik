import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milvik_flutter_app/common/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final picker = ImagePicker();

class ProfilePage extends StatefulWidget {
  final Map doctorDetails;
  ProfilePage({
    @required this.doctorDetails,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _showLoader = false;
  bool editable = false;
  bool _updatedProfilePic = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  File croppedFile;

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.doctorDetails['first_name'];
    lastNameController.text = widget.doctorDetails['last_name'];
    contactNumberController.text = widget.doctorDetails['primary_contact_no'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(Constants.primaryColor),
        body: ModalProgressHUD(
          inAsyncCall: _showLoader,
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                    top: 50,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        12,
                      ),
                      topRight: Radius.circular(
                        12,
                      ),
                    ),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 50,
                          left: MediaQuery.of(context).size.width / 2 - 100,
                          right: MediaQuery.of(context).size.width / 2 - 100,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            minimumSize: Size(100, 50),
                          ),
                          onPressed: () {
                            setState(() {
                              editable = true;
                            });
                          },
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey.shade100,
                        margin: EdgeInsets.only(
                          top: 20,
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PERSONAL DETAILS",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextInputBox(
                                labelName: "FIRST NAME",
                                controller: firstNameController,
                                editable: editable,
                              ),
                              CustomTextInputBox(
                                labelName: "LAST NAME",
                                controller: lastNameController,
                                editable: editable,
                              ),
                              CustomTextInputBox(
                                labelName: "GENDER",
                                controller: genderController,
                                editable: editable,
                              ),
                              CustomTextInputBox(
                                labelName: "CONTACT NUMBER",
                                controller: contactNumberController,
                              ),
                              CustomTextInputBox(
                                labelName: "GENDER",
                                controller: genderController,
                                editable: editable,
                              ),
                              CustomTextInputBox(
                                labelName: "CONTACT NUMBER",
                                controller: contactNumberController,
                              ),
                              Text(
                                "DATE OF BIRTH",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              dateOfBirthWidget(context),
                              SizedBox(
                                height: 20,
                              ),
                              // bottomWidget(context),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      InkWell(
                        child: _updatedProfilePic
                            ? CircleAvatar(
                                backgroundImage: FileImage(
                                croppedFile,
                              ))
                            : CachedNetworkImage(
                                imageUrl: widget.doctorDetails["profile_pic"],
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  backgroundImage: imageProvider,
                                  radius: 45,
                                ),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/bima_logo.png"),
                                ),
                                fit: BoxFit.fill,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      strokeWidth: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                        onTap: () async {
                          var result = await showCupertinoModalPopup(
                            context: context,
                            builder: (context) => myActionSheet(context),
                          );
                          if (result != null) {
                            setState(() {
                              _showLoader = true;
                            });
                            await updateProfilePhoto(context, result);
                            setState(() {
                              _showLoader = false;
                            });
                          }
                        },
                      ),
                      // CircleAvatar(
                      //   backgroundImage: NetworkImage(
                      //     (appUser.profilePhoto != null)
                      //         ? appUser.profilePhoto
                      //         : Constants.defaultProfileImagePath,
                      //   ),
                      //   radius: ScreenUtil()
                      //       .setSp(36, ),
                      // ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color(Constants.accentColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row dateOfBirthWidget(BuildContext context) {
    TextStyle _labelStyle = TextStyle(color: Colors.grey);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: MediaQuery.of(context).size.width / 4,
          width: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined),
                  Text(
                    "DAY ",
                    style: _labelStyle,
                  )
                ],
              ),
              Text("28")
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width / 4,
          width: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined),
                  Text(
                    "MONTH",
                    style: _labelStyle,
                  )
                ],
              ),
              Text("JUNE")
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width / 4,
          width: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined),
                  Text(
                    "YEAR",
                    style: _labelStyle,
                  )
                ],
              ),
              Text("1996")
            ],
          ),
        ),
      ],
    );
  }

  Row bottomWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: MediaQuery.of(context).size.width / 4,
          width: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined),
                  Text("BLOOD GROUP")
                ],
              ),
              CustomTextInputBox(
                labelName: "GENDER",
                controller: genderController,
                editable: editable,
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width / 4,
          width: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.calendar_today_outlined), Text("MONTH")],
              ),
              Text("JUNE")
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width / 4,
          width: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined),
                  Text(
                    "YEAR",
                  )
                ],
              ),
              Text("1996")
            ],
          ),
        ),
      ],
    );
  }

  Future updateProfilePhoto(BuildContext context, String imageSource) async {
    try {
      var pickedFile;
      if (imageSource == "Camera") {
        print("Open Camera");
        pickedFile = await picker.getImage(source: ImageSource.camera);
      } else if (imageSource == "Gallery") {
        print("Open Gallery");
        pickedFile = await picker.getImage(source: ImageSource.gallery);
      }
      if (pickedFile != null && pickedFile.path != null) {
        croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
          maxWidth: 512,
          maxHeight: 512,
        );
        setState(() {
          _updatedProfilePic = true;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class CustomTextInputBox extends StatelessWidget {
  final String labelName;
  final TextEditingController controller;
  final bool editable;
  CustomTextInputBox({this.labelName, this.controller, this.editable});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10),
        child: TextField(
          controller: controller,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          enabled: editable,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: labelName,
            labelStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ),
    );
  }
}

myActionSheet(context) {
  return CupertinoActionSheet(
    actions: [
      CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop("Camera");
        },
        child: Text("Take Photo"),
      ),
      CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop("Gallery");
        },
        child: Text("Choose Photo from Gallery"),
      ),
    ],
    cancelButton: CupertinoActionSheetAction(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text("Cancel"),
    ),
  );
}
