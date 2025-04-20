import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiffin_app/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${user?.name ?? 'Not available'}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Email: ${user?.email ?? 'Not available'}", style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Logout'),
              ),
            )
          ],
        ),
      ),
    );
  }
}