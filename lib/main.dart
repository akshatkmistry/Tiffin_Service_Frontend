import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiffin_app/providers/cart_provider.dart';
import 'package:tiffin_app/providers/order_provider.dart';
import 'package:tiffin_app/screens/auth/login_screen.dart';
import 'package:tiffin_app/screens/auth/register_screen.dart';
import 'package:tiffin_app/screens/home/home_screen.dart';
import 'package:tiffin_app/screens/splash_screen.dart';
import 'package:tiffin_app/services/auth_service.dart';
import 'package:tiffin_app/utils/constants.dart';
import 'screens/orders_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiffinry',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primaryColor,
          onPrimary: Colors.white,
          secondary: AppColors.secondaryColor,
          onSecondary: Colors.white,
          error: AppColors.errorColor,
          onError: Colors.white,
          background: AppColors.backgroundColor,
          onBackground: AppColors.primaryTextColor,
          surface: AppColors.cardColor,
          onSurface: AppColors.primaryTextColor,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(color: AppColors.primaryTextColor),
          headlineMedium: TextStyle(color: AppColors.primaryTextColor),
          bodyLarge: TextStyle(color: AppColors.primaryTextColor),
          bodyMedium: TextStyle(color: AppColors.secondaryTextColor),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        AppConstants.loginRoute: (context) => const LoginScreen(),
        AppConstants.registerRoute: (context) => const RegisterScreen(),
        AppConstants.homeRoute: (context) => const HomeScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
