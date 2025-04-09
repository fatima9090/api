import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  _StudentFormPageState createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  late Database _db;
  List<Map<String, dynamic>> studentList = [];

  final Map<String, TextEditingController> controllers = {
    "studentname": TextEditingController(),
    "fathername": TextEditingController(),
    "progname": TextEditingController(),
    "shift": TextEditingController(),
    "rollno": TextEditingController(),
    "coursecode": TextEditingController(),
    "coursetitle": TextEditingController(),
    "credithours": TextEditingController(),
    "obtainedmarks": TextEditingController(),
    "mysemester": TextEditingController(),
    "consider_status": TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    initDb();
  }

  Future<void> initDb() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'students.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE students (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentname TEXT,
            fathername TEXT,
            progname TEXT,
            shift TEXT,
            rollno TEXT,
            coursecode TEXT,
            coursetitle TEXT,
            credithours TEXT,
            obtainedmarks TEXT,
            mysemester TEXT,
            consider_status TEXT
          )
        ''');
      },
    );
    fetchStudents();
  }

  Future<void> saveStudent() async {
    await _db.insert('students', {
      for (var entry in controllers.entries) entry.key: entry.value.text,
    });
    controllers.forEach((key, controller) => controller.clear());
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final List<Map<String, dynamic>> data = await _db.query('students');
    setState(() {
      studentList = data;
    });
  }

  Future<void> resetFieldsAndDeleteData() async {
    controllers.forEach((key, controller) => controller.clear());
    await _db.delete('students'); // delete all data
    fetchStudents();
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Form'),
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              child: Column(
                children: controllers.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: TextFormField(
                      controller: entry.value,
                      decoration: InputDecoration(
                        labelText: entry.key,
                        filled: true,
                        fillColor: Colors.yellow[100],
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: saveStudent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: resetFieldsAndDeleteData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            studentList.isEmpty
                ? const Text('No data found.')
                : Column(
              children: studentList.map((student) {
                return Card(
                  color: Colors.yellow[100],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controllers.keys.map((key) {
                        return Text(
                          "$key: ${student[key] ?? ''}",
                          style: const TextStyle(fontSize: 14),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
