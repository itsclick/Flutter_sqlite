import 'package:flutter/material.dart';
import 'package:sqlite/ContactinfoModel.dart';
import 'package:sqlite/controller.dart';

import 'main.dart';

class addForm extends StatefulWidget {
  const addForm({super.key});

  @override
  State<addForm> createState() => _addFormState();
}

class _addFormState extends State<addForm> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Form'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: name,
                decoration: InputDecoration(hintText: 'Enter name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: email,
                decoration: InputDecoration(hintText: 'Enter email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: gender,
                decoration: InputDecoration(hintText: 'Enter gender'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () async {
                  ContactinfoModel contactinfoModel = ContactinfoModel(
                      id: null,
                      userId: 1,
                      name: name.text,
                      email: email.text,
                      gender: gender.text,
                      createdAt: DateTime.now().toString());
                  await Controller().addData(contactinfoModel).then((value) {
                    if (value > 0) {
                      print("Success");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    } else {
                      print("faild");
                    }
                  });
                },
                child: Text("Save"),
              ),
            ),
          ],
        ));
  }
}
