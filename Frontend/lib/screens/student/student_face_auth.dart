import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wifi_attendance_app/constants/api.dart';
import 'package:wifi_attendance_app/models%20&%20providers/user_data.dart';
import 'package:wifi_attendance_app/screens/student/student_confirmation_screen.dart';
// import 'package:wifi_attendance_app/widgets/custom_alert_box.dart';

class StudentFaceAuth extends StatefulWidget {
  const StudentFaceAuth({super.key});
  static const routeName = 'StudentFaceAuth';

  @override
  State<StudentFaceAuth> createState() => _StudentFaceAuthState();
}

class _StudentFaceAuthState extends State<StudentFaceAuth> {
  late final LocalAuthentication auth;
  late Map<String, dynamic> student;
  late String subject;
  bool _supportState = false;
  bool isAuthenticated = false;
  var date;
  var time;

  Future<void> Attendance() async {
    student = Provider.of<Data>(context, listen: false).student;
    subject = Provider.of<Data>(context, listen: false).SubjectName;
    final String endpoint = 'create_attendance';
    final Uri uri = Uri.parse('$api/api/$endpoint');
    int enrollment_no = student['enrollment_no'];
    int semester = student['semester'];
    String branch = student['branch'];
    String status = 'Present';
    date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    time = DateTime.now().toIso8601String().substring(11, 19);

    Map body = {
      'enrollment_no': enrollment_no,
      'date': date,
      'time': time,
      'status': status,
      'subject': subject,
      'branch': branch,
      'semester': semester,
    };

    try {
      http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        StudentConfirmationScreen.routeName,
        (Route<dynamic> route) => false,
      );
      print('Success');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(
          () {
            _supportState = isSupported;
          },
        ));
    Timer(Duration(seconds: 1), () {
      _authenticate().then((isAuthenticated) {
        if (isAuthenticated) {
          Attendance();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lotties/face.json'),
          ],
        ),
      ),
    );
  }

  Future<bool> _authenticate() async {
    try {
      return await auth.authenticate(
          localizedReason: 'Authentication for mark attendance',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
            useErrorDialogs: true,
          ));
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}
