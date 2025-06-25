// lib/screens/change_password_screen.dart

import 'package:flutter/material.dart';
import 'package:fp_pemrograman/service/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("New passwords do not match."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final result = await _authService.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: result.contains("successfully") ? Colors.green : Colors.red,
          ),
        );

        if (result == "Password updated successfully.") {
          Navigator.of(context).pop();
        }
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- PERUBAHAN: Menyamakan skema warna dengan Profile Screen ---
    const Color bgColorTop = Color(0xFFFFF7E8);
    const Color bgColorBottom = Color(0xFFDCAC93);
    const Color textColor = Color(0xFF224B4C);
    const Color buttonColor = Color(0xFFB7603C);
    const Color fieldColor = Color(0xFFF9EADA);

    return Container(
      // --- PERUBAHAN: Latar Belakang Gradien ---
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColorTop, bgColorBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // --- PERUBAHAN: AppBar dibuat transparan ---
        appBar: AppBar(
          title: Text('Change Password', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: textColor)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _currentPasswordController,
                  hintText: 'Current Password',
                  fieldColor: fieldColor,
                  validator: (val) => val!.isEmpty ? 'Please enter your current password' : null,
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _newPasswordController,
                  hintText: 'New Password',
                  fieldColor: fieldColor,
                  validator: (val) => val!.length < 6 ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm New Password',
                  fieldColor: fieldColor,
                  validator: (val) => val!.isEmpty ? 'Please confirm your new password' : null,
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        // --- PERUBAHAN: Tombol disesuaikan warnanya ---
                        child: ElevatedButton(
                          onPressed: _handleChangePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Update Password',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required Color fieldColor,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        // --- PERUBAHAN: Warna isian field ---
        fillColor: fieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      ),
    );
  }
}