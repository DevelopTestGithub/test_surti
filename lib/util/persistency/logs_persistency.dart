import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:surtiSP/api/product_api.dart';
import 'package:surtiSP/models/image.dart';
import 'package:surtiSP/models/log_api.dart';
import 'package:surtiSP/models/product.dart';
import 'package:surtiSP/models/product_group.dart';
import 'package:surtiSP/util/user_Controller.dart';

import 'db_addresses.dart';


class LogsPersistency{
  Database _database;
  LogActions _logActions;

  LogsPersistency(){
    _createLogTable();
  }
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _createLogTable();
    return _database;
  }
  _createLogTable () async{
    return openDatabase(
      join(await getDatabasesPath(), DB.SURTI_PATH_DB),

      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE if not exists ${DB.LOGS}("
              "id INTEGER PRIMARY KEY autoincrement,"
              "className TEXT,"
              "methodName INTEGER,"
              "text TEXT,"
              "action TEXT,"
              "user TEXT,"
              "product TEXT,"
              "dateTime TEXT"
              ")",
        );
      },
      version: 1,
    );
  }
  Future<void> init(LogActions _log, BuildContext context)async{
    print('--------------------------------------------------');
    _logActions=_log;
    print('--------------------------------------------------');
    _insertLogs();
  }

  Future<void> _insertLogs() async {

   if(_logActions != null ){

      LogActions _actualLog = LogActions(
        className:_logActions.className,
        methodName:_logActions.methodName,
        text:_logActions.text,
        action:_logActions.action,
        product:_logActions.product,
        dateTime:_logActions.dateTime,
      );
      insertLog(_actualLog);
    }

  }
  Future<void> insertLog(LogActions _logActions) async {

    final Database db = await database;

    await db.insert(
      DB.LOGS,
      _logActions.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<LogActions>> logs() async {
    // Get a reference to the database.
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(DB.LOGS);

    return List.generate(maps.length, (i) {

      return LogActions(
        className: maps[i]['className'],
        methodName: maps[i]['methodName'],
        text: maps[i]['text'],
        action: maps[i]['action'],
        user:maps[i]['user'],
        product: maps[i]['product'],
        dateTime: maps[i]['dateTime'],
      );
    });
  }
}