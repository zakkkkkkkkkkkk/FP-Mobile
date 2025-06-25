// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fp_pemrograman/screens/starting_page.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart'; // Import Mapbox
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Atur Access Token Mapbox di sini
  MapboxOptions.setAccessToken("YOUR_MAPBOX_ACCESS_TOKEN");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DermAI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StartingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}