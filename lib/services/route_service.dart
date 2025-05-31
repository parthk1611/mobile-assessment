import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/route_model.dart';

class RouteService {
  static Future<List<RouteOption>> fetchRoutes() async {
    try {
      final String response = await rootBundle.loadString('assets/routes.json');
      final List data = json.decode(response);
      return data.map((item) => RouteOption.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load routes: $e');
    }
  }
}