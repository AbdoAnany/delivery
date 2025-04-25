import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/Order.dart';

class DatabaseHelper {
  static const _databaseName = "DeliveryApp.db";
  static const _databaseVersion = 1;

  static const tableOrders = 'orders';
  static const columnId = 'id';
  // Add other columns as per API response

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableOrders (
        $columnId INTEGER PRIMARY KEY,
        bill_serial TEXT,
        customer_name TEXT,
        address TEXT,
        status TEXT,
        processed_flag TEXT
        // Add other fields from API
      )
    ''');
  }

  Future<int> insertOrders(List<DeliveryBill> orders) async {
    Database db = await instance.database;
    Batch batch = db.batch();

    for (var order in orders) {
      batch.insert(tableOrders, order.toJson());
    }

    await batch.commit();
    return orders.length;
  }

  Future<List<DeliveryBill>> getFilteredOrders({String? status, String? searchQuery}) async {
    Database db = await instance.database;
    String where = '1=1';
    List<dynamic> whereArgs = [];

    if (status != null && status.isNotEmpty) {
      where += ' AND status = ?';
      whereArgs.add(status);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      where += ' AND (customer_name LIKE ? OR bill_serial LIKE ?)';
      whereArgs.add('%$searchQuery%');
      whereArgs.add('%$searchQuery%');
    }

    List<Map<String, dynamic>> maps = await db.query(
      tableOrders,
      where: where,
      whereArgs: whereArgs,
    );

    return maps.map((map) => DeliveryBill.fromJson(map)).toList();
  }
}