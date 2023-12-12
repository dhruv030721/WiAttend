import 'package:flutter/material.dart';

class Data with ChangeNotifier {
  Map<String, dynamic> Studentdata = {};
  Map<String, dynamic> Facultydata = {};
  List<String> Subjectdata = [];
  String dropDownValue = "";
  String SubjectName = "";

  void addStudent(Map<String, dynamic> data) {
    Studentdata.addAll(data);
    notifyListeners();
  }

  void addFaculty(Map<String, dynamic> data) {
    Facultydata.addAll(data);
    Subjectdata = Facultydata['subjects'].split(',');
    notifyListeners();
  }

  Map<String, dynamic> get student {
    return {...Studentdata};
  }

  Map<String, dynamic> get faculty {
    return {...Facultydata};
  }

  List<String> get subject {
    return Subjectdata;
  }

  String updateDropDownValue(String value) {
    dropDownValue = value;
    notifyListeners();
    return dropDownValue;
  }

  void addSubjectName(String subjectName) {
    SubjectName = subjectName;
  }

  String get subjectName {
    return SubjectName;
  }
}
