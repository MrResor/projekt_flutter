import 'package:flutter/material.dart';
import 'func.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  // final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logintextcontroller = TextEditingController();
  final passswordtextcontroller = TextEditingController();

  bool correctlog = true;

  @override
  void dispose() {
    logintextcontroller.dispose();
    passswordtextcontroller.dispose();
    super.dispose();
  }

  Future<dynamic> postloginRequest(String login, String password) async {
    setState(() {
      correctlog = true;
    });
    var url = apiLink + '/session';
    var body = json.encode({'user_login': login, 'user_password': password});
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json-patch+json',
        "Access-Control-Allow-Origin": "*"
      },
      body: body,
    );
    final data = json.decode(response.body);
    print(data);
    if (response.statusCode != 200) {
      setState(() {
        correctlog = false;
      });
    } else {
      curruserid = data['user_id'];
      print(token);
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
    return json.decode(response.body);
  }

  Widget image() {
    return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
        child: Center(
            child: Container(
          height: 200.0,
          width: 170.0,
          child: Image.asset('assets/images/sprint-logo.png'),
        )));
  }

  Widget loginField() {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 2.75),
        child: TextField(
          controller: logintextcontroller,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Login',
          ),
        ));
  }

  Widget passwordField() {
    return Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 2.75,
          right: MediaQuery.of(context).size.width / 2.75,
          top: MediaQuery.of(context).size.height / 25,
          bottom: 0.0,
        ),
        child: TextField(
          obscureText: true,
          controller: passswordtextcontroller,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
          ),
        ));
  }

  Widget errorField() {
    return SizedBox(
        height: 50,
        child: correctlog
            ? null
            : Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  "User Login or password is incorrect!",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                )));
  }

  Widget loginButton() {
    return Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(20)),
      child: TextButton(
        onPressed: () {
          postloginRequest(
              logintextcontroller.text, passswordtextcontroller.text);
        },
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: new AppBar(
        title: Text("Sprint Board Login Screen"),
      ),
      body: new Column(
        children: <Widget>[
          image(),
          loginField(),
          passwordField(),
          errorField(),
          loginButton(),
        ],
      ),
      //emergency entry button
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.auto_fix_high_rounded),
          onPressed: () {
            postloginRequest("admin", "admin");
            Navigator.of(context).pushReplacementNamed('/dashboard');
          }),
    );
  }
}
