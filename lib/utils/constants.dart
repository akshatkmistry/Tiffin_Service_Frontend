import 'package:flutter/material.dart';

class AppColors {
  // Primary color (green shade)
  static Color primaryColor = const Color(0xFF4CAF50);
  static Color primaryLightColor = const Color(0xFF81C784);
  static Color primaryDarkColor = const Color(0xFF388E3C);
  
  // Secondary color (orange shade)
  static Color secondaryColor = const Color(0xFFFF9800);
  static Color secondaryLightColor = const Color(0xFFFFB74D);
  static Color secondaryDarkColor = const Color(0xFFF57C00);
  
  // Text colors
  static Color primaryTextColor = const Color(0xFF212121);
  static Color secondaryTextColor = const Color(0xFF757575);
  
  // Background colors
  static Color backgroundColor = const Color(0xFFF5F5F5);
  static Color cardColor = Colors.white;
  
  // Error color
  static Color errorColor = const Color(0xFFD32F2F);
}

class AppConstants {
  // API Base URL
  static const String baseUrl = 'http://localhost:8080/api';
  
  // Shared Preferences Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String isLoggedInKey = 'false';
  static const String userEmailKey = 'user_email';
  
  // Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  
  // Assets
  static const String logoPath = 'assets/icon/logo.jpg';
  
  // Payment Gateway
  static const String razorpayKeyId = 'rzp_test_YOUR_KEY_ID'; // Replace with actual test key
}