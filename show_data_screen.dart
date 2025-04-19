import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowDataScreen extends StatefulWidget {
  const ShowDataScreen({super.key});

  @override
  _ShowDataScreenState createState() => _ShowDataScreenState();
}

class _ShowDataScreenState extends State<ShowDataScreen> {
  String name = "", email = "", password = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? "";
      email = prefs.getString("email") ?? "";
      password = prefs.getString("password") ?? "";
    });
  }

  Future<void> resetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      name = "";
      email = "";
      password = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📦 Stored Data"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("👤 Name: $name", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("📧 Email: $email", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("🔒 Password: $password", style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: resetData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }
}
