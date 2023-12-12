import 'package:flutter/material.dart';
import '../../constants/api.dart';

class StudentProfileContainer extends StatelessWidget {
  final String name;
  final int sem;
  final String branch;
  final int enrollment_no;
  final String? image_url;
  const StudentProfileContainer({
    Key? key,
    required this.name,
    required this.sem,
    required this.branch,
    required this.enrollment_no,
    required this.image_url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.23,
        decoration: BoxDecoration(
          color: Color.fromRGBO(204, 204, 204, 1),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hi,',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.black),
                    ),
                    Text(name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black,
                              fontSize: 25,
                            )),
                    Text(
                      'Sem-$sem $branch',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.black),
                    ),
                    Text(
                      'Enrollment no : $enrollment_no',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.10,
            ),
            Flexible(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.22,
                height: MediaQuery.of(context).size.width * 0.22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  backgroundImage: image_url == null
                      ? AssetImage('assets/images/Profile.jpg') as ImageProvider
                      : NetworkImage('$drive_image_url$image_url'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
