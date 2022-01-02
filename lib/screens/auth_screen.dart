import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_class_demo/widgets/builder_widgets/builder_progress_indicator.dart';

import 'home_screen.dart';
final GoogleSignIn googleSignIn = GoogleSignIn();

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authStateSnapshot) {
        switch (authStateSnapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            if (authStateSnapshot.data == null) {
              return authScreen(GoogleSignInScreen());
            } else {
              return const HomeScreen();
            }
            break;

          case ConnectionState.none:
          case ConnectionState.waiting:
            return authScreen(BuilderProgressIndicator());
        }
        return const BuilderProgressIndicator();
      },
    );

  }
  Widget authScreen(Widget widget) => Scaffold(
    appBar: AppBar(
      title: const Text("Authentication Screen"),
    ),
    body: Container(
      alignment: Alignment.center,
      child: widget,
    ),
  );

  Widget GoogleSignInScreen() {
    Size devSize = MediaQuery.of(context).size;
    return Container(
      height: devSize.height * 0.5,
      width: devSize.width * 0.8,
      alignment: Alignment.center,
      child: ElevatedButton(onPressed: () async => await signInWithGoogle(), child: const Text("Sign In With Google")),
    );
  }
}
