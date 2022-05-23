import 'issue.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

final biggerFont = const TextStyle(fontSize: 18.0, color: Colors.black);
final error = const TextStyle(fontSize: 18.0, color: Colors.red);
final griderror = const TextStyle(fontSize: 18.0, color: Colors.white);

String apiLink = 'http://localhost:5000';

int curruserid = 0;
String token = "";

String dropDownValue = 'Status Dashboard';

Future<int> getTicketCount({ticketStatus, isSprint}) async
{ 
  var url = apiLink + '/ticket/ticketcount';
  if (ticketStatus != null && isSprint != null)
  {
    url += '?ticket_status=' + ticketStatus + '&is_sprint=' + isSprint;
  }
  else if (ticketStatus != null)
  {
    url += '?ticket_status=' + ticketStatus;
  }
  else if (isSprint != null)
  {
    url += '?is_sprint=' + isSprint;
  }
  Uri uri = Uri.parse(url);
  var response = await http.get(
    uri,
    headers:
    {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
      "Access-Control-Allow-Origin": "*"
    }
  );
  final data = json.decode(response.body);
  return data["ticket_number"];
}

Future<List<Issue>> getTicketList({ticketStatus, isSprint}) async
{
  var url = apiLink + '/ticket/ticketlist';
  if (ticketStatus != null && isSprint != null)
  {
    url += '?ticket_status=' + ticketStatus + '&is_sprint=' + isSprint;
  }
  else if (ticketStatus != null)
  {
    url += '?ticket_status=' + ticketStatus;
  }
  else if (isSprint != null)
  {
    url += '?is_sprint=' + isSprint;
  }
  Uri uri = Uri.parse(url);
  var response = await http.get(
    uri,
    headers:
    {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
      "Access-Control-Allow-Origin": "*"
    }
  );
  final data = json.decode(response.body);
  List <Issue> toreturn = [];
  for (int i = 0; i < data.length; i++)
  {
    toreturn.add(new Issue(data[i]["ticket_number"], data[i]["ticket_title"]));
  }
  print(curruserid);
  return toreturn;
}

Widget buildRow(Issue ticket)
{
  return ListTile(
    leading: Text(ticket.ticketNumber.toString(),
    style: biggerFont,
    ),
    title: Text(ticket.ticketTitle,
    style: biggerFont,
    ),
  );
}

Widget listCreate(list)
{
  return Container(
    child: FutureBuilder<List<Issue>>(
      future: list,
      builder: (BuildContext context, AsyncSnapshot<List<Issue>> listSnap)
      {
        if (listSnap.hasData) 
        {
          if(listSnap.data!.length == 0)
          {
            return Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('No tickets with chosen criteria found!', style: biggerFont),
                ],
              )
            );
          }
          else
          {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount:2 * listSnap.data!.length,
              itemBuilder: (context, i)
              {
                if (i.isOdd) return const Divider();

                final index = i ~/ 2;
                
                return buildRow(listSnap.data![index]);
              },
            );
          }
        }
        else if (listSnap.hasError)
        {
          return Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Loading list of finished tickets:', style: error),
                Text('Error', style: error),
              ],
            )
          );
        }
        else
        {
          return Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Loading list of finished tickets:', style: biggerFont),
                CircularProgressIndicator(),
              ],
            )
          );
        }
      }
    )
  );
}

PreferredSizeWidget topbar(title, BuildContext context)
{
  return new AppBar(
    title: Text(title),
    actions: [
      DropdownButton<String>(
        value: dropDownValue,
        icon: const Icon(Icons.list),
        style: const TextStyle(
          color: Colors.black
        ),
        underline: Container(
          height: 2,
          color: Colors.black,
        ),
        onChanged: (String? newValue)
        {
          if (newValue == 'Status Dashboard')
          {
            Navigator.of(context).pushReplacementNamed('/dashboard');
          }
          else if (newValue == 'New')
          {
            Navigator.of(context).pushReplacementNamed('/new');
          }
          else if (newValue == 'In Progress')
          {
            Navigator.of(context).pushReplacementNamed('/inprogress');
          }
          else if (newValue == 'Finished')
          {
            Navigator.of(context).pushReplacementNamed('/finished');
          }
          else if (newValue == 'Sprint Dashboard')
          {
            Navigator.of(context).pushReplacementNamed('/scrum');
          }
          dropDownValue = newValue!;
        },
        items: <String>['Status Dashboard','Sprint Dashboard', 'New', 'In Progress', 'Finished'].map<DropdownMenuItem<String>>((String value)
        {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )
    ],
  );
}
