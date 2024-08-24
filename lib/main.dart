//
// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:untitled1/Views/HomeScreen.dart';
import 'package:untitled1/Views/LoginView.dart';
import 'package:untitled1/Views/RegisterView.dart';
import 'package:untitled1/Views/VerifyEmailView.dart';
import 'package:untitled1/Views/testing.dart';
import 'package:untitled1/services/auth/auth_service.dart';
import 'dart:developer' as devtools
    show log; // personalizing the log in-build function as devtools.log
import 'Constants/routes.dart';
import 'Views/notes_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthServices.firebase().initialize();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'First app',
    theme: ThemeData(
      primarySwatch: Colors.lightBlue,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: HomeScreen(), // Add this line to specify the home screen

    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyEmailView(''),
      notesRoute:(context) => const NotesView(),
    },
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // future: Future.value(),

      future: AuthServices.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthServices.firebase().currentUser;
            if (user != null) {
              final String? userEmail = AuthServices.get_email_id();  //? if user is not there // ?? if it is not assigned any value true or false then take false for instance
              if (user.isEmailVerified) {
                devtools.log("Email is Verified");
                return const NotesView();
              } else {
                return VerifyEmailView(userEmail?? 'null');
              }
            } else {
              return const LoginView();
            }

          default: //waiting state
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

