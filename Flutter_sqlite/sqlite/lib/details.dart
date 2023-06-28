import 'package:flutter/material.dart';

class detailsPage extends StatelessWidget {
  // In the constructor, require a Todo.
  detailsPage({key, this.list}) : super(key: key);

  // Declare a field that holds the Todo.
  final list;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
        appBar: AppBar(
          title: Text("${list['name']} Details"),
        ),
        body: Container(
          height: 110,
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 8.0),
              child: Column(
                children: [
                  ListTile(
                    isThreeLine: true,
                    leading: Icon(Icons.person_2_rounded),
                    title: Text(list['name']),
                    subtitle: Text(list['email']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(list['id'].toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
