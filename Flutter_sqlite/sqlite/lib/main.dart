import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sqlite/addform.dart';
import 'package:sqlite/controller.dart';
import 'package:sqlite/details.dart';
import 'package:sqlite/syncronize.dart';

import 'databasehelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqfliteDatabaseHelper.instance.db;
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sync Sqflite to Mysql',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();

  late List list;
  bool loading = true;
  Future userList() async {
    list = await Controller().fetchData();
    setState(() {
      loading = false;
    });
    //print(list);
  }

  Future syncToMysql() async {
    await SyncronizationData().fetchAllInfo().then((userList) async {
      EasyLoading.show(status: 'Dont close app. we are sync...');
      await SyncronizationData().saveToMysqlWith(userList);
      EasyLoading.showSuccess('Successfully save to mysql');
    });
  }

  Future isInteret() async {
    await SyncronizationData.isInternet().then((connection) {
      if (connection) {
        print("Internet connection abailale");
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No Internet")));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    userList();
    isInteret();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("Save Data to SQLite"),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh_sharp),
              onPressed: () async {
                await SyncronizationData.isInternet().then((connection) {
                  if (connection) {
                    syncToMysql();
                    print("Internet connection abailale");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No Internet")));
                  }
                });
              }),
          IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addForm()),
                );
              }),
        ],
      ),
      body: Column(
        children: [
          //add form here
          loading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, bottom: 10, top: 10),
                          child: Dismissible(
                            key: UniqueKey(),
                            // key: Key('list ${list[index]}'),
                            background: Container(color: Colors.red),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              print("Item number - ${list[index].toString()}");

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Data Deleted Successfully"),
                                ),
                              );

                              if (Controller().deleteData(list[index]['id']) ==
                                  true) {
                                setState(() {
                                  list.removeAt(index);
                                  // print(
                                  // "Item number - ${list[index].toString()}");
                                });
                              }

                              // Shows the information on Snackbar
                            },
                            child: ListTile(
                              tileColor: Colors.white,
                              leading: const Icon(Icons.person_2_rounded),
                              title: Text(list[index]['name']),
                              subtitle: Text(list[index]['email'].toString()),
                              isThreeLine: true,
                              dense: true,
                              trailing: const Icon(Icons.delete_rounded),
                              onLongPress: () {
                                //to edit
                                //print("Edit ID - ${list[index].toString()}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => detailsPage(
                                            list: list[index],
                                          )),
                                    ));
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
