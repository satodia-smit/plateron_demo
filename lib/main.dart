import 'package:flutter/material.dart';
import 'features/home/ui/home.dart';
import 'utils/database_helper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.initializeDatabase();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      themeMode: ThemeMode.light,
      title: 'Material App',
      home: Home(),
    );
  }
}