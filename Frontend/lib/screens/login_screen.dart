import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_attendance_app/constants/api.dart';
import 'package:wifi_attendance_app/models%20&%20providers/user_data.dart';
import 'package:wifi_attendance_app/screens/faculty/faculty_tabbar_screen.dart';
import 'package:wifi_attendance_app/screens/signup_screen.dart';
import 'package:wifi_attendance_app/screens/student/student_tabbar_screen.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_attendance_app/widgets/button.dart';
import 'package:wifi_attendance_app/widgets/custom_alert_box.dart';
import 'package:wifi_attendance_app/widgets/input_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _enrollment_noController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

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

  Future<void> Navigation() async {
    final String endpoint = 'login';
    final Uri uri = Uri.parse('$api/api/$endpoint');

    String enrollment_no = _enrollment_noController.text;
    String password = _passwordController.text;

    Map body = {'username': enrollment_no, 'password': password};

    _showErrorDialog("Processing...", 102);
    try {
      http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      Map<String, dynamic> decodeddata = json.decode(response.body);
      print(response.statusCode);
      print(decodeddata['message']);
      if (response.statusCode == 200) {
        print(decodeddata['data']['role']);
        if (decodeddata['data']['role'] == "student") {
          Provider.of<Data>(context, listen: false)
              .addStudent(decodeddata['data']);
          Navigator.of(context).pop();
          _showErrorDialog('Login Successful', response.statusCode);
          Future.delayed(Duration(milliseconds: 2000), () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              StudentTabBarScreen.routeName,
              (Route<dynamic> route) => false,
            );
          });
          // # <------------------ For Faculty ------------------>
        } else {
          Provider.of<Data>(context, listen: false)
              .addFaculty(decodeddata['data']);
          _showErrorDialog('Login Successful', response.statusCode);
          Future.delayed(Duration(milliseconds: 1500), () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                FacultyTabBarScreen.routeName, (Route<dynamic> route) => false);
          });
        }
      } else {
        Navigator.of(context).pop();
        _showErrorDialog(decodeddata['message'], response.statusCode);
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog("Server timeout", null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset('assets/images/signup.png',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(80, 60),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                    InputTextField(
                        text: "Username",
                        preicon: Icons.person_rounded,
                        InputController: _enrollment_noController),
                    InputTextField(
                      text: "Password",
                      preicon: Icons.key_rounded,
                      InputController: _passwordController,
                      suficon:
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                      obscureText: _isObscure,
                      onTap: _toggleObscure,
                    ),
                    Button(
                      btnName: 'Login',
                      Navigator: Navigation,
                      colors: Theme.of(context).secondaryHeaderColor,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              SignUpScreen.routeName,
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text(
                            'Create Account',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
