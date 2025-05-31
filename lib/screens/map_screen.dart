import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _startLatLng;
  late LatLng _endLatLng;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _loading = false;
  bool _initialized = false;

  final String _googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      // For now, use default coordinates if args are null or incomplete
      _startLatLng = LatLng(43.6532, -79.3832);
      _endLatLng = LatLng(43.651070, -79.347015);

      // TODO: Optionally, parse actual coordinates from args or geocode addresses
      // e.g., _startLatLng = parseCoordinates(args['fromCoordinates']);
      // _endLatLng = parseCoordinates(args['toCoordinates']);

      _setMarkers();
      _fetchPolyline();
      _initialized = true;
    }
  }

  void _setMarkers() {
    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId('start'),
          position: _startLatLng,
          infoWindow: InfoWindow(title: 'Start'),
        ),
        Marker(
          markerId: MarkerId('end'),
          position: _endLatLng,
          infoWindow: InfoWindow(title: 'End'),
        ),
      };
    });
  }

  Future<void> _fetchPolyline() async {
    setState(() {
      _loading = true;
    });
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_startLatLng.latitude},${_startLatLng.longitude}&destination=${_endLatLng.latitude},${_endLatLng.longitude}&key=$_googleApiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final points = json['routes'][0]['overview_polyline']['points'];
      List<PointLatLng> result = PolylinePoints().decodePolyline(points);
      setState(() {
        _polylines = {
          Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: result.map((p) => LatLng(p.latitude, p.longitude)).toList(),
          ),
        };
        _loading = false;
      });
    } else {
      print('Failed to fetch directions: ${response.statusCode}');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Google Map Preview",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _startLatLng,
              zoom: 13,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
          ),
          if (_loading)
            Container(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}