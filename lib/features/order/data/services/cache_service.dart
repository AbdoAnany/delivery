import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/delivery_bill.dart';
import '../models/return_reason.dart';
import '../models/status_type.dart';

class DeliveryLocalDataSourceImpl {
  static final DeliveryLocalDataSourceImpl instance = DeliveryLocalDataSourceImpl._init();
  static Database? _database;

  DeliveryLocalDataSourceImpl._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('delivery.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Incremented version for new schema
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await _createTables(db);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createTables(db);
    }
  }

  Future _createTables(Database db) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT';
    const realType = 'REAL';
    const intType = 'INTEGER';

    // Create bills table with proper null handling
    await db.execute('''
  CREATE TABLE IF NOT EXISTS delivery_bills (
    BILL_SRL $idType,
    BILL_TYPE $textType NOT NULL,
    BILL_NO $textType NOT NULL,
    BILL_DATE $textType NOT NULL,
    BILL_TIME $textType NOT NULL,
    BILL_AMT $realType NOT NULL,
    TAX_AMT $realType NOT NULL DEFAULT 0,
    DLVRY_AMT $realType NOT NULL DEFAULT 0,
    MOBILE_NO $textType,
    CSTMR_NM $textType,
    RGN_NM $textType,
    CSTMR_BUILD_NO $textType,
    CSTMR_FLOOR_NO $textType,
    CSTMR_APRTMNT_NO $textType,
    CSTMR_ADDRSS $textType,
    LATITUDE $realType,
    LONGITUDE $realType,
    DLVRY_STATUS_FLG $textType NOT NULL DEFAULT '0',
    SYNC_STATUS $intType NOT NULL DEFAULT 0,
    LAST_UPDATED $textType NOT NULL DEFAULT (datetime('now'))
  );
''');


    // Create status types table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS status_types (
        TYP_NO $textType PRIMARY KEY,
        TYP_NM $textType NOT NULL,
        LANG_NO $textType NOT NULL DEFAULT '2'
      )
    ''');

    // Create return reasons table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS return_reasons (
        DLVRY_RTRN_RSN $textType PRIMARY KEY,
        LANG_NO $textType NOT NULL DEFAULT '2'
      )
    ''');
  }

  // ========== BILL OPERATIONS ========== //

  Future<void> insertOrUpdateBills(List<Map<String, dynamic>> bills) async {
    final db = await database;
    final batch = db.batch();

try{
  for (var bill in bills) {
    print('bill @@@@ : $bill');
    batch.insert(
      'delivery_bills',
      _mapBillToDb(bill),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }}catch(e){

    // You can log the error or throw an exception as needed
     print('Error inserting bills: $e');
  }


    await batch.commit(noResult: true);
  }

  Map<String, dynamic> _mapBillToDb(Map<String, dynamic> bill) {
    return {
      'BILL_SRL': bill['BILL_SRL'],
      'BILL_TYPE': bill['BILL_TYPE'] ?? '1',
      'BILL_NO': bill['BILL_NO'],
      'BILL_DATE': bill['BILL_DATE'],
      'BILL_TIME': bill['BILL_TIME'],
      'BILL_AMT': double.tryParse(bill['BILL_AMT']?.toString() ?? '0') ?? 0,
      'TAX_AMT': double.tryParse(bill['TAX_AMT']?.toString() ?? '0') ?? 0,
      'DLVRY_AMT': double.tryParse(bill['DLVRY_AMT']?.toString() ?? '0') ?? 0,
      'MOBILE_NO': bill['MOBILE_NO'],
      'CSTMR_NM': bill['CSTMR_NM'],
      'RGN_NM': bill['RGN_NM'],
      'CSTMR_BUILD_NO': bill['CSTMR_BUILD_NO'],
      'CSTMR_FLOOR_NO': bill['CSTMR_FLOOR_NO'],
      'CSTMR_APRTMNT_NO': bill['CSTMR_APRTMNT_NO'],
      'CSTMR_ADDRSS': bill['CSTMR_ADDRSS'],
      'LATITUDE': bill['LATITUDE'] is String && bill['LATITUDE']!.isNotEmpty
          ? double.tryParse(bill['LATITUDE']!)
          : bill['LATITUDE'] is double
          ? bill['LATITUDE']
          : null,
      'LONGITUDE': bill['LONGITUDE'] is String && bill['LONGITUDE']!.isNotEmpty
          ? double.tryParse(bill['LONGITUDE']!)
          : bill['LONGITUDE'] is double
          ? bill['LONGITUDE']
          : null,
      'DLVRY_STATUS_FLG': bill['DLVRY_STATUS_FLG'] ?? '0',
    };
  }
  Future<List<DeliveryBillModel>> getBills( {String? statusFilter}) async {
    final db = await database;

    String where = '';
    List<dynamic> args = [];

    if (statusFilter != null) {
      if (statusFilter == 'new') {
        where += ' AND DLVRY_STATUS_FLG = ?';
        args.add('0');
      } else if (statusFilter == 'others') {
        where += ' AND DLVRY_STATUS_FLG != ?';
        args.add('0');
      } else {
        where += ' AND DLVRY_STATUS_FLG = ?';
        args.add(statusFilter);
      }
    }

    // final results1 = await db.query(
    //   'delivery_bills',
    //   where: where.isNotEmpty ? where.substring(5) : null,
    //   whereArgs: args.isNotEmpty ? args : null,
    //   orderBy: 'BILL_DATE DESC, BILL_TIME DESC',
    // );
    final results = await db.query(
      'delivery_bills',
      // where: where.isNotEmpty ? where.substring(5) : null,
      // whereArgs: args.isNotEmpty ? args : null,
      // orderBy: 'BILL_DATE DESC, BILL_TIME DESC',
    );

    return results.map((json) => DeliveryBillModel.fromDb(json)).toList();
  }
  Future<List<DeliveryBillModel>> getBillsNew({
    String? statusFilter,
    String? sortBy,
    bool sortAscending = false,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];
    String orderByClause = '';

    if (statusFilter != null) {
      if (statusFilter == 'new') {
        whereClause = 'DLVRY_STATUS_FLG = ?';
        whereArgs = ['0'];
      } else if (statusFilter == 'others') {
        whereClause = 'DLVRY_STATUS_FLG != ?';
        whereArgs = ['0'];
      } else {
        whereClause = 'DLVRY_STATUS_FLG = ?';
        whereArgs = [statusFilter];
      }
    }

    if (sortBy != null && sortBy.isNotEmpty) {
      orderByClause = '$sortBy ${sortAscending ? 'ASC' : 'DESC'}';
    } else {
      orderByClause = 'BILL_DATE DESC, BILL_TIME DESC'; // Default sorting
    }

    final results = await db.query(
      'delivery_bills',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: orderByClause.isNotEmpty ? orderByClause : null,
    );

    return results.map((json) => DeliveryBillModel.fromDb(json)).toList();
  }
  Future<List<DeliveryBillModel>> getFilteredBills({
    String? statusFilter,
    String? dateFilter,
    String? searchQuery,
  }) async {
    final Database db = await database;

    // Build WHERE clause and args dynamically
    List<String> whereConditions = [];
    List<dynamic> whereArgs = [];

    // Add status filter condition if provided
    if (statusFilter != null && statusFilter.isNotEmpty) {
      if (statusFilter == 'new') {
        whereConditions.add('DLVRY_STATUS_FLG = ?');
        whereArgs.add('0');
      } else if (statusFilter == 'others') {
        whereConditions.add('DLVRY_STATUS_FLG != ?');
        whereArgs.add('0');
      } else if (statusFilter == 'delivered') {
        whereConditions.add('DLVRY_STATUS_FLG = ?');
        whereArgs.add('1');
      } else if (statusFilter == 'returned') {
        whereConditions.add('(DLVRY_STATUS_FLG = ? OR DLVRY_STATUS_FLG = ?)');
        whereArgs.add('2');
        whereArgs.add('3');
      } else {
        whereConditions.add('DLVRY_STATUS_FLG = ?');
        whereArgs.add(statusFilter);
      }
    }

    // Add date filter if provided
    if (dateFilter != null && dateFilter.isNotEmpty) {
      // Assuming dateFilter is in format 'YYYY/MM/DD' or 'DD/MM/YYYY' depending on your app's date format
      whereConditions.add('BILL_DATE = ?');
      whereArgs.add(dateFilter);
    }

    // Add search query that looks in customer name, bill number, and address
    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereConditions.add('(CSTMR_NM LIKE ? OR BILL_NO LIKE ? OR CSTMR_ADDRSS LIKE ?)');
      String likeParam = '%$searchQuery%';
      whereArgs.add(likeParam);
      whereArgs.add(likeParam);
      whereArgs.add(likeParam);
    }

    // Construct the final WHERE clause
    String? whereClause = whereConditions.isNotEmpty
        ? whereConditions.join(' AND ')
        : null;
    print('whereClause @@@@ : $whereClause');
    print('whereArgs @@@@ : $whereArgs');




    //SELECT * FROM delivery_bills WHERE
    List<Map> list = await db.rawQuery('SELECT * FROM delivery_bills');
print(list);
    final results = await db.rawQuery(
      'SELECT * FROM delivery_bills',
      // where: whereClause,
      // whereArgs: whereArgs,
      // orderBy: 'BILL_DATE DESC, BILL_TIME DESC',
    );
print('Filtered @@@@ss bills: $results');
    return results.map((json) => DeliveryBillModel.fromDb(json)).toList();
  }

  Future<int> updateBillStatus({
    required String billSrl,
    required String newStatus,
    String? returnReason,
  }) async {
    final db = await database;

    return await db.update(
      'delivery_bills',
      {
        'DLVRY_STATUS_FLG': newStatus,
        'SYNC_STATUS': 1, // Mark as needing sync
        'LAST_UPDATED': DateTime.now().toIso8601String(),
      },
      where: 'BILL_SRL = ?',
      whereArgs: [billSrl],
    );
  }

  // ========== STATUS TYPE OPERATIONS ========== //

  Future<void> insertStatusTypes(List<StatusTypeModel> types, String langNo) async {
    final db = await database;
    final batch = db.batch();

    // Clear existing types for this language
    await db.delete(
      'status_types',
      where: 'LANG_NO = ?',
      whereArgs: [langNo],
    );

    for (var type in types) {
      batch.insert(
        'status_types',
        {
          'TYP_NO': type.typNo,
          'TYP_NM': type.typNm,
          'LANG_NO': langNo,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<StatusTypeModel>> getStatusTypes(String langNo) async {
    final db = await database;
    final results = await db.query(
      'status_types',
      where: 'LANG_NO = ?',
      whereArgs: [langNo],
    );
    return results.map((json) => StatusTypeModel.fromDb(json)).toList();
  }

  // ========== RETURN REASON OPERATIONS ========== //

  Future<void> insertReturnReasons(List<ReturnReasonModel> reasons, String langNo) async {
    final db = await database;
    final batch = db.batch();

    // Clear existing reasons for this language
    await db.delete(
      'return_reasons',
      where: 'LANG_NO = ?',
      whereArgs: [langNo],
    );

    for (var reason in reasons) {
      batch.insert(
        'return_reasons',
        {
          'DLVRY_RTRN_RSN': reason.reason,
          'LANG_NO': langNo,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<ReturnReasonModel>> getReturnReasons(String langNo) async {
    final db = await database;
    final results = await db.query(
      'return_reasons',
      where: 'LANG_NO = ?',
      whereArgs: [langNo],
    );
    return results.map((json) => ReturnReasonModel.fromDb(json)).toList();
  }

  // ========== UTILITY METHODS ========== //

  Future<void> clearDeliveryData() async {
    final db = await database;
    await db.delete(
      'delivery_bills',

    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
