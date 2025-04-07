import 'package:flutter/material.dart';
import 'db_help.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<Map<String, dynamic>> _grades = [];

  // Load data from API and store in database
  void _loadData() async {
    await DBHelper().fetchAndStoreData();
    _refreshData();
  }

  // Refresh data from database
  void _refreshData() async {
    List<Map<String, dynamic>> data = await DBHelper().getGrades();
    setState(() {
      _grades = data;
    });
  }

  // Erase all data from the database
  void _eraseData() async {
    await DBHelper().deleteAllData();
    _refreshData();
  }

  // Erase a specific row by ID
  void _eraseRow(int id) async {
    await DBHelper().deleteOneRow(id);
    _refreshData();
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            "API LOADED DATA",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: _grades.isEmpty
                ? Center(
              child: Text(
                "NO Data !! Press load button ⏳",
                style: TextStyle(color: Colors.black),
              ),
            )
                : ListView.builder(
              itemCount: _grades.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Number Box
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      // Data Box (Card)
                      Expanded(
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.deepPurple, // Border color
                              width: 1.5, // Border width
                            ),
                          ),
                          color: Colors.grey[400],
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              _grades[index]['studentName'] ?? "No Name",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Course: ${_grades[index]['courseTitle'] ?? 'No Title'}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                Text(
                                  "Marks: ${_grades[index]['obtainedMarks'] ?? '0'}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                Text(
                                  "Semester: ${_grades[index]['semester'] ?? 'N/A'}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Delete Button (Moved outside the card)
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.deepPurple),
                        onPressed: () =>
                            _eraseRow(_grades[index]['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _loadData,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple),
                  child: Text(
                    "Load Data⬇",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                ElevatedButton(
                  onPressed: _eraseData,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple),
                  child: Text(
                    "Erase Data❌",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}