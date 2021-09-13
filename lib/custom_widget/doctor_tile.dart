import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milvik_flutter_app/common/constants.dart';
import 'package:milvik_flutter_app/ui/profile_page.dart';

class DoctorsTile extends StatelessWidget {
  final Map doctorDetails;
  DoctorsTile({
    @required this.doctorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              doctorDetails: doctorDetails,
            ),
          ),
        );
      },
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            height: 52,
            width: 52,
            imageUrl: doctorDetails["profile_pic"],
            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundImage: imageProvider,
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              backgroundImage: AssetImage("assets/images/bima_logo.png"),
            ),
            fit: BoxFit.fill,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
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
        ],
      ),
      title: Text(
        doctorDetails["first_name"] + " " + doctorDetails["last_name"],
        style: TextStyle(
            color: Color(Constants.primaryColor),
            fontWeight: FontWeight.bold,
            fontSize: 14),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_forward_ios,
            color: Color(Constants.primaryColor),
            size: 20,
          ),
        ],
      ),
      subtitle: Text.rich(
        TextSpan(
          style: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
          ),
          children: [
            TextSpan(
              text: doctorDetails["specialization"],
              style: TextStyle(
                color: Color(Constants.primaryColor),
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: '\n${doctorDetails["description"]}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
