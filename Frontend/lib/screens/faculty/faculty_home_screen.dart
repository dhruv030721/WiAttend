import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wifi_attendance_app/constants/api.dart';
import 'package:wifi_attendance_app/models%20&%20providers/user_data.dart';
import 'package:wifi_attendance_app/widgets/button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wifi_attendance_app/widgets/custom_alert_box.dart';

class FacultyHomeScreen extends StatefulWidget {
  const FacultyHomeScreen({Key? key}) : super(key: key);

  static const routeName = '/FacultyHomeScreen';

  @override
  _FacultyHomeScreenState createState() => _FacultyHomeScreenState();
}

class _FacultyHomeScreenState extends State<FacultyHomeScreen> {
  late Future<String> ip;
  List<String> subjectData = [];
  Map<String, dynamic> facultyDetails = {};
  late TextEditingController _dropdownController; // Declare the controller
  var session_id;
  var date;
  var time;
  bool _isSessionActivate = false;

  void _showErrorDialog(String message, int? responsecode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: (responsecode == 200) ||
                  (responsecode == 201 ||
                      responsecode == 204 ||
                      responsecode == 102)
              ? ''
              : 'Error',
          message: message,
          status_code: responsecode,
        );
      },
    );
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

  Future<void> StartSession() async {
    final String endpoint = 'addsession';
    final Uri uri = Uri.parse('$api/api/$endpoint');
    String subjectName = _dropdownController.text;
    session_id = Random().nextInt(100000) + 100000;
    date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    time = DateTime.now().toIso8601String().substring(11, 19);
    var ipAdress = await IPmodification(await ip);

    Map body = {
      'session_id': session_id,
      'faculty_name': facultyDetails['name'],
      'branch': facultyDetails['branch'],
      'subject_name': subjectName,
      'date': date,
      'time': time,
      'ip': ipAdress,
    };

    _showErrorDialog("Processing...", 102);

    try {
      http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      Navigator.of(context).pop();
      _showErrorDialog("Session Started Successfully", response.statusCode);
      setState(() {
        _isSessionActivate = true;
      });
      Future.delayed(
        Duration(milliseconds: 1500),
        () {
          Navigator.of(context).pop();
        },
      );
    } catch (e) {
      _showErrorDialog("$e", null);
    }
  }

  void EndSession() async {
    final String endpoint = 'deletesession';
    final Uri uri = Uri.parse('$api/api/$endpoint/$session_id');

    _showErrorDialog("Processing...", 102);

    try {
      http.Response response = await http.delete(uri);

      if (response.statusCode == 204) {
        // Check if the response has no content
        Navigator.of(context).pop();
        _showErrorDialog("Session ended successfully", response.statusCode);
        setState(() {
          _isSessionActivate = false;
        });
        Future.delayed(
          Duration(milliseconds: 1500),
          () {
            Navigator.of(context).pop();
          },
        );
      } else {
        if (response.body.isNotEmpty) {
          Map<String, dynamic> decodeddata = json.decode(response.body);
          print(decodeddata);
          print(response.statusCode);
          Navigator.of(context).pop();
          _showErrorDialog(decodeddata['message'], response.statusCode);
        } else {
          _showErrorDialog(
              "No response body received from the server", response.statusCode);
        }
      }
    } catch (e) {
      _showErrorDialog("$e", null);
    }
  }

  @override
  void initState() {
    ip = getPublicIP();
    _dropdownController = TextEditingController(); // Initialize the controller
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    subjectData = Provider.of<Data>(context).subject;
    facultyDetails = Provider.of<Data>(context).faculty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Select Subject : ',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
              SubjectDropDownMenu(context, subjectData, _dropdownController),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: FutureBuilder<String>(
              future: ip,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to fetch IP address'));
                } else {
                  return Text('IP Address : ${snapshot.data}');
                }
              },
            ),
          ),
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _isSessionActivate
                  ? Text('Session Running....')
                  : Button(
                      btnName: "Start Session",
                      Navigator: StartSession,
                      colors: Colors.blue,
                    ),
              Button(
                btnName: "End Session",
                Navigator: EndSession,
                colors: Colors.red,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text('Session Key : $session_id'),
            ],
          ),
        )
      ],
    );
  }
}

Widget SubjectDropDownMenu(BuildContext context, List<String> subjectData,
    TextEditingController _dropdownController) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: DropdownMenu(
        controller: _dropdownController,
        textStyle: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.black),
        trailingIcon: Icon(
          Icons.arrow_drop_down_circle_outlined,
          color: Colors.black,
        ),
        initialSelection: subjectData[0],
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color.fromRGBO(204, 204, 204, 1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        menuStyle: MenuStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.all(5)),
            shadowColor: MaterialStatePropertyAll(Colors.black),
            visualDensity: VisualDensity.standard,
            backgroundColor:
                MaterialStatePropertyAll(Color.fromRGBO(204, 204, 204, 1)),
            elevation: MaterialStatePropertyAll(20),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))))),
        dropdownMenuEntries: subjectData.map((String subject) {
          return DropdownMenuEntry(
            value: subject,
            label: subject,
            style: ButtonStyle(
                animationDuration: Duration(milliseconds: 1000),
                textStyle: MaterialStatePropertyAll(
                    Theme.of(context).textTheme.bodySmall)),
          );
        }).toList()),
  );
}
