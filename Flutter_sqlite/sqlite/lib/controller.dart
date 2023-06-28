import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

import 'ContactinfoModel.dart';
import 'databasehelper.dart';

class Controller {
  final conn = SqfliteDatabaseHelper.instance;

  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        print("Mobile data detected & internet connection confirmed.");
        return true;
      } else {
        print('No internet :( Reason:');
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print("wifi data detected & internet connection confirmed.");
        return true;
      } else {
        print('No internet :( Reason:');
        return false;
      }
    } else {
      print(
          "Neither mobile data or WIFI detected, not internet connection found.");
      return false;
    }
  }

//this function will add data from form to table
  Future<int> addData(ContactinfoModel contactinfoModel) async {
    var dbclient = await conn.db;
    int result = 0;
    try {
      result = await dbclient.insert(
          SqfliteDatabaseHelper.contactinfoTable, contactinfoModel.toJson());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

//this funtion will update the table
  Future<int> updateData(ContactinfoModel contactinfoModel, name) async {
    var dbclient = await conn.db;
    int result = 0;
    try {
      result = await dbclient.update(
          SqfliteDatabaseHelper.contactinfoTable, contactinfoModel.toJson(),
          where: 'id=?', whereArgs: [contactinfoModel.id]);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

//this function will tech all data from the table
  Future fetchData() async {
    var dbclient = await conn.db;
    List userList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient
          .query(SqfliteDatabaseHelper.contactinfoTable, orderBy: 'id DESC');
      for (var item in maps) {
        userList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return userList;
  }

//this function will delete a row from the table
  Future<int> deleteData(int id) async {
    var dbclient = await conn.db;
    int result =
        await dbclient.rawDelete('DELETE FROM contactinfoTable WHERE id = $id');
    return result;
  }
}
