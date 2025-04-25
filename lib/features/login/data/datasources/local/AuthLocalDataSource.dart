
// auth_local_datasource.dart
import 'dart:convert';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/User.dart';

class AuthLocalDataSource {
  static const String _userKey = 'user_data';
  static const String _dbName = 'onyx_delivery.db';
  static const int _dbVersion = 1;
  
  // Database tables
  static const String _ordersTable = 'orders';
  static const String _statusTypesTable = 'status_types';
  static const String _returnReasonsTable = 'return_reasons';

  Database? _database;

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  // Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // Orders table
    await db.execute('''
      CREATE TABLE $_ordersTable (
        id TEXT PRIMARY KEY,
        customerId TEXT,
        customerName TEXT,
        address TEXT,
        amount REAL,
        date TEXT,
        status TEXT,
        processedFlag TEXT,
        items TEXT,
        deliveryNo TEXT
      )
    ''');

    // Status types table
    await db.execute('''
      CREATE TABLE $_statusTypesTable (
        id TEXT PRIMARY KEY,
        name TEXT,
        flagValue TEXT,
        langNo TEXT
      )
    ''');

    // Return reasons table
    await db.execute('''
      CREATE TABLE $_returnReasonsTable (
        id TEXT PRIMARY KEY,
        reason TEXT,
        langNo TEXT
      )
    ''');
  }

  // User data operations using SharedPreferences
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Orders operations
  Future<void> saveOrders(List<Map<String, dynamic>> orders, String deliveryNo) async {
    final db = await database;
    final batch = db.batch();

    // First delete existing orders for this delivery person
    await db.delete(
      _ordersTable,
      where: 'deliveryNo = ?',
      whereArgs: [deliveryNo],
    );

    // Then insert new orders
    for (var order in orders) {
      // Convert items list to JSON string if it exists
      if (order['items'] != null && order['items'] is List) {
        order['items'] = jsonEncode(order['items']);
      }
      
      order['deliveryNo'] = deliveryNo;
      batch.insert(_ordersTable, order, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getOrders(String deliveryNo) async {
    final db = await database;
    final results = await db.query(
      _ordersTable,
      where: 'deliveryNo = ?',
      whereArgs: [deliveryNo],
    );

    return results.map((item) {
      // Parse items back from JSON string if it exists
      if (item['items'] != null) {
        try {
          item['items'] = jsonDecode(item['items'].toString());
        } catch (e) {
          // Keep as is if can't parse
        }
      }
      return item;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getFilteredOrders({
    required String deliveryNo,
    String? status,
    String? customerId,
    String? date,
  }) async {
    final db = await database;
    
    // Build dynamic WHERE clause
    List<String> whereConditions = ['deliveryNo = ?'];
    List<dynamic> whereArgs = [deliveryNo];
    
    if (status != null && status.isNotEmpty) {
      whereConditions.add('status = ?');
      whereArgs.add(status);
    }
    
    if (customerId != null && customerId.isNotEmpty) {
      whereConditions.add('customerId = ?');
      whereArgs.add(customerId);
    }
    
    if (date != null && date.isNotEmpty) {
      whereConditions.add('date LIKE ?');
      whereArgs.add('$date%'); // Use LIKE for date prefix matching
    }
    
    final String whereClause = whereConditions.join(' AND ');
    
    // Execute query with SQL statement
    final results = await db.rawQuery(
      'SELECT * FROM $_ordersTable WHERE $whereClause ORDER BY date DESC',
      whereArgs,
    );

    return results.map((item) {
      // Parse items back from JSON string if it exists
      if (item['items'] != null) {
        try {
          item['items'] = jsonDecode(item['items'].toString());
        } catch (e) {
          // Keep as is if can't parse
        }
      }
      return item;
    }).toList();
  }

  // Status types operations
  Future<void> saveStatusTypes(List<Map<String, dynamic>> statusTypes, String langNo) async {
    final db = await database;
    final batch = db.batch();

    // First delete existing status types for this language
    await db.delete(
      _statusTypesTable,
      where: 'langNo = ?',
      whereArgs: [langNo],
    );

    // Then insert new status types
    for (var status in statusTypes) {
      status['langNo'] = langNo;
      batch.insert(_statusTypesTable, status, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getStatusTypes(String langNo) async {
    final db = await database;
    return await db.query(
      _statusTypesTable,
      where: 'langNo = ?',
      whereArgs: [langNo],
    );
  }

  // Return reasons operations
  Future<void> saveReturnReasons(List<Map<String, dynamic>> reasons, String langNo) async {
    final db = await database;
    final batch = db.batch();

    // First delete existing reasons for this language
    await db.delete(
      _returnReasonsTable,
      where: 'langNo = ?',
      whereArgs: [langNo],
    );

    // Then insert new reasons
    for (var reason in reasons) {
      reason['langNo'] = langNo;
      batch.insert(_returnReasonsTable, reason, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getReturnReasons(String langNo) async {
    final db = await database;
    return await db.query(
      _returnReasonsTable,
      where: 'langNo = ?',
      whereArgs: [langNo],
    );
  }

  // Clear all data
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(_ordersTable);
    await db.delete(_statusTypesTable);
    await db.delete(_returnReasonsTable);
  }
}