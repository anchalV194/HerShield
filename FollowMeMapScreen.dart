import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class FollowMeMapScreen extends StatefulWidget {
  const FollowMeMapScreen({super.key, required double longitude, required double latitude});

  @override
  State<FollowMeMapScreen> createState() => _FollowMeMapScreenState();
}

class _FollowMeMapScreenState extends State<FollowMeMapScreen> {
  final Location _location = Location();
  LatLng _currentLatLng = LatLng(0, 0);
  StreamSubscription<LocationData>? _locationSubscription;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  Future<void> _startListening() async {
    final loc = await _location.getLocation();
    _currentLatLng = LatLng(loc.latitude!, loc.longitude!);
    _moveCamera();

    _locationSubscription = _location.onLocationChanged.listen((locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLatLng = LatLng(locationData.latitude!, locationData.longitude!);
        });
        _moveCamera();
      }
    });
  }

  void _moveCamera() {
    _mapController.move(_currentLatLng, 16);
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Location Tracking")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentLatLng,
          zoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _currentLatLng,
                width: 40,
                height: 40,
                child: const Icon(Icons.location_on, size: 40, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}