import 'package:flutter/material.dart';
import '../models/route_model.dart';

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String from = args['from'];
    final String to = args['to'];
    final List<RouteOption> routes = List<RouteOption>.from(args['routes'] as List<RouteOption>);
    final topRoutes = List<RouteOption>.from(routes)..sort((a, b) => a.score.compareTo(b.score));
    final top3 = topRoutes.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Results'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'From: $from\nTo: $to',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            ...top3.map((route) => Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/map', arguments: {
                        'from': from,
                        'to': to,
                        'mode': route.mode,
                      });
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(minHeight: 48),
                      child: Row(
                        children: [
                          Text(
                            _modeIcon(route.mode),
                            style: TextStyle(fontSize: 28),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${route.mode[0].toUpperCase()}${route.mode.substring(1)}',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Distance: ${route.distanceKm} km\nTime: ${route.timeMin} min\nCO₂: ${route.co2g} g',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            label: Text('Score: ${route.score}'),
                            backgroundColor: Colors.teal.shade50,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

String _modeIcon(String mode) {
  switch (mode) {
    case 'driving':
      return '🚗';
    case 'bicycling':
      return '🚴';
    case 'transit':
      return '🚌';
    case 'walking':
      return '🚶';
    default:
      return '❓';
  }
}