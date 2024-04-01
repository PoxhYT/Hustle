import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthAPI {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  String? getUID() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  String? getDisplayName() {
    return FirebaseAuth.instance.currentUser?.displayName;  
  }

  String? getPofilePicture() {
    return FirebaseAuth.instance.currentUser?.photoURL;
  }
}
