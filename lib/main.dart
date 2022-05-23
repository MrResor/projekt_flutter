import 'package:flutter/material.dart';
import 'ticketlists.dart';
import 'login.dart';
import 'scrumboard.dart';
import 'dashboard.dart';
import 'logout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrum Board',
      initialRoute: '/',
      routes: {
        '/':            (context) => LoginPage(),
        '/dashboard':   (context) => Dashboard(),
        '/new':         (context) => NewTicketsList(),
        '/scrum':       (context) => ScrumBoard(),
        '/inprogress':  (context) => InProgressTicketsList(),
        '/finished':    (context) => FinishedTicketsList(),
        '/logout':      (context) => LogoutScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
