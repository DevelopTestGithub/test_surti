

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:surtiSP/api/product_api.dart';
import 'package:surtiSP/models/image.dart';
import 'package:surtiSP/models/product.dart';
import 'package:surtiSP/models/product_group.dart';

import 'db_addresses.dart';

class ProductPersistent {
  final int id;
  final String name;
  final int imageId;
  final String imageUrl;
  final String description;
  final double price;
  final int discountId;

  ProductPersistent({
    this.id,
    this.name,
    this.imageId,
    this.imageUrl,
    this.description,
    this.price,
    this.discountId,
  });

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name; //supposed this works
    map["image_id"] = price;
    map["image_url"] = imageUrl;
    map["short_description"] = description;
    map["price"] = price;
    map["discount_id"] = discountId;
    return map;
  }

  @override
  String toString() {
    return 'Product DB {'
        'id: $id, '
        'name: $name, '
        'imageId: $imageId, '
        'imageUrl: $imageUrl, '
        'price: $price, '
        'discountId: $discountId'
        '}\n';
  }
}

class ProductsP{

  Database _database;
  ProductGroup _products;

  ProductsP(){
    _createProductsTable();
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _createProductsTable();
    return _database;
  }

  _createProductsTable () async{
    return openDatabase(
      join(await getDatabasesPath(), DB.SURTI_PATH_DB),

      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE ${DB.PRODUCTS_TABLE}("
              "id INTEGER PRIMARY KEY,"
              "name TEXT,"
              "image_id INTEGER,"
              "image_url TEXT,"
              "short_description TEXT,"
              "price REAL,"
              "discount_id INTEGER"
              ")",
        );
      },
      version: 1,
    );
  }

  Future<void> init(String _category, BuildContext context)async{
    _products = await ProductApi.getProductGroup(_category, context);
    print('--------------------------------------------------');
    print('${_products.products}');
    print('--------------------------------------------------');
    _insertProducts();
  }

  Future<void> _insertProducts() async {

    for (int i = 0; i < _products.products.length; i++) {

      ProductPersistent _actualProduct = ProductPersistent(
        id: _products.products[i].id,
        name: _products.products[i].name,
        imageUrl: _products.products[i].images[0].src,
        description: _products.products[i].description,
        discountId: 0 != _products.products[i].discountIds.length ? _products.products[i].discountIds[0] : null,
        price: _products.products[i].price,
      );

      insertProduct(_actualProduct);
    }

  }

  Future<void> insertProduct(ProductPersistent _product) async {

    final Database db = await database;

    await db.insert(
      DB.PRODUCTS_TABLE,
      _product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> products() async {
    // Get a reference to the database.
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(DB.PRODUCTS_TABLE);

    return List.generate(maps.length, (i) {

      List<ImageDataReceived> _image = [];
      _image.add(ImageDataReceived(src: maps[i]['image_url']));

      List<int> _discount = [];
      _discount.add(maps[i]['discount_id']);

      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        images: _image,
        price: maps[i]['price'],
        discountIds: _discount,
        description: maps[i]['short_description'],
      );
    });
  }

//  Future<void> updateDog(Dog dog) async {
//    // Get a reference to the database.
//    final db = await database;
//
//    // Update the given Dog.
//    await db.update(
//      DB.PROMOS,
//      dog.toMap(),
//      // Ensure that the Dog has a matching id.
//      where: "id = ?",
//      // Pass the Dog's id as a whereArg to prevent SQL injection.
//      whereArgs: [dog.id],
//    );
//  }
//
//  Future<void> deleteDog(int id) async {
//    // Get a reference to the database.
//    final db = await database;
//
//    // Remove the Dog from the database.
//    await db.delete(
//      DB.PROMOS,
//      // Use a `where` clause to delete a specific dog.
//      where: "id = ?",
//      // Pass the Dog's id as a whereArg to prevent SQL injection.
//      whereArgs: [id],
//    );
//  }

}

