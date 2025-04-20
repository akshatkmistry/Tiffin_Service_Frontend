import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiffin_app/models/user_model.dart';
import 'package:tiffin_app/utils/constants.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  
  User? get currentUser => _currentUser;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/health'),
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Connection timed out');
        },
      );
      
      _isConnected = response.statusCode == 200;
      notifyListeners();
      
      if (!_isConnected) {
        debugPrint('Backend server is not responding properly. Status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }
      
      return _isConnected;
    } catch (e) {
      _isConnected = false;
      String errorMessage = 'Failed to connect to backend server';
      
      if (e is TimeoutException) {
        errorMessage = 'Connection timed out. Please check if the backend server is running at ${AppConstants.baseUrl}';
      } else if (e is SocketException) {
        errorMessage = 'Cannot reach the server. Please verify the backend is running at ${AppConstants.baseUrl}';
      }
      
      debugPrint('$errorMessage\nError details: $e');
      notifyListeners();
      return false;
    }
  }

  // Enhanced error handling for API calls
  String _getErrorMessage(dynamic error) {
    if (error is TimeoutException) {
      return 'Request timed out. Please check your internet connection and try again.';
    } else if (error is SocketException) {
      return 'Cannot connect to the server. Please check if the backend is running at ${AppConstants.baseUrl}';
    } else if (error is http.ClientException) {
      return 'Network error occurred. Please check your connection and try again.';
    } else if (error is FormatException) {
      return 'Invalid response format from server. Please try again later.';
    }
    return 'An unexpected error occurred: $error';
  }
  
  // Login with email and password
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Login request timed out'),
      );
      
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // Save user info to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.userEmailKey, email);
        await prefs.setBool('isLoggedIn', true);
        
        // Update current user and notify listeners
        _currentUser = User(
          id: '',  // Backend doesn't return these fields in login response
          name: '',
          email: email,
          phone: '',
        );
        notifyListeners();
        
        return {
          'success': true,
          'message': responseData['message'] ?? 'Login successful',
        };
      } else {
        final errorMessage = responseData['error'] ?? 'Login failed';
        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
  
  // Register new user
  Future<Map<String, dynamic>> register(String name, String email, String phone, String password) async {
    try {
      // Validate required fields
      if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'All fields are required',
        };
      }

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'ph_no': phone,  // Changed to match backend DTO field name
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Registration request timed out'),
      );
      
      if (response.body.isEmpty) {
        throw FormatException('Empty response from server');
      }
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Registration successful. Please check your email for verification code.',
          'email': responseData['email'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['error'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      debugPrint('Registration Error: $e');
      return {
        'success': false,
        'message': _getErrorMessage(e),
      };
    }
  }
  
  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp(String email, String verificationCode) async {
    try {
      // Validate verification code format
      if (verificationCode.isEmpty) {
        return {
          'success': false,
          'message': 'Verification code cannot be empty',
        };
      }
      
      // Ensure verification code is in valid UUID format
      if (!RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$').hasMatch(verificationCode.toLowerCase())) {
        return {
          'success': false,
          'message': 'Invalid verification code format',
        };
      }

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'verificationCode': verificationCode,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Verification request timed out'),
      );
      
      if (response.body.isEmpty) {
        throw FormatException('Empty response from server');
      }
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Email verified successfully. Please login.',
        };
      } else {
        return {
          'success': false,
          'message': responseData['error'] ?? 'Verification failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e),
      };
    }
  }
  
  // Resend OTP
  Future<Map<String, dynamic>> resendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/resend-verification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Resend verification request timed out'),
      );
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Verification code sent successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['error'] ?? 'Failed to resend verification code',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
  
  // Logout user
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/logout'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Logout request timed out'),
      );

      final responseData = jsonDecode(response.body);
      
      // Clear local storage and state regardless of response
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _currentUser = null;
      notifyListeners();

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Logged out successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseData['error'] ?? 'Logout failed',
        };
      }
    } catch (e) {
      // Still clear local storage and state on error
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _currentUser = null;
      notifyListeners();
      
      return {
        'success': false,
        'message': _getErrorMessage(e),
      };
    }
  }

  // Check session status
  Future<Map<String, dynamic>> checkSession() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/auth/check-session'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Check session request timed out'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final bool isLoggedIn = responseData['loggedIn'] ?? false;
        
        if (isLoggedIn) {
          final String email = responseData['email'];
          _currentUser = User(email: email, id: '', name: '', phone: '');
          
          // Update SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(AppConstants.userEmailKey, email);
          await prefs.setBool(AppConstants.isLoggedInKey, true);
        } else {
          _currentUser = null;
          // Clear SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
        }
        
        notifyListeners();
        return {
          'success': true,
          'isLoggedIn': isLoggedIn,
          'email': isLoggedIn ? responseData['email'] : null,
        };
      } else {
        return {
          'success': false,
          'isLoggedIn': false,
          'message': 'Failed to check session status',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'isLoggedIn': false,
        'message': _getErrorMessage(e),
      };
    }
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }
  
  // Get current user
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(AppConstants.userIdKey);
    final userName = prefs.getString(AppConstants.userNameKey);
    final userEmail = prefs.getString(AppConstants.userEmailKey);
    
    if (userId != null && userName != null && userEmail != null) {
      return User(
        id: userId,
        name: userName,
        email: userEmail,
        phone: '', // Phone is not stored in SharedPreferences
      );
    }
    
    return null;
  }
}