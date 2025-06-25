// lib/screens/profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fp_pemrograman/screens/change_password_screen.dart';
import 'package:fp_pemrograman/screens/login_screen.dart';
import 'package:fp_pemrograman/service/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final AuthService _authService = AuthService();
  File? _imageFile;
  String? _profileImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _profileImageUrl = _currentUser?.photoURL;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _uploadProfilePicture();
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_imageFile == null || _currentUser == null) return;
    setState(() => _isLoading = true);
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${_currentUser.uid}.jpg');
      await storageRef.putFile(_imageFile!);
      final downloadURL = await storageRef.getDownloadURL();
      await _currentUser.updatePhotoURL(downloadURL);
      await _currentUser.reload();
      if (mounted) {
        setState(() => _profileImageUrl = downloadURL);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- PERBAIKAN WARNA ---
    const Color bgColorTop = Color(0xFFFFF7E8);
    const Color bgColorBottom = Color(0xFFDCAC93);
    const Color fullNameColor = Color(0xFFB7603C);
    const Color emailColor = Color(0xFF224B4C);
    const Color optionsBoxColor = Color(0xFFF9EADA);
    const Color iconColor = Color(0xFFB7603C);

    return Container(
      // --- PERBAIKAN 1: GRADIENT BACKGROUND ---
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColorTop, bgColorBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: emailColor)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: emailColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        // --- PERBAIKAN 2: LAYOUT TURUN & POSISI TEKS DI TENGAH ---
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            width: double.infinity, // Memastikan Column bisa melebarkan diri
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Memusatkan semua anak secara horizontal
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : null,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : _profileImageUrl == null
                                ? Icon(Icons.person, size: 60, color: Colors.grey.shade400)
                                : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: iconColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _currentUser?.displayName ?? 'User Name',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: fullNameColor),
                ),
                const SizedBox(height: 5),
                Text(
                  _currentUser?.email ?? 'user@example.com',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 16, color: emailColor),
                ),
                const SizedBox(height: 40),
                
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: optionsBoxColor, // Warna kotak sesuai permintaan
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildProfileOption(
                        icon: Icons.lock_outline,
                        title: 'Change Password',
                        iconColor: iconColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                          );
                        },
                      ),
                      const Divider(indent: 20, endIndent: 20),
                      _buildProfileOption(
                        icon: Icons.logout,
                        title: 'Logout',
                        iconColor: iconColor, // Warna ikon logout disamakan
                        onTap: _handleLogout,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    // --- PERBAIKAN 4: GAYA LOGOUT DISAMAKAN ---
    final Color textColor = Colors.grey.shade800;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade600),
      onTap: onTap,
    );
  }
}