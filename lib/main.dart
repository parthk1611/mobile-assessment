import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'screens/input_screen.dart';
import 'screens/results_screen.dart';
import 'screens/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load environment variables before runApp
  runApp(
    ChangeNotifierProvider(
      create: (_) => RouteProvider(),
      child: EcoRouteApp(),
    ),
  );
}

class EcoRouteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoRoute',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => InputScreen(),
        '/results': (context) => ResultsScreen(),
        '/map': (context) => MapScreen(),
      },
    );
  }
}