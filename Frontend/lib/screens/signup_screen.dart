import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_attendance_app/constants/api.dart';
import 'package:wifi_attendance_app/screens/login_screen.dart';
import 'package:wifi_attendance_app/widgets/button.dart';
import 'package:wifi_attendance_app/widgets/custom_alert_box.dart';
import 'package:wifi_attendance_app/widgets/input_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const routeName = '\SignUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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

  void Navigation() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    final String endpoint = 'signup';
    final Uri uri = Uri.parse('$api/api/$endpoint');

    Map body = {
      'username': username,
      'password': password,
    };

    _showErrorDialog("Processing...", 102);

    if (username.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        try {
          http.Response response = await http.patch(
            uri,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode(body),
          );

          var responseBody = json.decode(response.body);
          var message = responseBody != null
              ? responseBody['message']
              : 'Unknown error occurred';
          print(responseBody);
          print(response.statusCode);
          if (response.statusCode == 201) {
            Navigator.of(context).pop();
            _showErrorDialog(message, response.statusCode);
            Future.delayed(
              Duration(milliseconds: 1500),
              () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName,
                  (Route<dynamic> route) => false,
                );
              },
            );
          } else {
            Navigator.of(context).pop();
            _showErrorDialog(message, response.statusCode);
          }
        } catch (e) {
          Navigator.of(context).pop();
          _showErrorDialog("An error occurred: $e", null);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset('assets/images/signup.png',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
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
                        'SignUp',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                    InputTextField(
                      text: 'Username',
                      preicon: Icons.person_rounded,
                      InputController: _usernameController,
                    ),
                    InputTextField(
                      text: 'Password',
                      preicon: Icons.key_rounded,
                      InputController: _passwordController,
                      obscureText: _isObscure,
                    ),
                    InputTextField(
                      text: 'Confirm Password',
                      preicon: Icons.key_rounded,
                      InputController: _confirmPasswordController,
                      suficon:
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                      obscureText: _isObscure,
                      onTap: _toggleObscure,
                    ),
                    Button(
                      btnName: 'Sign Up',
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
                          'Have an account?',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                          },
                          child: Text(
                            'Login',
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
