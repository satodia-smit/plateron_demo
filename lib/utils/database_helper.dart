// database_helper.dart
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../features/home/models/product_data_model.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  late Database _database;

  Future<void> initializeDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'your_database_name.db');

    _database = await openDatabase(
      databasePath,
      version: 2,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE cart_items (
      id TEXT PRIMARY KEY,
      name TEXT,
      description TEXT,
      price REAL,
      imageUrl TEXT,
      count INTEGER
    )
  ''');
  }
  Future<ProductDataModel?> getCartItem(String productId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'cart_items',
      where: 'id = ?',
      whereArgs: [productId],
    );

    if (maps.isNotEmpty) {
      return ProductDataModel.fromJson(maps.first);
    } else {
      return null;
    }
  }
  Future<int> getTotalItemsInCart() async {
    final result = await _database.rawQuery('SELECT SUM(count) FROM cart_items');
    final count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }
  Future<void> insertOrUpdateProduct(ProductDataModel product) async {
    // Check if the product is already in the database
    final currentProduct = await getCartItem(product.id);

    if (currentProduct != null) {
      // Product is in the database
      if (kDebugMode) {
        print("DATABASE____ Product is in db");
      }
      product.count = (currentProduct.count ?? 0) + 1;
      if (kDebugMode) {
        print("DATABASE____ Product COUNT  ${currentProduct.count}");
      }

      if (kDebugMode) {
        print("DATABASE____ Product COUNT INCREASED ${product.count}");
      }
      int rowsAffected =  await _database.update(
        'cart_items',
        product.toJson(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
      if (kDebugMode) {
        print("DATABASE____ ROWS AFFECTED IS $rowsAffected");
      }
    } else {
      // Product is not in the database
      if (kDebugMode) {
        print("DATABASE____ Product is not in DB");
      }

      product.count = 1;

      int rowsAffected = await _database.insert('cart_items', product.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      if (kDebugMode) {
        print("DATABASE____ ROWS AFFECTED IS $rowsAffected");
      }

    }
  }


  Future<void> insertProduct(ProductDataModel product) async {
    await _database.insert('cart_items', product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateProduct(ProductDataModel product) async {
    await _database.update('cart_items', product.toJson(),
        where: 'id = ?', whereArgs: [product.id]);
  }

  Future<void> deleteProduct(int productId) async {
    await _database.delete('cart_items', where: 'id = ?', whereArgs: [productId]);
  }

  Future<List<ProductDataModel>> getCartItems() async {
    final List<Map<String, dynamic>> maps = await _database.query('cart_items');

    return List.generate(maps.length, (index) {
      final map = maps[index];
      return ProductDataModel.fromJson(map);
    });
  }}
