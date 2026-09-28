import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homework_tracker1/views/login_screen.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
    final _emailController = TextEditingController();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Sent Password Reset Email'),
                      );
                    },
                  );
                },
                child: const Text('Reset Password'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen())
                  );
                },
                child: const Text('Back To Login'),
              ),
            ],
          ),
        ),
      );
    }
}