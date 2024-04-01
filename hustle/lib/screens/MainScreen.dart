import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hustle/api/AuthAPI.dart';
import 'package:logger/logger.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AuthAPI authAPI = AuthAPI();

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
          child: Container(
        height: 1.sh,
        color: Colors.red,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential credentials = await authAPI.signInWithGoogle();
                  logger.i("${credentials.user!.displayName!} is logged in with Google");
                } catch (e) {
                  logger.i(e);
                }
              },
              child: Text('Sign in with Google'),
            ),
          ],
        ),
      )),
    );
  }
}
