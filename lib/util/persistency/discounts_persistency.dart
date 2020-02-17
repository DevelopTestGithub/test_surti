
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:surtiSP/models/discount.dart';
import 'package:surtiSP/models/discount_group.dart';
import 'package:surtiSP/api/discount_api.dart';
import 'db_addresses.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';


class DiscountPersistent{
  final int id;
  final String name;
  final int discountType;
  final int isPercentage;
  final double discountAmount;
  final double discountPercentage;

  DiscountPersistent({
    this.id,
    this.name,
    this.discountType,
    this.isPercentage,
    this.discountAmount,
    this.discountPercentage,
});

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["discount_type"] = discountType;
    map["is_percentage"] = isPercentage;
    map["discount_amount"] = discountAmount;
    map["discount_percentage"] = discountPercentage;
    return map;
  }

}

class DiscountsP{

  Database _database;
  DiscountGroup _discounts;

  DiscountsP(){
    _createDiscountsTable();
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _createDiscountsTable();
    return _database;
  }

  _createDiscountsTable () async{
    return openDatabase(
      join(await getDatabasesPath(), DB.SURTI_PATH_DB),

      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE ${DB.DISCOUNTS_TABLE}("
              "id INTEGER PRIMARY KEY,"
              "name TEXT,"
              "discount_type INTEGER,"
              "is_percentage INTEGER"
              "amount REAL,"
              "percentage REAL,"
              ")",
        );
      },
      version: 1,
    );
  }


  Future<void> init(BuildContext context)async{
    _discounts = await DiscountsApi.getDiscountGroup(context);
    _insertDiscounts();
  }

  Future<void> _insertDiscounts() async {

    for (int i = 0; i < _discounts.discounts.length; i++) {

      DiscountPersistent _actualDiscount = DiscountPersistent(
        id: _discounts.discounts[i].id,
        name: _discounts.discounts[i].name,
        discountType: _discounts.discounts[i].discountType,
        isPercentage: _discounts.discounts[i].isPercentage ? 1 : 0,
        discountAmount: _discounts.discounts[i].discountAmount,
        discountPercentage: _discounts.discounts[i].discountPercentage,
      );

      insertDiscount(_actualDiscount);
    }

  }

  Future<void> insertDiscount(DiscountPersistent _discount) async {

    final Database db = await database;

    await db.insert(
      DB.DISCOUNTS_TABLE,
      _discount.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Discount>> discounts() async {
    // Get a reference to the database.
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(DB.DISCOUNTS_TABLE);

    return List.generate(maps.length, (i) {

      List<int> _discount = [];
      _discount.add(maps[i]['discount_id']);

      return Discount(
        id: maps[i]['id'],
        name: maps[i]['name'],
        discountType: maps[i]['discount_type'],
        isPercentage: maps[i]['is_percentage'] == 1 ? true : false,
        discountAmount: maps[i]['discount_amount'],
        discountPercentage: maps[i]['discount_percentage'],
      );
    });
  }
}
