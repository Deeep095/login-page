import 'package:flutter/material.dart';
import 'package:untitled1/Constants/routes.dart';
import 'package:untitled1/services/auth/auth_service.dart';
import 'package:untitled1/services/auth/auth_user.dart';
import 'dart:developer' as devtools
    show log; // personalizing the log in-build function as devtools.log

import '../Utilities/showErrorDialog.dart';

import 'package:untitled1/Utilities/showErrorDialog.dart';

import '../services/auth/auth_excepions.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _MyAppLoginState();
}

class _MyAppLoginState extends State<LoginView> {
  late final TextEditingController
      _email; // late means not ready right now but promise that it will be assigned something
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  //after initialize we need to dispose it so override dispose

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // bool isValidEmail(String email) {
  //   return RegExp(
  //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //       .hasMatch(email);
  // }
  //
  // bool isValidPassword(String password) {
  //   // Minimum 8 characters, at least one uppercase letter, one lowercase letter, one number and one special character
  //   return RegExp(
  //           r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
  //       .hasMatch(password);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          "Login ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your email id here",
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password id here",
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                final user = AuthServices.firebase().logIn(email: email, password: password);
                print(AuthServices.firebase().currentUser?.isEmailVerified);
                if (AuthServices.firebase().currentUser!.isEmailVerified) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Successfully logged in')),
                  );
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verify Email-id')),
                  );
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundException {
                devtools.log('User Not Found');
                await showErrorDialog(context, 'User Not Found');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'User not found. Please check your email address.')),
                );
              } on WrongPasswordAuthException {
                devtools.log('Wrong Password');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Wrong password. Please try again.')),
                );
              } on GenericAuthException {
                devtools.log('Generic Auth Exception');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Generic Auth Exception')),
                );
              } catch (e) {
                devtools.log("Unexpected error: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('An unexpected error occurred.')),
                );
              }
              //   on FirebaseAuthException catch (e) {
              //   else if (e.code == 'invalid-email') {
              //       devtools.log('Invalid Email');
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(content: Text('Invalid email address.')),
              //       );
              //     } else if (e.code == 'user-disabled') {
              //       devtools.log('User Disabled');
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(
              //             content: Text('This user has been disabled.')),
              //       );
              //     } else if (e.code == 'invalid-credential') {
              //       devtools.log('Invalid Credential');
              //       devtools.log(e.runtimeType.toString());
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(
              //             content: Text(
              //                 'The credential is invalid or has expired. Please try again.')),
              //       );
              //     } else {
              //     }
              //   } catch (e) {
              //     devtools.log("Unexpected error: $e");
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //           content: Text('An unexpected error occurred.')),
              //     );
              //   }
            },
            child: const Text("Click to login",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                ); // can cause error as register view may not have scaffold
              },
              child:
                  const Text("New User?! Not Registered Yet !! Click here ")),
        ],
      ),
    );
  }
}

