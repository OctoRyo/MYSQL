import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MapsPage(),
    );
  }
}

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  // Daftar lokasi
  final List<Map<String,dynamic>>locations = const [
    {
      "name": "Polman Babel",
      "address": "Sungailiat",
      "latLng": LatLng(-1.8518233015819192, 106.13099138693617),
    },
    {
      "name": "Pantai pasir padi",
      "address": "Pangkalpinang",
      "latLng": LatLng(-2.1062138147692027, 106.16912942273396),
    },
    {
      "name": "Pantai Batu ketak",
      "address": "Sungailiat",
      "latLng": LatLng(-1.899074591717491, 106.18587344871847),
    },
  ];

  void _showPlaceInfo(BuildContext context, String name, String address) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(name),
        content: Text('Alamat: $address'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final center = LatLng(-1.87, 106.15);

    return Scaffold(
      appBar: AppBar(title: const Text('Peta Lokasi')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.flutter_map_app',
          ),
          MarkerLayer(
            markers: locations.map((place) {
              return Marker(
                point: place['latLng'] as LatLng,
                width: 120,
                height: 120,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _showPlaceInfo(
                      context,
                      place['name'] as String,
                      place['address'] as String,
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          place['name'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}