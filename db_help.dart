import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  // Database initialization
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'grades.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create the table if not exists
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE grades(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentName TEXT,
        fatherName TEXT,
        programName TEXT,
        shift TEXT,
        rollNo TEXT,
        courseCode TEXT,
        courseTitle TEXT,
        creditHours TEXT,
        obtainedMarks TEXT,
        semester TEXT,
        status TEXT
      )
    ''');
  }

  // Fetch data from API and insert it into the database
  Future<void> fetchAndStoreData() async {
    final response = await http.get(Uri.parse('https://bgnuerp.online/api/gradeapi'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      Database db = await database;
      for (var item in data) {
        await db.insert(
          'grades',
          {
            'studentName': item['studentname'] ?? 'Unknown',
            'fatherName': item['fathername'] ?? 'Unknown',
            'programName': item['progname'] ?? 'No Program',
            'shift': item['shift'] ?? 'No Shift',
            'rollNo': item['rollno'] ?? 'No Roll No',
            'courseCode': item['coursecode'] ?? 'No Code',
            'courseTitle': item['coursetitle'] ?? 'No Title',
            'creditHours': item['credithours'] ?? '0.00',
            'obtainedMarks': item['obtainedmarks'] ?? '0.00',
            'semester': item['mysemester'] ?? 'N/A',
            'status': item['consider_status'] ?? 'N/A',
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } else {
      print('Failed to load data');
    }
  }

  // Get all grades from the database
  Future<List<Map<String, dynamic>>> getGrades() async {
    final db = await database;
    return await db.query('grades');
  }

  // Delete all data from the grades table
  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('grades');
  }

  // Delete a specific row by ID
  Future<void> deleteOneRow(int id) async {
    final db = await database;
    await db.delete('grades', where: 'id = ?', whereArgs: [id]);
  }
}
