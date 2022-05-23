import 'package:flutter/material.dart';
import 'func.dart';
import 'issue.dart';

class NewTicketsList extends StatefulWidget {
  NewTicketsList({Key? key}) : super(key: key);


  @override
  _NewTicketsListState createState() => _NewTicketsListState();
}

class _NewTicketsListState extends State<NewTicketsList> {
  Future<List<Issue>> list = Future<List<Issue>>.delayed(
    const Duration(seconds: 1), () => getTicketList(ticketStatus: "new"));

  @override
  Widget build(BuildContext context) {
    if (curruserid < 1) {
      return new Scaffold(
        backgroundColor: Colors.grey.shade400,
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
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: Text("Login Screen")),
          ],
        )),
      );
    } else {
      return new Scaffold(
          backgroundColor: Colors.grey.shade400,
          appBar: topbar("New", context),
          body: listCreate(list));
    }
  }
}

class InProgressTicketsList extends StatefulWidget {
  InProgressTicketsList({Key? key}) : super(key: key);


  @override
  _InProgressTicketsListState createState() => _InProgressTicketsListState();
}

class _InProgressTicketsListState extends State<InProgressTicketsList> {
  Future<List<Issue>> list = Future<List<Issue>>.delayed(
      const Duration(seconds: 1),
      () => getTicketList(ticketStatus: "in progress"));

  @override
  Widget build(BuildContext context) {
    if (curruserid < 1) {
      return new Scaffold(
        backgroundColor: Colors.grey.shade400,
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
          backgroundColor: Colors.grey.shade400,
          appBar: topbar("In Progress", context),
          body: listCreate(list));
    }
  }
}

class FinishedTicketsList extends StatefulWidget {
  FinishedTicketsList({Key? key}) : super(key: key);


  @override
  _FinishedTicketsListState createState() => _FinishedTicketsListState();
}

class _FinishedTicketsListState extends State<FinishedTicketsList> {
  Future<List<Issue>> list = Future<List<Issue>>.delayed(
      const Duration(seconds: 1),
      () => getTicketList(ticketStatus: "finished"));

  @override
  Widget build(BuildContext context) {
    if (curruserid < 1) {
      Navigator.of(context).pushReplacementNamed('/logout');
      return Container();
    } else {
      return new Scaffold(
          backgroundColor: Colors.grey.shade400,
          appBar: topbar("Finished", context),
          body: listCreate(list));
    }
  }
}
