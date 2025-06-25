import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  CameraOptions? _cameraOptions;
  MapboxMap? _mapController;
  List<Map<String, dynamic>> _dermatologists = [];
  static const String _mapboxAccessToken =
      'pk.eyJ1IjoiemFra2trayIsImEiOiJjbWFvcno4dHIwYWh0Mmxwdm95dWR2eWwyIn0.Rr8o_KwRFtBcKdObrNDUbA';

  // NEW: annotation manager & list to track pins
  PointAnnotationManager? _pointAnnotationManager;
  List<PointAnnotation> _currentAnnotations = [];

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      if (!await geo.Geolocator.isLocationServiceEnabled()) {
        await geo.Geolocator.openLocationSettings();
      }
      try {
        geo.Position position = await geo.Geolocator.getCurrentPosition();
        if (mounted) {
          _cameraOptions = CameraOptions(
            center: Point(
                coordinates: Position(position.longitude, position.latitude)),
            zoom: 14,
          );
          setState(() {});
          await _searchDermatologists(position.latitude, position.longitude);
        }
      } catch (e) {
        _setDefaultLocation();
        print("Error getting location: $e");
      }
    } else {
      _setDefaultLocation();
    }
  }

  void _setDefaultLocation() {
    final double defaultLat = -7.249170;
    final double defaultLng = 112.750885;
    if (mounted) {
      _cameraOptions = CameraOptions(
        center: Point(coordinates: Position(defaultLng, defaultLat)),
        zoom: 12,
      );
      setState(() {});
      _searchDermatologists(defaultLat, defaultLng);
    }
  }

  Future<void> _searchDermatologists(double lat, double lng) async {
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/rumah%20sakit.json'
        '?proximity=$lng,$lat'
        '&types=poi'
        '&limit=15'
        '&access_token=$_mapboxAccessToken';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final features = data['features'] as List<dynamic>;

      final nearbyDerms = features.where((feature) {
        final coords = feature['geometry']['coordinates'] as List<dynamic>;
        final double dermLng = coords[0];
        final double dermLat = coords[1];

        final distance =
            geo.Geolocator.distanceBetween(lat, lng, dermLat, dermLng);
        return distance <= 15000;
      }).toList();

      setState(() {
        _dermatologists = nearbyDerms
            .map((f) => {
                  'name': f['text'],
                  'address': f['properties']['address'] ?? 'No address',
                  'coordinates': f['geometry']['coordinates'],
                })
            .toList();
      });

      await _addDermPins();
    } else {
      print('Failed to fetch dermatologists: ${response.statusCode}');
    }
  }

  Future<void> _addDermPins() async {
    if (_mapController == null) return;

    // Create annotation manager if not exists
    _pointAnnotationManager ??=
        await _mapController!.annotations.createPointAnnotationManager();

    // Remove old pins one by one
    for (var annotation in _currentAnnotations) {
      await _pointAnnotationManager!.delete(annotation);
    }
    _currentAnnotations.clear();

    // Add new pins and track them
    for (var derm in _dermatologists) {
      final coords = derm['coordinates'] as List<dynamic>;
      final annotation =
          await _pointAnnotationManager!.create(PointAnnotationOptions(
        geometry: Point(coordinates: Position(coords[0], coords[1])),
        textField: derm['name'],
        textOffset: [0, -1.5], // text below icon
        textSize: 12,
        iconImage: 'hospital-15', // Mapbox built-in icon, change if you want
      ));
      _currentAnnotations.add(annotation);
    }
  }

  void _onMapCreated(MapboxMap controller) async {
    _mapController = controller;
    await _mapController?.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
      ),
    );

    // Add pins if derms already loaded before map created
    if (_dermatologists.isNotEmpty) {
      await _addDermPins();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraOptions == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          flex: 3,
          child: MapWidget(
            cameraOptions: _cameraOptions!,
            onMapCreated: _onMapCreated,
            styleUri: MapboxStyles.MAPBOX_STREETS,
          ),
        ),
        Expanded(
          flex: 2,
          child: _dermatologists.isEmpty
              ? const Center(child: Text('No dermatologists found nearby'))
              : ListView.builder(
                  itemCount: _dermatologists.length,
                  itemBuilder: (context, index) {
                    final derm = _dermatologists[index];
                    return ListTile(
                      title: Text(derm['name']),
                      subtitle: Text(derm['address']),
                      onTap: () {
                        final coords = derm['coordinates'] as List<dynamic>;
                        _mapController?.flyTo(
                          CameraOptions(
                            center: Point(
                                coordinates: Position(coords[0], coords[1])),
                            zoom: 16,
                          ),
                          null,
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
