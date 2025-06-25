// lib/screens/nearbyscreen.dart

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:permission_handler/permission_handler.dart';

// Nama kelas diubah agar sesuai konvensi Dart (diawali huruf besar)
class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  CameraOptions? _cameraOptions;
  MapboxMap? _mapController;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    // Meminta izin lokasi
    var status = await Permission.location.request();
    if (status.isGranted) {
      if (!await geo.Geolocator.isLocationServiceEnabled()) {
        // Jika layanan lokasi mati, buka pengaturan
        await geo.Geolocator.openLocationSettings();
      }
      try {
        // Mendapatkan posisi saat ini
        geo.Position position = await geo.Geolocator.getCurrentPosition();
        if (mounted) {
          setState(() {
            _cameraOptions = CameraOptions(
              center: Point(coordinates: Position(position.longitude, position.latitude)),
              zoom: 14,
            );
          });
        }
      } catch (e) {
        // Gagal mendapatkan lokasi, gunakan lokasi default (Surabaya)
        _setDefaultLocation();
        print("Error getting location: $e");
      }
    } else {
      // Izin ditolak, gunakan lokasi default (Surabaya)
      _setDefaultLocation();
    }
  }

  void _setDefaultLocation() {
    if (mounted) {
      setState(() {
        _cameraOptions = CameraOptions(
          center: Point(coordinates: Position(112.750885, -7.249170)), // Koordinat Surabaya
          zoom: 12,
        );
      });
    }
  }

  void _onMapCreated(MapboxMap controller) async {
    _mapController = controller;
    // Menampilkan titik biru lokasi pengguna di peta
    await _mapController?.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan loading indicator sampai lokasi didapatkan
    if (_cameraOptions == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Widget ini tidak lagi memiliki Scaffold atau AppBar, hanya MapWidget
    return MapWidget(
      cameraOptions: _cameraOptions!,
      onMapCreated: _onMapCreated,
      styleUri: MapboxStyles.MAPBOX_STREETS,
    );
  }
}