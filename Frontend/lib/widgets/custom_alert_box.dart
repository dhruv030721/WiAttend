import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final int? status_code;

  CustomAlertDialog(
      {required this.title, required this.message, this.status_code});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context),
        ),
      ),
    );
  }

  contentBox(context) {
    print('Status code: $status_code');
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.2,
            child: (status_code == 102)
                ? Lottie.asset('assets/lotties/loading.json',
                    frameRate: FrameRate(120), fit: BoxFit.contain)
                : (status_code == 201) ||
                        (status_code == 200 || status_code == 204)
                    ? Lottie.asset(
                        'assets/lotties/sucess.json',
                        frameRate: FrameRate(120),
                      )
                    : Lottie.asset('assets/lotties/error.json',
                        frameRate: FrameRate(120)),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child:
                (status_code == 200 || status_code == 201 || status_code == 204)
                    ? Container()
                    : TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
