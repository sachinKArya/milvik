import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:milvik_flutter_app/common/constants.dart';

class DashboardRepository {
  Future fetchDoctorsList() async {
    try {
    var url = Uri.parse(Constants.doctorListApiUrl);
    http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }
}
