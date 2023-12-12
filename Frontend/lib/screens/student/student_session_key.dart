import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wifi_attendance_app/constants/api.dart';
import 'package:wifi_attendance_app/models%20&%20providers/user_data.dart';
import 'package:wifi_attendance_app/screens/student/student_wifi_auth_screen.dart';
import 'package:wifi_attendance_app/widgets/button.dart';
import 'package:wifi_attendance_app/widgets/custom_alert_box.dart';
import 'package:wifi_attendance_app/widgets/input_text_field.dart';
import 'package:http/http.dart' as http;

class SessionKeyScreen extends StatefulWidget {
  SessionKeyScreen({super.key});

  @override
  State<SessionKeyScreen> createState() => _SessionKeyScreenState();
}

class _SessionKeyScreenState extends State<SessionKeyScreen> {
  final TextEditingController _sessionKey = TextEditingController();

  void _showErrorDialog(String message, int? responsecode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: (responsecode == 200) ||
                  (responsecode == 201) ||
                  (responsecode == 102)
              ? ''
              : 'Error',
          message: message,
          status_code: responsecode,
        );
      },
    );
  }

  Future<void> Auth() async {
    String sessionKey = _sessionKey.text;
    final String endpoint = 'sessionauth';
    final Uri uri = Uri.parse('$api/api/$endpoint/$sessionKey');
    _showErrorDialog("Processing...", 102);
    try {
      http.Response response = await http.get(uri);
      Map<String, dynamic> decodeddata = json.decode(response.body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        _showErrorDialog(decodeddata['message'], response.statusCode);
        Future.delayed(Duration(milliseconds: 1000), () {
          Provider.of<Data>(context, listen: false)
              .addSubjectName(decodeddata['data']);
          Navigator.of(context).pushReplacementNamed(WifiAuth.routeName);
        });
      } else {
        Navigator.of(context).pop();
        _showErrorDialog(decodeddata['message'], response.statusCode);
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog("$e", null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset('assets/lotties/sessionpassword.json',
            height: MediaQuery.of(context).size.height * 0.3),
        Text(
          'Please Enter Your Session Key : ',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontSize: MediaQuery.of(context).size.height * 0.02),
        ),
        InputTextField(
            text: 'Session Key',
            preicon: Icons.lock,
            InputController: _sessionKey),
        Button(
            btnName: "Verify",
            Navigator: Auth,
            colors: Theme.of(context).secondaryHeaderColor),
      ],
    );
  }
}
