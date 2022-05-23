import 'package:flutter/material.dart';
import 'dart:async';
import 'func.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<int> nSCount = Future<int>.delayed(const Duration(seconds: 1),
      () => getTicketCount(ticketStatus: "new", isSprint: "1"));
  Future<int> nCount = Future<int>.delayed(
      const Duration(seconds: 1), () => getTicketCount(ticketStatus: "new"));
  Future<int> iPCount = Future<int>.delayed(const Duration(seconds: 1),
      () => getTicketCount(ticketStatus: "in progress"));
  Future<int> fCount = Future<int>.delayed(const Duration(seconds: 1),
      () => getTicketCount(ticketStatus: "finished"));
  Future<int> iPSCount = Future<int>.delayed(const Duration(seconds: 1),
      () => getTicketCount(ticketStatus: "in progress", isSprint: "1"));
  Future<int> fSCount = Future<int>.delayed(const Duration(seconds: 1),
      () => getTicketCount(ticketStatus: "finished", isSprint: "1"));

  Widget futurething(futureVar, String type) {
    return FutureBuilder<int>(
        future: futureVar,
        builder: (BuildContext context, AsyncSnapshot<int> snap) {
          List<Widget> children;
          if (snap.hasData) {
            children = <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('$type Tickets:', style: biggerFont),
                    Text('${snap.data}', style: biggerFont)
                  ])
            ];
          } else if (snap.hasError) {
            children = <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('$type Tickets:', style: griderror),
                    Text('error', style: griderror)
                  ])
            ];
          } else {
            children = <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('$type Tickets:', style: biggerFont),
                    CircularProgressIndicator(),
                  ])
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        });
  }

  Widget newSprintCountSquare() {
    return Container(
        color: Colors.blue[300],
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 3,
        child: futurething(nSCount, "New Sprint"));
  }

  Widget inProgressSprintCountSquare() {
    return Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 3,
        child: futurething(iPSCount, "In Progress Sprint"));
  }

  Widget finishedSprintCountSquare() {
    return Container(
        color: Colors.yellow,
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 3,
        child: futurething(fSCount, "Finished Sprint"));
  }

  Widget newCountSquare() {
    return Container(
        color: Colors.purple,
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 3,
        child: futurething(nCount, "New"));
  }

  Widget inProgressCountSquare() {
    return Container(
        color: Colors.green,
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 3,
        child: futurething(iPCount, "In Progress"));
  }

  Widget finishedCountSquare() {
    return Container(
        color: Colors.pink[900],
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 3,
        child: futurething(fCount, "Finished"));
  }

  @override
  Widget build(BuildContext context) {
    if (curruserid < 1) {
      return new Scaffold(
        appBar: new AppBar(
          title: Text("Timeout error!"),
        ),
        body: Center(
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
        )),
      );
    } else {
      return new Scaffold(
          appBar: topbar("Status Dashboard", context),
          body: GridView.count(
            childAspectRatio: ((MediaQuery.of(context).size.width / 3) /
                (MediaQuery.of(context).size.height / 2 - 28)),
            crossAxisCount: 3,
            children: List.generate(6, (index) {
              switch (index) {
                case 0:
                  return newSprintCountSquare();
                case 1:
                  return inProgressSprintCountSquare();
                case 2:
                  return finishedSprintCountSquare();
                case 3:
                  return newCountSquare();
                case 4:
                  return inProgressCountSquare();
                case 5:
                  return finishedCountSquare();
                default:
                  return Container(
                      color: Colors.red,
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('Error', style: biggerFont),
                          ]));
              }
            }),
          ));
    }
  }
}
