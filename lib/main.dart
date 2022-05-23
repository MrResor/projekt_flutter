// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'issue.dart';

// int curruserid = 0;

// Issue a = new Issue(123,"ticket a");
// Issue b = new Issue(456,"ticket b");
// Issue c = new Issue(789,"ticket c");

// List newTickets = <Issue>[a,b,c,a,b,c,a,b,c,a,b,c];
// List inProgressTickets = <Issue>[a,b,c];
// List finishedTickets = <Issue>[c];
// List sprintNew = <Issue>[a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a];
// List sprintInProgress = <Issue>[b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b];
// List sprintFinished = <Issue>[c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c];

// var nSCount;
// var nCount;
// var iPCount;
// var fCount;
// var iPSCount;
// var fSCount;

// Future<int> getTicketCountRequest({String ticketStatus = "", int isSprint = -1}) async 
// {
//   var url = 'http://localhost:5000/ticketcount';
//   var body = json.encode(
//   {
//     'ticket_status': ticketStatus,
//     'is_sprint': isSprint
    
//   });
//   var response = await http.post(
//     Uri.parse(url),
//     headers:
//     {
//       'accept': 'application/json',
//       'Content-Type': 'application/json-patch+json',
//       "Access-Control-Allow-Origin": "*"
//     },
//     body: body,
//   );
//   final data = json.decode(response.body);
//   print(data["ticket_number"]);
//   return data["ticket_number"];
// }

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget 
// {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Scrum Board',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: LoginPage(title: 'Status Dashboard'),
//     ); 
//   }
// }

// class LoginPage extends StatefulWidget
// {
//   LoginPage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage>
// {
//   final logintextcontroller = TextEditingController();
//   final passswordtextcontroller = TextEditingController();

//   bool correctlog = true;

//   @override
//   void dispose()
//   {
//     logintextcontroller.dispose();
//     passswordtextcontroller.dispose();
//     super.dispose();
//   }

//   Future<dynamic> postloginRequest(String login, String password) async 
//   {
//     setState(()
//     {
//         correctlog = true;
//     });
//     var url = 'http://localhost:5000/session';
//     var body = json.encode(
//     {
//       'user_login': login,
//       'user_password': password
//     });
//     var response = await http.post(
//       Uri.parse(url),
//       headers:
//       {
//         'accept': 'application/json',
//         'Content-Type': 'application/json-patch+json',
//         "Access-Control-Allow-Origin": "*"
//       },
//       body: body,
//     );
//     final data = json.decode(response.body);
//     if (response.statusCode != 200)
//     {
//       setState(() 
//       {
//         correctlog = false;
//       });
//     }
//     else
//     {
//       curruserid = data['user_id'];
//       Navigator.push(
//         context, MaterialPageRoute(builder: (_) => MyHomePage(title: 'Status Dashboard'))
//       );
//     }
//     return json.decode(response.body);
//   }

//   @override
//   Widget build(BuildContext context) 
//   {
//     return new Scaffold(
//       backgroundColor: Colors.grey.shade400,
//       appBar: new AppBar(
//         title: Text("Sprint Board Login Screen"),
//       ),
//       body: new Column(
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(top: 60.0),
//             child: Center(
//               child: Container(
//                 height: 200.0,
//                 width: 150.0,
//                 child: Image.asset('assets/images/sprint-logo.png'),
//               )
//             )
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 2.75),
//             child: TextField(
//               controller: logintextcontroller,
//               textAlignVertical: TextAlignVertical.center,
//               textAlign: TextAlign.left,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Login',
//               ),
//             )
//           ),
//           Padding(  
//             padding: EdgeInsets.only(
//               left: MediaQuery.of(context).size.width / 2.75,
//               right: MediaQuery.of(context).size.width / 2.75,
//               top: 25.0,
//               bottom: 0.0
//             ),
//             child: TextField(
//               obscureText: true,
//               controller: passswordtextcontroller,
//               textAlignVertical: TextAlignVertical.center,
//               textAlign: TextAlign.left,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Password',
//               ),
//             )
//           ),
//           SizedBox(
//             height: 50,
//             child: correctlog ? null : Padding(
//               padding: EdgeInsets.only(top: 12.0),
//               child: Text("User Login or password is incorrect!",
//                 style: TextStyle(color: Colors.red, fontSize: 18),
//               )
//             )
//           ),
//           Container(
//             height: 50,
//             width: 250,
//             decoration: BoxDecoration(
//                 color: Colors.green, borderRadius: BorderRadius.circular(20)),
//             child: TextButton(
//               onPressed: () {
//                 postloginRequest(logintextcontroller.text, passswordtextcontroller.text);
//               },
//               child: Text(
//                 'Login',
//                 style: TextStyle(color: Colors.white, fontSize: 25),
//               ),
//             ),
//           ),
//         ],
//       ),
//       //emergency entry button
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.auto_fix_high_rounded),
//         onPressed: ()
//         {
//           Navigator.push(context, MaterialPageRoute(builder: (_) => MyHomePage(title: 'Status Dashboard')));
//         }
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget 
// {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> 
// { 
//   final tickettextcontroller = TextEditingController();
//   final _biggerFont = const TextStyle(fontSize: 18.0);
//   String dropDownValue = 'Status Dashboard';
  
//   @override
//   @protected
//   @mustCallSuper
//   void initState() 
//   {
//     super.initState();
//   }

//   @override
//   void dispose()
//   {
//     tickettextcontroller.dispose();
//     super.dispose();
//   }

//   //this is useless i think, will have to check
//   Widget addButton()
//   {
//     return new FloatingActionButton(
//       child: Icon(Icons.add),
//       onPressed: () 
//       {
//         showDialog(
//           context: context,
//           builder: (context)
//           {
//             return Container(
//               width: MediaQuery.of(context).size.width / 2,
//               height: MediaQuery.of(context).size.height / 2,
//               child: SimpleDialog(
//                 title: Text('Ticket Creation'),
//                 children: <Widget>[
//                   TextField(
//                     controller: tickettextcontroller,
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       newTickets.add(new Issue(tickettextcontroller.text));
//                       setState(() {});
//                       tickettextcontroller.clear();
//                       Navigator.pop(context);
//                     },
//                     child: Text('save'),
//                   ),
//                 ],
//               )
//             );
//           }
//         );
//       },
//       tooltip: 'Add Ticket',
//     );
//   }

//   Widget addButtontest()
//   {
//     return new FloatingActionButton(
//       child: Icon(Icons.add),
//       onPressed: () 
//       {
//         showDialog(
//           context: context,
//           builder: (context)
//           {
//             return Dialog(
//               backgroundColor: Colors.transparent,
//               insetPadding: EdgeInsets.all(10.0),
//               child: Stack(
//                 clipBehavior: Clip.antiAlias,
//                 alignment: Alignment.center,
//                 children: <Widget>[ 
//                   Container(
//                     width: MediaQuery.of(context).size.width / 3,
//                     height: MediaQuery.of(context).size.height / 3,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: Colors.white,
//                     ),
//                     padding: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("Create ticket",
//                           style: TextStyle(fontSize: 24),
//                           textAlign: TextAlign.center,
//                         ),
//                         TextField(
//                           controller: tickettextcontroller,
//                           textAlignVertical: TextAlignVertical.center,
//                           textAlign: TextAlign.center,
//                         ),
//                         TextButton(
//                           onPressed: () 
//                           {
//                             newTickets.add(new Issue(tickettextcontroller.text));
//                             setState(() {});
//                             tickettextcontroller.clear();
//                             Navigator.pop(context);
//                           },
//                           child: Text('save'),
//                         ),
//                       ],
//                     )
//                   )
//                 ],
//               )
//             );
//           }
//         );
//       },
//       tooltip: 'Add Ticket',
//     );
//   }

//   Widget dashboardPage()
//   {
//     return new GridView.count(
//       childAspectRatio: ((MediaQuery.of(context).size.width / 3)/(MediaQuery.of(context).size.height / 2 - 28)),
//       crossAxisCount: 3,
//       children: List.generate(6,(index)
//       {
//         switch(index)
//         {
//           case 0:
//             return Container(
//               color: Colors.blue[300],
//               height: MediaQuery.of(context).size.height / 2,
//               width: MediaQuery.of(context).size.width / 3,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Text('New Sprint Tickets:'),
//                   Text('$nSCount')
//                 ]
//               )
//             );
//           case 1:
//             return Container(
//               color: Colors.red,
//               height: MediaQuery.of(context).size.height / 2,
//               width: MediaQuery.of(context).size.width / 3,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Text('In Progress Sprint Tickets:'),
//                   Text('$iPSCount'),
//                 ]
//               )
//             );
//           case 2:
//             return Container(
//               color: Colors.yellow,
//               height: MediaQuery.of(context).size.height / 2,
//               width: MediaQuery.of(context).size.width / 3,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Text('Finished Sprint Tickets:'),
//                   Text('$fSCount'),
//                 ]
//               )
//             );
//           case 3:
//             return Container(
//               color: Colors.purple,
//               height: MediaQuery.of(context).size.height / 2,
//               width: MediaQuery.of(context).size.width / 3,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Text('New Tickets:'),
//                   Text('$nCount'),
//                 ]
//               )
//             );
//           case 4:
//             return Container(
//               color: Colors.green,
//               height: MediaQuery.of(context).size.height / 2,
//               width: MediaQuery.of(context).size.width / 3,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Text('In Progress Tickets:'),
//                   Text('$iPCount'),
//                 ]
//               )
//             );
//           case 5:
//             return Container(
//               color: Colors.pink[900],
//               height: MediaQuery.of(context).size.height / 2,
//               width: MediaQuery.of(context).size.width / 3,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Text('Finished Tickets:'),
//                   Text('$fCount'),
//                 ]
//               )
//             );
//           default:
//             return Container(
//               color: Colors.red,
//               height: MediaQuery.of(context).size.height / 2,
//               width: MediaQuery.of(context).size.width / 3,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Text('Error'),
//                 ]
//               )
//             );
//         }
//       }),
//     );
//   }

//   Widget listButton()
//   {
//     return DropdownButton<String>(
//       value: dropDownValue,
//       icon: const Icon(Icons.list),
//       style: const TextStyle(
//         color: Colors.black
//       ),
//       underline: Container(
//         height: 2,
//         color: Colors.black,
//       ),
//       onChanged: (String? newValue)
//       {
//         setState(()
//         {
//           dropDownValue = newValue!;
//         });
//       },
//       items: <String>['Status Dashboard', 'New', 'In Progress', 'Finished', 'Sprint Dashboard'].map<DropdownMenuItem<String>>((String value)
//       {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildRow(Issue ticket)
//   {
//     return ListTile(
//       leading: Text(ticket.ticketNumber,
//       style: _biggerFont,
//       ),
//       title: Text('Random Text',
//       style: _biggerFont,
//       ),
//     );
//   }

//   Widget listCreate(List ticketList)
//   {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16.0),
//       itemCount: 2 * ticketList.length,
//       itemBuilder: (context, i)
//       {
//         if (i.isOdd) return const Divider();

//         final index = i ~/ 2;
        
//         return _buildRow(ticketList[index]);
//       },
//     );
//   }

//   Widget sprintBoard()
//   {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 20.0),
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: <Widget>[
//           Container(
//             width: MediaQuery.of(context).size.width / 3,
//             height: MediaQuery.of(context).size.height,
//             child: Column(
//               children: [
//                 Text('New tickets list:',
//                 style: TextStyle(fontSize: 24),
//                 ),
//                 Expanded(child: listCreate(sprintNew)),
//               ],
//             ),
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width / 3,
//             height: MediaQuery.of(context).size.height,
//             child: Column(
//               children: [
//                 Text('In Progress tickets list:',
//                 style: TextStyle(fontSize: 24),
//                 ),
//                 Expanded(child: listCreate(sprintInProgress)),
//               ],
//             ),
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width / 3,
//             height: MediaQuery.of(context).size.height,
//             child: Column(
//               children: [
//                 Text('Finished tickets list:',
//                 style: TextStyle(fontSize: 24),
//                 ),
//                 Expanded(child: listCreate(sprintFinished)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) 
//   {
//     setState(() {});
//     return new Scaffold(
//       appBar: new AppBar(
//         title: Text(dropDownValue),
//         actions: [
//           listButton(),
//         ],
//       ),
//       body: dropDownValue == "Status Dashboard" ? dashboardPage() 
//       : dropDownValue == "New" ? listCreate(newTickets + sprintNew) 
//       : dropDownValue == "In Progress" ? listCreate(inProgressTickets + sprintInProgress) 
//       : dropDownValue == "Finished" ? listCreate(finishedTickets + sprintFinished) 
//       : sprintBoard(),
//       floatingActionButton: addButtontest(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, 
//     );
//   }
 
// }
