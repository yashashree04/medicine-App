import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/medi_controller.dart';
import 'package:provider/provider.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MedicineController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Medicine Reminder',
        theme: ThemeData(
          primaryColor: Colors.teal,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.teal,
            secondary: Colors.orange,
          ),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.teal),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.orange,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
