import 'package:flutter/material.dart';

class LogoutScreen extends StatefulWidget {
  LogoutScreen({Key? key}) : super(key: key);


  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  Widget body() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
            "You tried to access page incorrectly or your session timed out, please try loging in again"),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/');
            },
            child: Text("Login Screen")),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: new AppBar(
          title: Text("Logout screen"),
        ),
        body: body());
  }
}
