import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopping/constants.dart';
import 'package:shopping/screens/home_page.dart';
import 'package:shopping/screens/login_page.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // If snapshot has error
        if(snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        if(snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {

              // If stream snapshot has error
              if(snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }

              if(streamSnapshot.connectionState == ConnectionState.active) {
                //get the user
                Object? _user = streamSnapshot.data;
                //user is not logged in, head to login
                if(_user == null) {
                  return LoginPage();
                }
                //user is logged in, head to homepage
                else {
                  return HomePage();
                }
              }

              //checking the auth state - Loading
              return Scaffold(
                body: Center(
                  child: Text(
                    "Checking Authentication...",
                    style: Constants.regularHeading,
                  ),
                ),
              );

            },
          );
        }

        else {
          return Scaffold(
            body: Center(
              child: Text(
                "Initializing App",
                style: Constants.regularHeading,
              ),
            ),
          );
        }

      },
    );
  }
}
