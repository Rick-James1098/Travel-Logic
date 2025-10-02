
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/trip_plan.dart';
import '../models/travel_record.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'travel_logic.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trip_plans(
        id TEXT PRIMARY KEY,
        title TEXT,
        destination TEXT,
        startDate TEXT,
        endDate TEXT,
        imageUrl TEXT,
        description TEXT,
        estimatedBudget INTEGER,
        isCompleted INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE travel_records(
        id TEXT PRIMARY KEY,
        tripPlanId TEXT,
        type TEXT,
        title TEXT,
        description TEXT,
        location TEXT,
        time TEXT,
        date TEXT,
        amount INTEGER,
        image TEXT,
        transportType TEXT,
        airline TEXT,
        flightNumber TEXT,
        departureTime TEXT,
        arrivalTime TEXT,
        reservationNumber TEXT,
        boardingPass TEXT,
        rentalCompany TEXT,
        vehicle TEXT,
        rentalPeriod TEXT,
        voucher TEXT,
        rentalDetails TEXT,
        trainName TEXT,
        busName TEXT,
        departure TEXT,
        arrival TEXT,
        seat TEXT,
        bookingSite TEXT,
        bookingSiteLink TEXT,
        address TEXT,
        checkIn TEXT,
        checkOut TEXT,
        FOREIGN KEY (tripPlanId) REFERENCES trip_plans(id) ON DELETE CASCADE
      )
    ''');
  }

  // TripPlan CRUD
  Future<void> insertTripPlan(TripPlan tripPlan) async {
    final db = await database;
    await db.insert('trip_plans', tripPlan.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TripPlan>> getTripPlans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('trip_plans');
    return List.generate(maps.length, (i) {
      return TripPlan.fromMap(maps[i]);
    });
  }

  Future<void> updateTripPlan(TripPlan tripPlan) async {
    final db = await database;
    await db.update(
      'trip_plans',
      tripPlan.toMap(),
      where: 'id = ?',
      whereArgs: [tripPlan.id],
    );
  }

  Future<void> deleteTripPlan(String id) async {
    final db = await database;
    await db.delete(
      'trip_plans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // TravelRecord CRUD
  Future<void> insertTravelRecord(TravelRecord record) async {
    final db = await database;
    await db.insert('travel_records', record.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TravelRecord>> getTravelRecords(String tripPlanId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'travel_records',
      where: 'tripPlanId = ?',
      whereArgs: [tripPlanId],
    );
    return List.generate(maps.length, (i) {
      return TravelRecord.fromMap(maps[i]);
    });
  }

  Future<void> updateTravelRecord(TravelRecord record) async {
    final db = await database;
    await db.update(
      'travel_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<void> deleteTravelRecord(String id) async {
    final db = await database;
    await db.delete(
      'travel_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
