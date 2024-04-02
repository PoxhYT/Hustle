// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hustle/api/auth_api.dart';
import 'package:hustle/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    AuthAPI authAPI = AuthAPI();

    return Center(
      child: GestureDetector(
        child: const Text("Login with google"),
        onTap: () async{
          await authAPI.signInWithGoogle();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
                  },
      ),
    );
  }
}