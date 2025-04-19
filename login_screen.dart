import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'show_data_screen.dart';

class LoginScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});

  void saveDataAndNavigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", nameController.text.trim());
    await prefs.setString("email", emailController.text.trim());
    await prefs.setString("password", passwordController.text.trim());

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShowDataScreen()),
    );
  }

  void resetFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📝 Enter Info"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField("Name", nameController),
            buildTextField("Email", emailController),
            buildTextField("Password", passwordController, isPassword: true),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => saveDataAndNavigate(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: Text("Submit", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: resetFields,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: Text("Reset", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
