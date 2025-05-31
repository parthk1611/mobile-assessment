import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/route_service.dart';
import '../models/route_model.dart';

class RouteProvider extends ChangeNotifier {
  bool loading = false;
  String? error;
  List<RouteOption> routes = [];

  Future<void> findRoutes(String from, String to) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      routes = await RouteService.fetchRoutes();
    } catch (e) {
      error = 'Failed to load routes';
      routes = [];
    }

    loading = false;
    notifyListeners();
  }
}

class InputScreen extends StatelessWidget {
  final fromController = TextEditingController();
  final toController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteProvider>(context);

    void onFindRoutes() async {
      await routeProvider.findRoutes(fromController.text, toController.text);
      if (routeProvider.error == null) {
        Navigator.pushNamed(
          context,
          '/results',
          arguments: {
            'from': fromController.text,
            'to': toController.text,
            'routes': routeProvider.routes,
          },
        );
      }
    }

    bool isButtonEnabled() {
      return !routeProvider.loading &&
          fromController.text.isNotEmpty &&
          toController.text.isNotEmpty;
    }

    return Scaffold(
      appBar: AppBar(title: Text('EcoRoute')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: fromController,
                  decoration: InputDecoration(labelText: 'From'),
                  onChanged: (_) => routeProvider.notifyListeners(),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: toController,
                  decoration: InputDecoration(labelText: 'To'),
                  onChanged: (_) => routeProvider.notifyListeners(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: isButtonEnabled() ? onFindRoutes : null,
                    child: routeProvider.loading
                        ? Semantics(
                            label: 'Loading',
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Find Routes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      minimumSize: Size(48, 48), // touch target ≥48x48 dp
                      backgroundColor: isButtonEnabled() ? Colors.black : null,
                    ),
               ),
                if (routeProvider.error != null) ...[
                  SizedBox(height: 20),
                  Text(
                    routeProvider.error!,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    semanticsLabel: 'Error message',
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}