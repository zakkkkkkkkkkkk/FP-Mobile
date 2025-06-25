import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fp_pemrograman/colors.dart';
import 'package:fp_pemrograman/screens/scan_result_screen.dart';
import 'package:fp_pemrograman/service/firestore_service.dart'; // Import the service
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  List? _outputs;
  bool _loading = false;
  final picker = ImagePicker();
  final _firestoreService = FirestoreService(); // Instantiate the service

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/models/model_unquant.tflite",
        labels: "assets/models/labels.txt",
      );
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  Future<void> classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output;
    });

    if (_outputs != null && _outputs!.isNotEmpty) {
      final String resultLabel = _outputs![0]['label'].toString().substring(2);
      final double resultConfidence = _outputs![0]['confidence'];

      // Save the result to Firestore and Storage
      await _firestoreService.saveScanResult(
        imageFile: _image!,
        label: resultLabel,
        confidence: resultConfidence,
      );

      // Navigate to result screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScanResultScreen(
            imagePath: _image!.path,
            label: resultLabel,
            confidence: resultConfidence,
            isFilePath: true, // Let the result screen know it's a local file
          ),
        ),
      );
    }
  }

  Future<void> pickImage(ImageSource source) async {
    var image = await picker.pickImage(source: source);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
      _loading = true;
    });
    classifyImage(_image!);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Scan Skin',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios, color: AppColors.primaryOrange),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryOrange))
          : _image == null
              ? buildInitialUI()
              : buildImageSelectedUI(),
    );
  }

  Widget buildInitialUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.document_scanner_outlined,
              size: 120, color: AppColors.darkTeal),
          const SizedBox(height: 20),
          Text(
            'Select an image to scan',
            style: GoogleFonts.poppins(
                fontSize: 18, color: AppColors.darkTeal.withOpacity(0.8)),
          ),
          const SizedBox(height: 40),
          buildPickerButtons(),
        ],
      ),
    );
  }

  Widget buildImageSelectedUI() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(_image!,
                height: 300, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 30),
          Text(
            'Image selected. Rescan if needed.',
            style: GoogleFonts.poppins(
                fontSize: 16, color: AppColors.darkTeal.withOpacity(0.8)),
          ),
          const SizedBox(height: 30),
          buildPickerButtons(),
        ],
      ),
    );
  }

  Widget buildPickerButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildElevatedButton(Icons.camera_alt_outlined, 'Camera',
            () => pickImage(ImageSource.camera)),
        const SizedBox(width: 20),
        buildElevatedButton(Icons.photo_library_outlined, 'Gallery',
            () => pickImage(ImageSource.gallery)),
      ],
    );
  }

  Widget buildElevatedButton(
      IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      icon: Icon(icon),
      label: Text(label, style: GoogleFonts.poppins(fontSize: 16)),
      onPressed: onPressed,
    );
  }
}
