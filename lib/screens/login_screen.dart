import 'package:flutter/material.dart';
import 'package:fp_pemrograman/service/auth_service.dart';
import 'package:fp_pemrograman/screens/register_screen.dart';
import 'package:fp_pemrograman/screens/home_screen.dart'; // Added this import
import 'package:fp_pemrograman/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool _isLoading = false;
  bool _isPasswordObscure = true;

  void _tryLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Call the real AuthService method
      dynamic result = await _auth.signInWithEmailAndPassword(email, password);

      if (result == null) {
        // If login fails, show an error
        setState(() {
          error = 'Could not sign in with those credentials.';
          _isLoading = false;
        });
      } else {
        // If login is successful, navigate to the HomeScreen.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
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
                    height: screenHeight * 0.75,
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
                        SizedBox(height: scaleH(250)),
                        Text(
                          'Login',
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
                        SizedBox(height: scaleH(180)),
                        Container(
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(horizontal: scaleW(100)),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
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
                                _buildLoginButton(context),
                                SizedBox(height: scaleH(160)),
                                _buildRegisterLink(context),
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

   Widget _buildLoginButton(BuildContext context) {
    double scaleH(double val) => val * MediaQuery.of(context).size.height / 1920.0;
    double scaleFont(double val) => val * min(MediaQuery.of(context).size.width / 1080.0, MediaQuery.of(context).size.height / 1920.0);
    
    return GestureDetector(
      onTap: _tryLogin,
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
            'Login',
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

  Widget _buildRegisterLink(BuildContext context) {
    double scaleFont(double val) => val * min(MediaQuery.of(context).size.width / 1080.0, MediaQuery.of(context).size.height / 1920.0);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don’t have an account?",
          style: GoogleFonts.poppins(
            fontSize: scaleFont(40),
            color: Colors.black54,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          },
          child: Text(
            'Register',
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