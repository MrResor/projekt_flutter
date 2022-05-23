import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'issue.dart';
import 'func.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrum Board',
      initialRoute: '/',
      routes: 
      {
        '/': (context) => LoginPage(title: 'Scrum Board'),
        '/dashboard': (context) => Dashboard(title: 'Scrum Board'),
        '/new': (context) => NewTicketsList(title: 'Scrum Board'),
        '/scrum': (context) => ScrumBoard(title: 'Scrum Board'),
        '/inprogress': (context) => InProgressTicketsList(title: 'Scrum Board'),
        '/finished': (context) => FinishedTicketsList(title: 'Scrum Board'),
        '/logout' : (context) => LogoutScreen(title: 'Scrum Board'),
      },
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
    ); 
  }
}

class LoginPage extends StatefulWidget
{
  LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{
  final logintextcontroller = TextEditingController();
  final passswordtextcontroller = TextEditingController();

  bool correctlog = true;

  @override
  void dispose()
  {
    logintextcontroller.dispose();
    passswordtextcontroller.dispose();
    super.dispose();
  }

  Future<dynamic> postloginRequest(String login, String password) async 
  {
    setState(() { correctlog = true; });
    var url = apiLink +'/session';
    var body = json.encode(
    {
      'user_login': login,
      'user_password': password
    });
    var response = await http.post(
      Uri.parse(url),
      headers:
      {
        'accept': 'application/json',
        'Content-Type': 'application/json-patch+json',
        "Access-Control-Allow-Origin": "*"
      },
      body: body,
    );
    final data = json.decode(response.body);
    print(data);
    if (response.statusCode != 200)
    {
      setState(() { correctlog = false; });
    }
    else
    {
      curruserid = data['user_id'];
      print(token);
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
    return json.decode(response.body);
  }

  Widget image()
  {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
      child: Center(
        child: Container(
          height: 200.0,
          width: 170.0,
          child: Image.asset('assets/images/sprint-logo.png'),
        )
      )
    );
  }

  Widget loginField()
  {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 2.75),
      child: TextField(
        controller: logintextcontroller,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Login',
        ),
      )
    );
  }

  Widget passwordField()
  {
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
      )
    );
  }

  Widget errorField()
  {
    return SizedBox(
      height: 50,
      child: correctlog ? null : Padding(
        padding: EdgeInsets.only(top: 12.0),
        child: Text("User Login or password is incorrect!",
          style: TextStyle(color: Colors.red, fontSize: 18),
        )
      )
    );
  }

  Widget loginButton()
  {
    return Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.green, borderRadius: BorderRadius.circular(20)),
      child: TextButton(
        onPressed: () 
        {
          postloginRequest(logintextcontroller.text, passswordtextcontroller.text);
        },
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return new Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: new AppBar(title: Text("Sprint Board Login Screen"),),
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
        onPressed: ()
        {
          postloginRequest("admin", "admin");
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      ),
    );
  }
}

class Dashboard extends StatefulWidget
{
  Dashboard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
{
  Future<int> nSCount = Future<int>.delayed(const Duration(seconds: 2),() 
    => getTicketCount(ticketStatus: "new", isSprint: "1"));
  Future<int> nCount = Future<int>.delayed(const Duration(seconds: 2),() 
    => getTicketCount(ticketStatus: "new"));
  Future<int> iPCount = Future<int>.delayed(const Duration(seconds: 2),() 
    => getTicketCount(ticketStatus: "in progress"));
  Future<int> fCount = Future<int>.delayed(const Duration(seconds: 2),() 
    => getTicketCount(ticketStatus: "finished"));
  Future<int> iPSCount = Future<int>.delayed(const Duration(seconds: 2),() 
    => getTicketCount(ticketStatus: "in progress", isSprint: "1"));
  Future<int> fSCount = Future<int>.delayed(const Duration(seconds: 2),() 
    => getTicketCount(ticketStatus: "finished", isSprint: "1"));

  Widget futurething(futureVar, String type)
  {
    return FutureBuilder<int>(
      future: futureVar,
      builder: (BuildContext context, AsyncSnapshot<int> snap)
      {
        List<Widget> children;
        if (snap.hasData) 
        {
          children = <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('$type Tickets:', style: biggerFont),
                Text('${snap.data}', style: biggerFont)
              ]
            )
          ];
        }
        else if (snap.hasError) 
        {
          children = <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('$type Tickets:', style: griderror),
                Text('error', style: griderror)
              ]
            )
          ];
        }
        else
        {
          children = <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('$type Tickets:', style: biggerFont),
                CircularProgressIndicator(),
              ]
            )
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      }
    );
  }

  Widget newSprintCountSquare()
  {
    return Container(
      color: Colors.blue[300],
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 3,
      child: futurething(nSCount, "New Sprint")
    );
  }

  Widget inProgressSprintCountSquare()
  {
    return Container(
      color: Colors.red,
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 3,
      child: futurething(iPSCount, "In Progress Sprint")
    );
  }

  Widget finishedSprintCountSquare()
  {
    return Container(
      color: Colors.yellow,
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 3,
      child: futurething(fSCount, "Finished Sprint")
    );
  }

  Widget newCountSquare()
  {
    return Container(
      color: Colors.purple,
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 3,
      child: futurething(nCount, "New")
    );
  }

  Widget inProgressCountSquare()
  {
    return Container(
      color: Colors.green,
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 3,
      child: futurething(iPCount, "In Progress")
    );
  }

  Widget finishedCountSquare()
  {
    return Container(
      color: Colors.pink[900],
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 3,
      child: futurething(fCount, "Finished")
    );
  }

  @override
  Widget build(BuildContext context)
  {
    if(curruserid < 1)
    {
      return new Scaffold(
        appBar: new AppBar(
        title: Text("Timeout error!"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("You tried to access page incorrectly or your session timed out, please try loging in again"),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () { Navigator.popAndPushNamed(context, '/');}, 
                child: Text("Login Screen")
              ),
            ],
          )
        ),
      );
    }
    else
    {
      return new Scaffold(
        appBar: topbar("Status Dashboard", context),
        body: GridView.count(
          childAspectRatio: ((MediaQuery.of(context).size.width / 3)/(MediaQuery.of(context).size.height / 2 - 28)),
          crossAxisCount: 3,
          children: List.generate(6,(index)
          {
            switch(index)
            {
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
                    ]
                  )
                );
            }
          }),
        )
      );
    }
  }
}

class NewTicketsList extends StatefulWidget
{
  NewTicketsList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _NewTicketsListState createState() => _NewTicketsListState();
}

class _NewTicketsListState extends State<NewTicketsList>
{
  Future<List<Issue>> list = Future<List<Issue>>(()
    => getTicketList(ticketStatus: "new"));

  @override
  Widget build(BuildContext context)
  {
    if(curruserid < 1)
    {
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
              Text("You tried to access page incorrectly or your session timed out, please try loging in again"),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () { Navigator.of(context).pushReplacementNamed('/');}, 
                child: Text("Login Screen")
              ),
            ],
          )
        ),
      );
    }
    else
    {
      return new Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: topbar("New", context),
        body: listCreate(list)
      );
    }
  }
}

class InProgressTicketsList extends StatefulWidget
{
  InProgressTicketsList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _InProgressTicketsListState createState() => _InProgressTicketsListState();
}

class _InProgressTicketsListState extends State<InProgressTicketsList>
{
  Future<List<Issue>> list = Future<List<Issue>>.delayed(const Duration(seconds: 2),() 
    => getTicketList(ticketStatus: "in progress"));

  @override
  Widget build(BuildContext context)
  {
    if(curruserid < 1)
    {
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
              Text("You tried to access page incorrectly or your session timed out, please try loging in again"),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () { Navigator.popAndPushNamed(context, '/');}, 
                child: Text("Login Screen")
              ),
            ],
          )
        ),
      );
    }
    else
    {
      return new Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: topbar("In Progress", context),
        body: listCreate(list)
      );
    }
  }
}

class FinishedTicketsList extends StatefulWidget
{
  FinishedTicketsList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FinishedTicketsListState createState() => _FinishedTicketsListState();
}

class _FinishedTicketsListState extends State<FinishedTicketsList>
{
  Future<List<Issue>> list = Future<List<Issue>>.delayed(const Duration(seconds: 2),() 
    => getTicketList(ticketStatus: "finished"));

  @override
  Widget build(BuildContext context)
  {
    if(curruserid < 1)
    {
      Navigator.of(context).pushReplacementNamed('/logout');
      return Container();
    }
    else
    {
      return new Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: topbar("Finished", context),
        body: listCreate(list)
      );
    }
  }
}

class ScrumBoard extends StatefulWidget
{
  ScrumBoard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ScrumBoardState createState() => _ScrumBoardState();
}

class _ScrumBoardState extends State<ScrumBoard>
{
  Future<List<Issue>> listnew = Future<List<Issue>>.delayed(const Duration(seconds: 2),() 
    => getTicketList(ticketStatus: "new", isSprint: "1"));
  Future<List<Issue>> listinprogress = Future<List<Issue>>.delayed(const Duration(seconds: 2),() 
    => getTicketList(ticketStatus: "in progress", isSprint: "1"));
  Future<List<Issue>> listfinished = Future<List<Issue>>.delayed(const Duration(seconds: 2),() 
    => getTicketList(ticketStatus: "finished", isSprint: "1"));  

  @override
  Widget build(BuildContext context)
  {
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

                  Text('New tickets list:',
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

                  Text('In Progress tickets list:',
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

                  Text('Finished tickets list:',
                  style: TextStyle(fontSize: 24),
                  ),

                  Expanded(child: listCreate(listfinished)),
                  
                ],
              ),
            ),

          ],
        ),
      )
    );
  }
}

class LogoutScreen extends StatefulWidget
{
  LogoutScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen>
{
  Widget body()
  {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Text("You tried to access page incorrectly or your session timed out, please try loging in again"),

          SizedBox(
            height: 30,
          ),

          ElevatedButton(
            onPressed: () { Navigator.popAndPushNamed(context, '/');}, 
            child: Text("Login Screen")
          ),

        ],
      )
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: new AppBar(title: Text("Logout screen"),),
      body: body()
    );
  }
}