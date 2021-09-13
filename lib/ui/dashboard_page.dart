import 'package:flutter/material.dart';
import 'package:milvik_flutter_app/common/constants.dart';
import 'package:milvik_flutter_app/common/reference.dart';
import 'package:milvik_flutter_app/custom_widget/doctor_tile.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(Constants.primaryDarkColor)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: _size.width * 0.3,
                child: Image.asset(
                  "assets/images/bima_doctor.png",
                )),
            Container(
              width: _size.width * 0.3,
              child: Image.asset(
                "assets/images/bima_logo.png",
              ),
            ),
          ],
        ),
        titleSpacing: 0.0,
      ),
      drawer: Drawer(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: FutureBuilder(
            future: dashboardRepository.fetchDoctorsList(),
            builder: (context, doctorDetails) {
              if (doctorDetails.connectionState == ConnectionState.done &&
                  doctorDetails.data == null) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    "No data available.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                );
              } else if (doctorDetails.hasData) {
                return ListView.separated(
                  itemCount: doctorDetails.data.length,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return DoctorsTile(doctorDetails: doctorDetails.data[index],);
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
