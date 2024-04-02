import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hustle/api/AuthAPI.dart';
import 'package:hustle/screens/MainScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    AuthAPI authAPI = AuthAPI();

    return Container(
      child: Center(
        child: GestureDetector(
          child: Text("Login with google"),
          onTap: () async{
            UserCredential userCredential = await authAPI.signInWithGoogle();
            if(userCredential != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            }
          },
        ),
      ),
    );
  }
}