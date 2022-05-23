import 'package:flutter/material.dart';
import 'issue.dart';
import 'func.dart';

class ScrumBoard extends StatefulWidget {
  ScrumBoard({Key? key}) : super(key: key);


  @override
  _ScrumBoardState createState() => _ScrumBoardState();
}

class _ScrumBoardState extends State<ScrumBoard> {
  Future<List<Issue>> listnew = Future<List<Issue>>.delayed(
      const Duration(seconds: 1),
      () => getTicketList(ticketStatus: "new", isSprint: "1"));
  Future<List<Issue>> listinprogress = Future<List<Issue>>.delayed(
      const Duration(seconds: 1),
      () => getTicketList(ticketStatus: "in progress", isSprint: "1"));
  Future<List<Issue>> listfinished = Future<List<Issue>>.delayed(
      const Duration(seconds: 1),
      () => getTicketList(ticketStatus: "finished", isSprint: "1"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: topbar("Sprint Board", context),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Text(
                      'New tickets list:',
                      style: TextStyle(fontSize: 24),
                    ),
                    Expanded(child: listCreate(listnew)),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Text(
                      'In Progress tickets list:',
                      style: TextStyle(fontSize: 24),
                    ),
                    Expanded(child: listCreate(listinprogress)),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Text(
                      'Finished tickets list:',
                      style: TextStyle(fontSize: 24),
                    ),
                    Expanded(child: listCreate(listfinished)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
