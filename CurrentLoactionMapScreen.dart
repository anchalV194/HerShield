import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class CurrentLocationMapScreen extends StatefulWidget {
  const CurrentLocationMapScreen({super.key});

  @override
  State<CurrentLocationMapScreen> createState() => _CurrentLocationMapScreenState();
}

class _CurrentLocationMapScreenState extends State<CurrentLocationMapScreen> {
  LatLng? _currentLatLng;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLatLng = LatLng(position.latitude, position.longitude);
      });
    } else {
      // Permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currentLatLng == null
            ? const Center(child: CircularProgressIndicator())
            :FlutterMap(
          options: MapOptions(
            center: _currentLatLng,
            zoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentLatLng!,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.my_location, color: Colors.blue, size: 40),
                ),
              ],
            ),
          ],
        )

    );
  }
}