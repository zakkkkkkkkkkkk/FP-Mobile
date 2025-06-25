import 'package:flutter/material.dart';
import 'package:fp_pemrograman/service/auth_service.dart';
import 'package:fp_pemrograman/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';
  bool _isLoading = false;
  bool _isPasswordObscure = true; // State for password visibility
  bool _isConfirmPasswordObscure = true; // State for confirm password visibility

 void _tryRegister() async {
    if (_formKey.currentState!.validate()) {
      if (password != confirmPassword) {
        setState(() {
          error = 'Passwords do not match';
        });
        return;
      }
      setState(() {
        _isLoading = true;
        error = '';
      });
      
      // Call the real AuthService method
      dynamic result = await _auth.registerWithEmailAndPassword(fullName, email, password);

      if (result == null) {
        setState(() {
          error = 'Failed to register. Please use a valid email.';
          _isLoading = false;
        });
      } else {
        // Go back to login screen after successful registration
        Navigator.pop(context); 
      }
    }
}

  @override
  Widget build(BuildContext context) {
    final double designWidth = 1080.0;
    final double designHeight = 1920.0;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double scaleX = screenWidth / designWidth;
    final double scaleY = screenHeight / designHeight;

    double scaleW(double val) => val * scaleX;
    double scaleH(double val) => val * scaleY;
    double scaleFont(double val) => val * min(scaleX, scaleY);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: scaleW(80)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.backgroundLighter,
                        AppColors.accentBrown,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.8,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLightest,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(scaleW(120)),
                        topRight: Radius.circular(scaleW(120)),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: scaleH(220)),
                        Text(
                          'Register',
                          style: GoogleFonts.poppins(
                            fontSize: scaleFont(120),
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryOrange,
                            shadows: [
                              Shadow(
                                blurRadius: 4.0,
                                color: Colors.black.withOpacity(0.25),
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: scaleH(120)),
                        Container(
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(horizontal: scaleW(100)),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildTextFieldWithIcon(
                                  context: context,
                                  hint: 'Full Name',
                                  icon: Icons.person_outline,
                                  onChanged: (val) => fullName = val,
                                  validator: (val) => val!.isEmpty ? 'Enter your full name' : null,
                                ),
                                SizedBox(height: scaleH(50)),
                                _buildTextFieldWithIcon(
                                  context: context,
                                  hint: 'Enter your email',
                                  icon: Icons.email_outlined,
                                  onChanged: (val) => email = val,
                                  validator: (val) => val!.isEmpty ? 'Please enter an email' : null,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: scaleH(50)),
                                _buildTextFieldWithIcon(
                                  context: context,
                                  hint: 'Enter password',
                                  icon: Icons.lock_outline,
                                  obscureText: _isPasswordObscure,
                                  onChanged: (val) => password = val,
                                  validator: (val) => val!.length < 6 ? 'Password must be 6+ characters' : null,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordObscure ? Icons.visibility_off : Icons.visibility,
                                      color: AppColors.primaryOrange,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordObscure = !_isPasswordObscure;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height: scaleH(50)),
                                _buildTextFieldWithIcon(
                                  context: context,
                                  hint: 'Confirm password',
                                  icon: Icons.lock_outline,
                                  obscureText: _isConfirmPasswordObscure,
                                  onChanged: (val) => confirmPassword = val,
                                  validator: (val) => val!.isEmpty ? 'Confirm your password' : null,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isConfirmPasswordObscure ? Icons.visibility_off : Icons.visibility,
                                      color: AppColors.primaryOrange,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height: scaleH(80)),
                                _buildRegisterButton(context),
                                SizedBox(height: scaleH(80)),
                                _buildLoginLink(context),
                                if (error.isNotEmpty) ...[
                                  SizedBox(height: scaleH(20)),
                                  Text(
                                    error,
                                    style: TextStyle(color: AppColors.primaryOrange, fontSize: scaleFont(30)),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTextFieldWithIcon({
    required BuildContext context,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    double scaleFont(double val) => val * min(MediaQuery.of(context).size.width / 1080.0, MediaQuery.of(context).size.height / 1920.0);
    
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: scaleFont(40), color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primaryOrange),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: scaleFont(40), color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20.0),
      ),
    );
  }

   Widget _buildRegisterButton(BuildContext context) {
    double scaleH(double val) => val * MediaQuery.of(context).size.height / 1920.0;
    double scaleFont(double val) => val * min(MediaQuery.of(context).size.width / 1080.0, MediaQuery.of(context).size.height / 1920.0);
    
    return GestureDetector(
      onTap: _tryRegister,
      child: Container(
        width: double.infinity,
        height: scaleH(160),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.secondaryTeal, AppColors.darkTeal],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Register',
            style: GoogleFonts.poppins(
              fontSize: scaleFont(50),
              fontWeight: FontWeight.bold,
              color: AppColors.backgroundLightest,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    double scaleFont(double val) => val * min(MediaQuery.of(context).size.width / 1080.0, MediaQuery.of(context).size.height / 1920.0);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: GoogleFonts.poppins(
            fontSize: scaleFont(40),
            color: Colors.black54,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Login',
            style: GoogleFonts.poppins(
              fontSize: scaleFont(40),
              fontWeight: FontWeight.bold,
              color: AppColors.primaryOrange,
            ),
          ),
        ),
      ],
    );
  }
}