// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hustle/api/auth_api.dart';
import 'package:hustle/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  final FirebaseFirestore firebaseFirestore;
  const LoginScreen({super.key, required this.firebaseFirestore});

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
            MaterialPageRoute(builder: (context) => MainScreen(firebaseFirestore: FirebaseFirestore.instance)),
          );
                  },
      ),
    );
  }
}