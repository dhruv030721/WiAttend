import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wifi_attendance_app/constants/api.dart';
import 'package:wifi_attendance_app/screens/student/student_face_auth.dart';
import 'package:wifi_attendance_app/widgets/custom_alert_box.dart';

class WifiAuth extends StatefulWidget {
  const WifiAuth({Key? key}) : super(key: key);

  static const routeName = '/StudentWifiAuth';

  @override
  State<WifiAuth> createState() => _WifiAuthState();
}

class _WifiAuthState extends State<WifiAuth> {
  late Future<String> ip;

  void _showErrorDialog(String message, int? responsecode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: (responsecode == 102)
              ? ''
              : (responsecode == 200) || (responsecode == 201)
                  ? ''
                  : 'Error',
          message: message,
          status_code: responsecode,
        );
      },
    );
  }

  String? IPmodification(String? wifiIP) {
    String? originalString = wifiIP;

    // Find the second-to-last dot in the string
    int? lastIndex =
        originalString?.lastIndexOf('.', originalString.lastIndexOf('.') - 1);

    // Check if a dot was found and extract the substring accordingly
    if (lastIndex != -1) {
      String? slicedString = originalString?.substring(0, lastIndex);
      print(slicedString); // Output: 192.168
      return slicedString;
    }
    return wifiIP;
  }

  Future<String> getPublicIP() async {
    var response =
        await http.get(Uri.parse('https://api.ipify.org?format=json'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> data = jsonDecode(response.body);
      String ip = data['ip'];
      print(ip);
      return ip;
    } else {
      throw Exception('Failed to load IP address');
    }
  }

  Future<void> Auth(String ip) async {
    final String endpoint = 'wifiauth';
    var originalip = IPmodification(ip);
    final Uri uri = Uri.parse('$api/api/$endpoint/$originalip');
    try {
      http.Response response = await http.get(uri);

      Map<String, dynamic> decodeddata = json.decode(response.body);

      if (response.statusCode == 200) {
        _showErrorDialog(decodeddata['message'], response.statusCode);
        Future.delayed(Duration(milliseconds: 1500), () {
          Navigator.of(context).pushReplacementNamed(StudentFaceAuth.routeName);
        });
      } else {
        _showErrorDialog(decodeddata['message'], response.statusCode);
      }
    } catch (e) {
      _showErrorDialog("$e", null);
    }
  }

  @override
  void initState() {
    ip = getPublicIP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder<String>(
        future: ip,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            Auth(snapshot.data!);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.4,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Lottie.asset('assets/lotties/wifi.json'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Wi-Fi Credentials Checking',
                        style: TextStyle(
                          color: Color.fromRGBO(24, 119, 242, 1),
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Lottie.asset(
                        'assets/lotties/dot loading.json',
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.02,
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
