import 'package:flutter/material.dart';
import 'package:fe_admin_web/screens/user_management_screen.dart';
import 'package:fe_admin_web/screens/admin_layout_screen.dart';
void main() {
  runApp(const AdminWebApp());
}

class AdminWebApp extends StatelessWidget {
  const AdminWebApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Admin Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto', // Bạn có thể thêm font chữ tùy ý sau
        primaryColor: const Color(0xFF4A7DFF),
      ),
      home: const AdminLayoutScreen(),
    );
  }
}