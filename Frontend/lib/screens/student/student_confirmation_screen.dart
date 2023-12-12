import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wifi_attendance_app/screens/student/student_tabbar_screen.dart';

class StudentConfirmationScreen extends StatefulWidget {
  const StudentConfirmationScreen({super.key});

  static const routeName = '/AttendanceConfirmation';

  @override
  State<StudentConfirmationScreen> createState() =>
      _StudentConfirmationScreenState();
}

class _StudentConfirmationScreenState extends State<StudentConfirmationScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1000), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
        StudentTabBarScreen.routeName,
        (Route<dynamic> route) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lotties/attendconfirm.json',
                frameRate: FrameRate(120)),
          ],
        ),
      ),
    );
  }
}
